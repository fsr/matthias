package random

import (
	"fmt"
	"log"
	"regexp"

	"github.com/abourget/slick"

	r "github.com/fsr/matthias/util/random"
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
	log.Println("Bash Quote requested by", msg.FromUser.Name)
	randomID := r.Int(950)
	msg.Reply(fmt.Sprintf("http://bash.fsrleaks.de/?%d", randomID))
}

func (random *random) insultHandler(listen *slick.Listener, msg *slick.Message) {
	log.Println(msg.FromUser.Name, "insulted matthias with", msg.Match[1])
	msg.ReplyMention(fmt.Sprintf("Deine Mudda ist %s!", msg.Match[1]))
}

func (random *random) String() string {
	return `!bash - Link zu einem zufälligen Bashzitat`
}
