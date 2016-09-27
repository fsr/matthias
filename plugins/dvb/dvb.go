package dvb

import (
	"fmt"
	"regexp"
	"strconv"

	"github.com/abourget/slick"
	vvo "github.com/kiliankoe/dvbgo"
)

type dvb struct{}

func (dvb *dvb) String() string {
	return `!dvb <hst> - Gebe Liste der nächsten Abfahrten von <hst> aus.
	!dvb <hst> in <x> - Selbes wie !dvb <hst>, nur mit <x> Minuten offset.`
}

func init() {
	slick.RegisterPlugin(&dvb{})
}

// InitPlugin ...
func (dvb *dvb) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!dvb (\\D*)$"),
		MessageHandlerFunc: dvb.departureHandler,
	})
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!dvb\\s+(.*)in (\\d*)"),
		MessageHandlerFunc: dvb.departureHandler,
	})
}

func (dvb *dvb) departureHandler(listen *slick.Listener, msg *slick.Message) {
	query := msg.Match[1]

	offset := 0
	if len(msg.Match) > 2 {
		value, err := strconv.Atoi(msg.Match[2])
		if err == nil {
			offset = value
		}
	}

	departures, err := vvo.Monitor(query, offset, "")
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
