package mensa

import (
	"fmt"
	"log"
	"regexp"
	"strconv"

	"github.com/abourget/slick"
	"github.com/kiliankoe/swdd/speiseplan"
	"github.com/robfig/cron"
)

var defaultMensa = speiseplan.AlteMensa
var mensaChannelName = "mensa"

// Mensa as in omnomnom.
// This automatically posts today's menu in #mensa at 10:30 on every workday.
// Commands:
//   !mensa - omnom @ Alte Mensa
//   !mensa <mensa> - omnom @ <mensa>
//   !mensa bild <nr> - Show an image of meal <nr>, only supports Alte Mensa
type Mensa struct{}

func init() {
	slick.RegisterPlugin(&Mensa{})
}

// InitPlugin ...
func (mensa *Mensa) InitPlugin(bot *slick.Bot) {
	c := cron.New()
	c.AddFunc("00 30 10 * * 1-5", func() {
		meals, _, err := speiseplan.GetCurrentForCanteen(defaultMensa)
		if err != nil {
			bot.SendToChannel(mensaChannelName, "Konnte für heute leider keine Mensadaten laden 😓")
			return
		}

		output := formatOutput(meals, defaultMensa)
		bot.SendToChannel(mensaChannelName, output)
	})
	c.Start()

	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!mensa$"),
		MessageHandlerFunc: mensa.MensaHandler,
	})
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!mensa (.*)"),
		MessageHandlerFunc: mensa.MensaHandler,
	})
	bot.Listen(&slick.Listener{
		// TODO: Mensa Name here should be optional and default to defaultMensa
		Matches:            regexp.MustCompile("^!mensabild (.*) (\\d+)"),
		MessageHandlerFunc: mensa.MealImageHandler,
	})
}

// MensaHandler ...
func (mensa *Mensa) MensaHandler(listen *slick.Listener, msg *slick.Message) {
	log.Println("Mensa menu requested by", msg.FromUser.Name)

	mensaName := defaultMensa
	if len(msg.Match) > 1 {
		mensaName = msg.Match[1]
	}

	meals, actualName, err := speiseplan.GetCurrentForCanteen(mensaName)

	if err != nil {
		msg.Reply("Konnte leider keine Mensadaten abrufen 😵.", err)
		return
	}
	output := formatOutput(meals, actualName)
	msg.Reply(output)
}

func formatOutput(meals []*speiseplan.Meal, mensaName string) (output string) {
	output += fmt.Sprintf("Heute @ *%s*:\n", mensaName)
	for idx, meal := range meals {
		output += fmt.Sprintf("%d: %s", idx, meal.Name)
		if meal.StudentPrice > 0 {
			output += fmt.Sprintf(" - %.2f€", meal.StudentPrice)
		}
		output += "\n"
	}
	return
}

var notesEmoji = map[string]string{
	"Rindfleisch":     ":cow:",
	"Schweinefleisch": ":pig:",
	"vegetarisch":     ":tomato:",
	"vegan":           ":herb:",
	"Alkohol":         ":wine_glass:",
	"Knoblauch":       ":garlic:",
}

// MealImageHandler ...
func (mensa *Mensa) MealImageHandler(listen *slick.Listener, msg *slick.Message) {
	log.Println("Meal image", msg.Match[2], "@", msg.Match[1], "requested by", msg.FromUser.Name)

	mensaName := msg.Match[1]
	idx, _ := strconv.Atoi(msg.Match[2])
	meals, _, err := speiseplan.GetCurrentForCanteen(mensaName)

	if err != nil {
		msg.Reply("Konnte leider keine Mensadaten abrufen 😵.", err)
		return
	}

	if idx >= len(meals) {
		msg.Reply("So viele Mahlzeiten hab' ich gar nicht auf dem Schirm.")
		return
	}

	msg.Reply(meals[idx].ImageURL)
}
