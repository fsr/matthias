package maintain

import (
	"fmt"
	"io/ioutil"
	"log"
	"net"
	"net/http"
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
			log.Println("Got !exit command from", m.FromUser.Name)
			time.Sleep(1 * time.Second)
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

			plugins := "Currently loaded plugins:\n"
			for _, plugin := range slick.RegisteredPlugins() {
				plugins += fmt.Sprintf("%T", plugin)
			}
			m.ReplyPrivately(plugins)
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

	bot.Listen(&slick.Listener{
		Matches: regexp.MustCompile("^!ip"),
		MessageHandlerFunc: func(l *slick.Listener, m *slick.Message) {
			if m.FromUser.Name != conf.Maintain.Username {
				return
			}
			log.Println("Got !ip command from", m.FromUser.Name)

			m.ReplyPrivately(fmt.Sprintf("Local IP: %s\nExternal IP: %s", getLocalIP(), getExternalIP()))
		},
	})
}

func getLocalIP() string {
	addrs, err := net.InterfaceAddrs()
	if err != nil {
		return ""
	}
	for _, address := range addrs {
		// check the address type and if it is not a loopback the display it
		if ipnet, ok := address.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				return ipnet.IP.String()
			}
		}
	}
	return ""
}

func getExternalIP() string {
	resp, _ := http.Get("http://canihazip.com/s")
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	return string(body)
}
