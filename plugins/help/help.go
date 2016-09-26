package help

import (
	"fmt"
	"regexp"

	"github.com/abourget/slick"
)

type help struct{}

func (help *help) String() string {
	return `!help - Alles auflisten, was matthias aktuell für dich tun kann`
}

func init() {
	slick.RegisterPlugin(&help{})
}

// InitPlugin ...
func (help *help) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!help"),
		MessageHandlerFunc: help.helpHandler,
	})
}

func (help *help) helpHandler(listen *slick.Listener, msg *slick.Message) {
	output := ""
	for _, plugin := range slick.RegisteredPlugins() {
		helpText := fmt.Sprintf("%s", plugin)
		if helpText != "&{}" {
			output += helpText
			output += "\n"
		}
	}
	msg.ReplyPrivately(output)
}
