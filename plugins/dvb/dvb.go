package dvb

import (
	"fmt"
	"log"
	"regexp"

	"github.com/abourget/slick"
	vvo "github.com/kiliankoe/dvbgo"
)

// DVB ...
// Commands:
// !dvb <stop> - Return list of upcoming departures from stop
type DVB struct{}

func init() {
	slick.RegisterPlugin(&DVB{})
}

// InitPlugin ...
func (dvb *DVB) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!dvb (.*)"),
		MessageHandlerFunc: dvb.DepartureHandler,
	})
}

// DepartureHandler ...
func (dvb *DVB) DepartureHandler(listen *slick.Listener, msg *slick.Message) {
	query := msg.Match[1]
	log.Println("DVB monitor for", query, "requested by", msg.FromUser.Name)

	departures, err := vvo.Monitor(query, 0, "")
	if err != nil {
		msg.Reply("Unerwarteter Fehler 😱", err)
	}

	output := formatOutput(departures, query)

	msg.Reply(output)
}

func formatOutput(departures []*vvo.Departure, stopName string) (output string) {
	output += fmt.Sprintf("Nächste Abfahrten @ *%s*:\n", stopName)
	amount := 5
	if len(departures) < 5 {
		amount = len(departures)
	}
	for _, departure := range departures[:amount] {
		output += departure.String()
		output += "\n"
	}
	return
}
