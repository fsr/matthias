package porn

import (
	"log"
	"math/rand"
	"regexp"
	"strings"

	"github.com/abourget/slick"
)

type porn struct{}

func (porn *porn) String() string {
	return `!porn me - Random Porn Titel
!porn <name> - Random Porn Titel mit <name>`
}

func init() {
	slick.RegisterPlugin(&porn{})
}

// InitPlugin ...
func (porn *porn) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!porn (.+)"),
		MessageHandlerFunc: porn.pornHandler,
	})
}

func (porn *porn) pornHandler(listen *slick.Listener, msg *slick.Message) {
	log.Println("Porn request for", msg.Match[1], "from", msg.FromUser.Name)

	name := msg.Match[1]
	var title string
	if name == "me" {
		name = strings.Title(msg.FromUser.Name)
		title = strings.Replace(randomPornTitle(true), "{target}", name, -1)
	} else {
		name = strings.Title(name)
		title = strings.Replace(randomPornTitle(false), "{target}", name, -1)
	}
	msg.Reply(title)
}

func randomPornTitle(all bool) string {
	if all {
		targetedPornTitles = append(targetedPornTitles, pornTitles...)
	}
	return targetedPornTitles[randomIndex(len(targetedPornTitles))]
}

func randomIndex(length int) int {
	return rand.Intn(length)
}
