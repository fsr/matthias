package maintain

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"time"

	"github.com/abourget/slick"
)

type maintain struct{}

func init() {
	slick.RegisterPlugin(&maintain{})
}

// InitPlugin ...
func (maintain *maintain) InitPlugin(bot *slick.Bot) {
	var conf struct {
		Maintain struct {
			Username string
		}
	}

	bot.LoadConfig(&conf)

	bot.Listen(&slick.Listener{
		Matches: regexp.MustCompile("^!exit"),
		MessageHandlerFunc: func(l *slick.Listener, m *slick.Message) {
			if m.FromUser.Name != conf.Maintain.Username {
				return
			}
			m.Reply("Cya")
			time.Sleep(1 * time.Second)
			log.Println("Got !exit command from", m.FromUser.Name)
			os.Exit(0)
		},
	})

	bot.Listen(&slick.Listener{
		Matches: regexp.MustCompile("^!plugins"),
		MessageHandlerFunc: func(l *slick.Listener, m *slick.Message) {
			if m.FromUser.Name != conf.Maintain.Username {
				return
			}
			log.Println("Got !plugins command from", m.FromUser.Name)
			m.ReplyPrivately("Currently loaded plugins:")
			for _, plugin := range slick.RegisteredPlugins() {
				m.ReplyPrivately(fmt.Sprintf("%T", plugin))
			}
		},
	})

	bot.Listen(&slick.Listener{
		Matches: regexp.MustCompile("^!config"),
		MessageHandlerFunc: func(l *slick.Listener, m *slick.Message) {
			if m.FromUser.Name != conf.Maintain.Username {
				return
			}
			log.Println("Got !config command from", m.FromUser.Name)

			dat, err := ioutil.ReadFile(os.Getenv("HOME") + "/.matthias.conf")
			if err != nil {
				m.ReplyPrivately("Can't find production config")
				m.ReplyPrivately(err.Error())
			} else {
				m.ReplyPrivately("Production config:")
				m.ReplyPrivately(string(dat))
			}

			dat, err = ioutil.ReadFile(os.Getenv("PWD") + "/matthias_dev.conf")
			if err != nil {
				m.ReplyPrivately("Can't find develop config")
				m.ReplyPrivately(err.Error())
			} else {
				m.ReplyPrivately("Develop config:")
				m.ReplyPrivately(string(dat))
			}
		},
	})
}
