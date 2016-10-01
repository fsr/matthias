package elbe

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"regexp"

	"github.com/abourget/slick"
)

type elbe struct{}

func (elbe *elbe) String() string {
	return `!elbe - Aktuellen Elbpegel ausgeben
!elbechart - Elbpegel der letzten Woche als Grafik`
}

func init() {
	slick.RegisterPlugin(&elbe{})
}

// InitPlugin ...
func (elbe *elbe) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!elbe$"),
		MessageHandlerFunc: elbe.pegelHandler,
	})
	bot.Listen(&slick.Listener{
		Matches: regexp.MustCompile("^!elbechart"),
		MessageHandlerFunc: func(l *slick.Listener, m *slick.Message) {
			m.Reply("http://www.pegelonline.wsv.de/webservices/rest-api/v2/stations/DRESDEN/W/measurements.png?start=P7D&width=900&height=400")
		},
	})
}

func (elbe *elbe) pegelHandler(listen *slick.Listener, msg *slick.Message) {
	resp, err := http.Get("http://www.pegelonline.wsv.de/webservices/rest-api/v2/stations/DRESDEN.json?includeTimeseries=true&includeCurrentMeasurement=true")
	if err != nil {
		msg.Reply(fmt.Sprintf("Kann aktuell leider nicht nachschauen: %s", err))
		return
	}
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	var pegel pegelResponse
	err = json.Unmarshal(body, &pegel)
	if err != nil {
		msg.Reply(fmt.Sprintf("Kann aktuell leider nicht nachschauen: %s", err))
		return
	}
	msg.Reply(generateOutput(pegel))
}

func generateOutput(pegel pegelResponse) string {
	output := "Aktueller Elbpegel: "
	output += fmt.Sprintf("%.0f", pegel.Timeseries[0].CurrentMeasurement.Value)
	output += pegel.Timeseries[0].Unit
	output += " - Tendenz: "
	trend := pegel.Timeseries[0].CurrentMeasurement.Trend
	if trend < 0 {
		output += "fallend"
	} else if trend == 0 {
		output += "gleichbleibend"
	} else {
		output += "steigend"
	}
	return output
}

type pegelResponse struct {
	Timeseries []struct {
		CurrentMeasurement struct {
			Trend int     `json:"trend"`
			Value float64 `json:"value"`
		} `json:"currentMeasurement"`
		Unit string `json:"unit"`
	} `json:"timeseries"`
}
