package bday

import (
	"time"

	"github.com/abourget/slick"
	"github.com/robfig/cron"
)

type bday struct{}

func init() {
	slick.RegisterPlugin(&bday{})
}

// InitPlugin ...
func (bday *bday) InitPlugin(bot *slick.Bot) {
	var conf struct {
		Bday struct {
			CongratsChannel string
			CronTime        string
		}
	}

	bot.LoadConfig(&conf)

	c := cron.New()
	c.AddFunc(conf.Bday.CronTime, func() {
		output := generateOutput()
		bot.SendToChannel(conf.Bday.CongratsChannel, output)
	})
	c.Start()
}

func generateOutput() string {
	output := "Alles Gute "
	bdays := todaysBirthdays()
	if len(bdays) == 1 {
		output += bdays[0]
	} else {
		output += bdays[0]
		for _, name := range bdays[1:] {
			output += ", "
			output += name
		}
	}
	output += " 🎉🎉🎉"
	return output
}

func todaysBirthdays() []string {
	var list []string
	today := time.Now().Format("02.01.")
	for name, birthday := range birthdays {
		if birthday == today {
			list = append(list, name)
		}
	}
	return list
}

var birthdays = map[string]string{
	"Katja":    "06.02.",
	"Philipp":  "21.02.",
	"Soenke":   "27.03.",
	"Lucasv":   "30.04.",
	"Marc":     "25.06.",
	"Kilian":   "17.07.",
	"Matthias": "02.04.",
	"Justus":   "17.11.",
	"Felix":    "30.11.",
}
