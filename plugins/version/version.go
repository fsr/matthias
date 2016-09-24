package version

import (
	"regexp"

	"github.com/abourget/slick"
)

// this var is set via a linker flag, it doesn't have to edited by hand
// just make sure to use make instead of go when running or building
var gitVersion = "latest"

type version struct{}

func (version *version) String() string {
	return `!version - Welche Version von matthias läuft gerade?`
}

func init() {
	slick.RegisterPlugin(&version{})
}

// InitPlugin ...
func (version *version) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches: regexp.MustCompile("^!version"),
		MessageHandlerFunc: func(l *slick.Listener, m *slick.Message) {
			m.Reply(gitVersion)
		},
	})
}
