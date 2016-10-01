package btc

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"regexp"

	"github.com/abourget/slick"
)

type btc struct{}

func (btc *btc) String() string {
	return `!btc - Aktueller Bitcoin Kurs`
}

func init() {
	slick.RegisterPlugin(&btc{})
}

// InitPlugin ...
func (btc *btc) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!btc"),
		MessageHandlerFunc: btc.btcHandler,
	})
}

func (btc *btc) btcHandler(listen *slick.Listener, msg *slick.Message) {
	resp, err := http.Get("https://api.coinbase.com/v2/exchange-rates?currency=BTC")
	if err != nil {
		log.Println(err)
		return
	}

	defer resp.Body.Close()

	response, _ := ioutil.ReadAll(resp.Body)

	var coinbase coinbaseResponse
	err = json.Unmarshal(response, &coinbase)
	if err != nil {
		log.Println(err)
		return
	}

	chartURL := "http://bitcoincharts.com/charts/chart.png?width=940&m=bitstampUSD&SubmitButton=Draw&r=10&i=&c=0&s=&e=&Prev=&Next=&t=M&b=&a1=SMA&m1=10&a2=&m2=25&x=0&i1=&i2=&i3=&i4=&v=0&cv=0&ps=0&l=0&p=0&"
	msg.Reply(fmt.Sprintf("Aktueller Bitcoin Kurs: %s€\n%s", coinbase.Data.Rates.EUR, chartURL))
}

type coinbaseResponse struct {
	Data struct {
		Rates struct {
			EUR string
		}
	}
}
