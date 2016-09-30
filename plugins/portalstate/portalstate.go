package portalstate

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"regexp"
	"strings"

	"github.com/abourget/slick"
)

type portalstate struct{}

func (portal *portalstate) String() string {
	return `!portalstate - Gib' den Status aller relevanten Ingressportale aus`
}

var portalURL string

// Portal ...
type Portal struct {
	Name string
	ID   int
}

var watchedPortals []Portal

func init() {
	slick.RegisterPlugin(&portalstate{})
}

// InitPlugin ...
func (portal *portalstate) InitPlugin(bot *slick.Bot) {
	var conf struct {
		Portalstate struct {
			URL     string
			Portals []Portal
		}
	}

	bot.LoadConfig(&conf)

	portalURL = conf.Portalstate.URL
	watchedPortals = conf.Portalstate.Portals

	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!portalstate"),
		MessageHandlerFunc: portal.portalHandler,
	})
}

func (portal *portalstate) portalHandler(listen *slick.Listener, msg *slick.Message) {
	for _, portal := range watchedPortals {
		portalRes, err := getFactionFor(portal.ID)
		if err != nil {
			msg.Reply(fmt.Sprintf("Konnte keinen Status für %s abrufen: %s", portal.Name, err.Error()))
			continue
		}
		msg.Reply(fmt.Sprintf("%s: Lvl %d %s", portal.Name, portalRes.Level, mapFaction(portalRes.Faction)))
	}
}

type portalResponse struct {
	UUID    string `json:"uuid"`
	Level   int    `json:"portalLevel"`
	Faction string `json:"faction"`
}

func getFactionFor(portal int) (*portalResponse, error) {
	url := portalURL + fmt.Sprintf("%d", portal)
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var portalRes portalResponse

	str := strings.Replace(string(body), "'", "\"", -1) // temporary fix for invalid json

	err = json.Unmarshal([]byte(str), &portalRes)
	if err != nil {
		return nil, err
	}

	return &portalRes, nil
}

func mapFaction(faction string) string {
	switch strings.ToLower(faction) {
	case "enl", "enlightened":
		return "💚"
	case "res", "resistance":
		return "🔵"
	default:
		return "❔"
	}
}
