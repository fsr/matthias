package random

import (
	"fmt"
	"math/rand"
	"regexp"

	"github.com/abourget/slick"
)

type random struct{}

func init() {
	slick.RegisterPlugin(&random{})
}

// InitPlugin ...
func (random *random) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!bash"),
		MessageHandlerFunc: random.bashHandler,
	})
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("matthias ist (.*)"),
		MessageHandlerFunc: random.insultHandler,
	})
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("matthias,? du bist (.*)"),
		MessageHandlerFunc: random.insultHandler,
	})
}

func (random *random) bashHandler(listen *slick.Listener, msg *slick.Message) {
	randomID := rand.Intn(950)
	msg.Reply(fmt.Sprintf("http://bash.fsrleaks.de/?%d", randomID))
}

func (random *random) insultHandler(listen *slick.Listener, msg *slick.Message) {
	msg.ReplyMention(fmt.Sprintf("Deine Mudda ist %s!", msg.Match[1]))
}

func (random *random) String() string {
	return `!bash - Link zu einem zufälligen Bashzitat`
}
