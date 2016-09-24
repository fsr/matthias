package fsr

import (
	"io/ioutil"
	"net/http"
	"regexp"

	"github.com/abourget/slick"
)

type fsr struct{}

func (fsr *fsr) String() string {
	return `!jemand/wer da? - Ist gerade jemand im Büro?`
}

func init() {
	slick.RegisterPlugin(&fsr{})
}

// InitPlugin ...
func (fsr *fsr) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!(?:jemand|wer) da(?:\\?)?"),
		MessageHandlerFunc: fsr.isOfficeOpenHandler,
	})
	bot.Listen(&slick.Listener{
		Matches: regexp.MustCompile("!b(?:ü|ue)rostatus"),
		MessageHandlerFunc: func(l *slick.Listener, m *slick.Message) {
			m.Reply("https://www.ifsr.de/buerostatus/image.php?h=6")
		},
	})
	bot.Listen(&slick.Listener{
		Matches: regexp.MustCompile("!protokoll"),
		MessageHandlerFunc: func(l *slick.Listener, m *slick.Message) {
			m.Reply("https://www.ifsr.de/protokolle/current.pdf")
		},
	})
}

func (fsr *fsr) isOfficeOpenHandler(listen *slick.Listener, msg *slick.Message) {
	isOpen, err := isOfficeOpen()
	if err != nil {
		msg.Reply("Keine Ahnung... Ich schieb' die Schuld mal auf @sebastian.")
	}
	if isOpen {
		msg.AddReaction("+1")
	} else {
		msg.AddReaction("-1")
	}
}

func isOfficeOpen() (bool, error) {
	resp, err := http.Get("https://www.ifsr.de/buerostatus/output.php")
	defer resp.Body.Close()
	if err != nil {
		return false, err
	}
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return false, err
	}

	if string(body) == "1" {
		return true, nil
	}
	return false, nil
}
