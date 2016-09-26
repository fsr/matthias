package googleimages

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"regexp"

	"github.com/abourget/slick"
)

type googleimages struct{}

// FYI: The Google CSE API limits access via IP. So should this plugin ever not
// be working, be sure to check that it's not just that.

func (images *googleimages) String() string {
	return `!image/img (me) <suchbegriff> - Gibt ein Zufallsbild der Google Bildersuche zum <suchbegriff> aus
!animate (me) <suchbegriff> - Gibt ein Zufallsgif der Google Bildersuche zum <suchbegriff> aus`
}

var cseID string
var cseKey string

var fallbackImage = "http://i.giphy.com/10tIjpzIu8fe0.gif"

func init() {
	slick.RegisterPlugin(&googleimages{})
}

// InitPlugin ...
func (images *googleimages) InitPlugin(bot *slick.Bot) {
	var conf struct {
		GoogleImages struct {
			CseID  string
			CseKey string
		}
	}

	bot.LoadConfig(&conf)

	cseID = conf.GoogleImages.CseID
	cseKey = conf.GoogleImages.CseKey

	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!((?:image|img)|animate)(?: me)? (.*)"),
		MessageHandlerFunc: images.imageHandler,
	})
}

func (images *googleimages) imageHandler(listen *slick.Listener, msg *slick.Message) {
	query := msg.Match[2]
	animated := msg.Match[1] == "animated"

	url, err := imageMe(query, animated)
	if err != nil {
		msg.Reply(err.Error())
		msg.Reply(url)
	} else {
		msg.Reply(url)
	}
}

func imageMe(query string, animated bool) (string, error) {
	req, _ := http.NewRequest("GET", "https://www.googleapis.com/customsearch/v1", nil)
	q := req.URL.Query()
	q.Add("q", query)
	q.Add("searchType", "image")
	q.Add("safe", "high") // Sure about this? allowed are high, medium, off
	q.Add("fields", "items(link)")
	q.Add("cx", cseID)
	q.Add("key", cseKey)
	if animated {
		q.Add("fileType", "gif")
		q.Add("hq", "animated")
		q.Add("tbs", "itp:animated")
	}
	req.URL.RawQuery = q.Encode()

	response, err := http.Get(req.URL.String())
	if err != nil {
		return "", err
	}

	defer response.Body.Close()
	body, _ := ioutil.ReadAll(response.Body)

	if response.StatusCode == 403 {
		log.Println(string(body))
		return fallbackImage, errors.New("Sorry, das tägliche Limit der Google API wurde überschritten.")
	}

	if response.StatusCode != 200 {
		log.Println(string(body))
		return fallbackImage, fmt.Errorf("Die Google API gibt mir einen %d Status Code 🙁", response.StatusCode)
	}

	var resp apiResponse
	err = json.Unmarshal(body, &resp)
	if err != nil {
		log.Println(string(body))
		return fallbackImage, errors.New("Die Antwort von Google's Server war nicht korrekt 🙁")
	}

	if len(resp.Items) == 0 {
		log.Println(string(body))
		return fallbackImage, errors.New("Hatte leider ein Problem mit der Suche, versuch's später nochmal.")
	}

	randomItem := chooseRandom(resp.Items)

	return ensureResult(randomItem.Link, animated), nil
}

// Choose a random item from a list
// Go's missing generics are somewhat of a pain :/
func chooseRandom(items []item) item {
	return items[rand.Intn(len(items))]
}

// Forces giphy result to use animated version
func ensureResult(url string, animated bool) string {
	if animated {
		// TODO: translate this js:
		// return ensureImageExtension(url.replace(/(giphy\.com\/.*)\/.+_s.gif$/, '$1/giphy.gif'));
		return ensureImageExtension(url)
	}
	return ensureImageExtension(url)
}

// Forces the URL to look like an image URL by adding `#.png`
func ensureImageExtension(url string) string {
	extensionR := regexp.MustCompile("(?i)(png|jpe?g|gif)$")
	if !extensionR.MatchString(url) {
		return fmt.Sprintf("%s#.png", url)
	}
	return url
}

type apiResponse struct {
	Items []item `json:"items"`
}

type item struct {
	Link string `json:"link"`
}
