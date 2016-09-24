package drsommer

import (
	"fmt"
	"regexp"

	"github.com/abourget/slick"
	"github.com/fsr/matthias/util/random"
)

var drsommerChannel string

type drsommer struct{}

func init() {
	slick.RegisterPlugin(&drsommer{})
}

var robot *slick.Bot

// InitPlugin ...
func (drsommer *drsommer) InitPlugin(bot *slick.Bot) {
	var conf struct {
		DrSommer struct {
			Channel string
		}
	}

	bot.LoadConfig(&conf)

	drsommerChannel = conf.DrSommer.Channel

	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("(?i)^(?:hey |hallo |lieber )?dr\\.? sommer,?"),
		MessageHandlerFunc: drsommer.chatHandler,
	})

	robot = bot
}

func (drsommer *drsommer) chatHandler(listen *slick.Listener, msg *slick.Message) {
	question := fmt.Sprintf("\"%s\" - %s (%d)", msg.Text, random.StringFromList(names), random.IntBetween(10, 15))
	robot.SendToChannel(drsommerChannel, question)
}

var names = []string{
	"Shantalle",
	"Schackeline",
	"Tamara",
	"Cindy",
	"Jenny",
	"Clair-Gina",
	"Justin",
	"Jerome",
	"Chantal",
	"Jacqueline",
	"Yves",
	"Sylvia",
	"Claudia",
	"Dörte",
}
