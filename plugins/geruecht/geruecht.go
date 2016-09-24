package geruecht

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"regexp"

	"github.com/abourget/slick"
)

var username string
var password string

type geruecht struct{}

func (geruecht *geruecht) String() string {
	return `!gerücht - Gib ein zufälliges Gerücht zurück`
}

func init() {
	slick.RegisterPlugin(&geruecht{})
}

// InitPlugin ...
func (geruecht *geruecht) InitPlugin(bot *slick.Bot) {
	var conf struct {
		Geruecht struct {
			Username string
			Password string
		}
	}

	bot.LoadConfig(&conf)

	username = conf.Geruecht.Username
	password = conf.Geruecht.Password

	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!ger(?:ü|ue)cht"),
		MessageHandlerFunc: geruecht.geruechtHandler,
	})
}

func (geruecht *geruecht) geruechtHandler(listen *slick.Listener, msg *slick.Message) {
	// previous coffeescript code, here for reference:
	//		$ = cheerio.load body
	//		geruecht = $('div').text().replace /Psst\.\.\./, ""
	//		geruecht = geruecht.trim()
	//		geruecht = msg.random(prefixes) + geruecht
	//		msg.send geruecht
}

func loadRumor() (string, error) {
	url := fmt.Sprintf("http://%s:%s@leaks.fsrleaks.de/index.php", username, password)
	resp, err := http.Get(url)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	_, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}
	// TODO Get the rumor out of the html
	// Prefix it with a random prefix
	// return it
	return "", nil
}

var prefixes = []string{
	"Also... Ich hab ja Folgendes gehört: ",
	"Pssht... ",
	"Ein kleines Vögelchen hat mir gezwitschert: ",
	"Die BILD Zeitung soll ja das hier morgen als Titelstory haben: ",
	"Böse Zungen behaupten ja: ",
	"Bei Fefe stand letzte Woche: ",
	"Also bei Sebi in der BRAVO Girl stand ja letztens: ",
}
