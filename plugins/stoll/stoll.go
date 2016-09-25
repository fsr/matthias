package stoll

import (
	"regexp"

	"github.com/abourget/slick"
	"github.com/fsr/matthias/util/random"
)

type stoll struct{}

func (stoll *stoll) String() string {
	return `!stoll - Zufälliges Dr. Axel Stoll (RIP) Zitat`
}

func init() {
	slick.RegisterPlugin(&stoll{})
}

// InitPlugin ...
func (stoll *stoll) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!stoll"),
		MessageHandlerFunc: stoll.stollHandler,
	})
}

func (stoll *stoll) stollHandler(listen *slick.Listener, msg *slick.Message) {
	// var quotes []string
	// bytes, err := ioutil.ReadFile("./plugins/stoll/stolls.json")
	// if err != nil {
	// 	msg.Reply("Meine Liste an Dr. Axel Stoll Zitaten ist nicht da 😓")
	// }
	// err = json.Unmarshal(bytes, &quotes)
	// if err != nil {
	// 	msg.Reply("Meine Liste an Dr. Axel Stoll Zitaten ist nicht lesbar 😭")
	// }
	msg.Reply(random.StringFromList(quotes))
}
