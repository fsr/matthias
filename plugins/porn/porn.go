package porn

import (
	"regexp"
	"strings"

	"github.com/abourget/slick"
	"github.com/fsr/matthias/util/random"
)

type porn struct{}

func (porn *porn) String() string {
	return `!porn - Random Porn Titel
!porn <name> - Random Porn Titel mit <name>`
}

func init() {
	slick.RegisterPlugin(&porn{})
}

// InitPlugin ...
func (porn *porn) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!porn(.+)?"),
		MessageHandlerFunc: porn.pornHandler,
	})
}

func (porn *porn) pornHandler(listen *slick.Listener, msg *slick.Message) {
	hasTarget := msg.Match[1] != ""

	name := ""
	if hasTarget {
		name = msg.Match[1][1:] // The leading space is in the capture group as well
		if name == "me" {
			name = msg.FromUser.Name
		}
		name = strings.Title(name)
	}

	var pornTitle string
	if hasTarget {
		pornTitle = strings.Replace(randomPornTitle(true), "{target}", name, -1)
	} else {
		pornTitle = randomPornTitle(false)
	}
	msg.Reply(pornTitle)
}

func randomPornTitle(targeted bool) string {
	if targeted {
		return random.StringFromList(targetedPornTitles)
	}
	return random.StringFromList(pornTitles)
}
