package urbandictionary

import (
	"regexp"

	ud "github.com/StalkR/goircbot/lib/urbandictionary"
	"github.com/abourget/slick"
)

type urbandictionary struct{}

func (urban *urbandictionary) String() string {
	return `!urban <begriff> - Sucht die Top Definition auf Urbandictionary heraus`
}

func init() {
	slick.RegisterPlugin(&urbandictionary{})
}

// InitPlugin ...
func (urban *urbandictionary) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!urban( me)? (.*)"),
		MessageHandlerFunc: urban.defineHandler,
	})
}

func (urban *urbandictionary) defineHandler(listen *slick.Listener, msg *slick.Message) {
	result, err := ud.Define(msg.Match[2])
	if err != nil || len(result.List) == 0 {
		msg.Reply("Unerwarteter Fehler ⚠️", err)
		return
	}
	top := result.List[0]

	msg.Reply(top.String())
}
