package random

import (
	"fmt"
	"log"
	"math/rand"
	"regexp"
	"time"

	"github.com/abourget/slick"
)

// Random stuff not fitting in anywhere else.
// Commands:
// !bash - Return a random bash quote link
type Random struct{}

func init() {
	slick.RegisterPlugin(&Random{})
}

// InitPlugin ...
func (random *Random) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!bash"),
		MessageHandlerFunc: random.BashHandler,
	})
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("matthias ist (.*)"),
		MessageHandlerFunc: random.InsultHandler,
	})
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("matthias,? du bist (.*)"),
		MessageHandlerFunc: random.InsultHandler,
	})
}

// BashHandler ...
func (random *Random) BashHandler(listen *slick.Listener, msg *slick.Message) {
	log.Println("Bash Quote requested by", msg.FromUser.Name)
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	randomID := r.Intn(950)
	msg.Reply(fmt.Sprintf("http://bash.fsrleaks.de/?%d", randomID))
}

// InsultHandler ...
func (random *Random) InsultHandler(listen *slick.Listener, msg *slick.Message) {
	log.Println(msg.FromUser.Name, "insulted matthias with", msg.Match[1])
	msg.ReplyMention(fmt.Sprintf("Deine Mudda ist %s!", msg.Match[1]))
}
