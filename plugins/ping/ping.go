package ping

import (
	"regexp"

	"github.com/abourget/slick"
)

type ping struct{}

func (ping *ping) String() string {
	return `!ping - pong!`
}

func init() {
	slick.RegisterPlugin(&ping{})
}

// InitPlugin ...
func (ping *ping) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches: regexp.MustCompile("^!ping"),
		MessageHandlerFunc: func(l *slick.Listener, m *slick.Message) {
			m.Reply("pong!")
		},
	})
}

// TODO: Actual ping!
// use: ping -c5 -i0.1 {ip} -q
// or better: https://github.com/tatsushid/go-fastping
