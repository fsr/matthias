package apbdoor

import (
	"bytes"
	"io/ioutil"
	"net/http"
	"regexp"
	"strings"

	"github.com/abourget/slick"
	"github.com/fsr/matthias/util/random"
)

const (
	doorBroken     = "yes"
	doorFunctional = "no"
	doorUnknown    = "maybe"
)

type apbdoor struct{}

func (apbdoor *apbdoor) String() string {
	return `!türstatus/!tuerstatus - Ist die Eingangstür vom APB aktuell im Eimer?
!tuer (ist) (kaputt/ganz/weg) - Setzt die Eingangstür vom APB auf den jeweiligen Status`
}

func init() {
	slick.RegisterPlugin(&apbdoor{})
}

// InitPlugin ...
func (apbdoor *apbdoor) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("!t(?:ü|ue)rstatus"),
		MessageHandlerFunc: apbdoor.checkDoorHandler,
	})
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("!t(?:ü|ue)r(?: ist )?(.+)"),
		MessageHandlerFunc: apbdoor.setDoorHandler,
	})
}

func (apbdoor *apbdoor) checkDoorHandler(listen *slick.Listener, msg *slick.Message) {
	doorState, err := checkDoorState()
	if err != nil {
		msg.Reply(random.StringFromList(maybeMsgs))
	}

	switch doorState {
	case doorBroken:
		msg.Reply(random.StringFromList(yesMsgs))
	case doorFunctional:
		msg.Reply(random.StringFromList(noMsgs))
	default:
		msg.Reply(random.StringFromList(maybeMsgs))
	}
}

func (apbdoor *apbdoor) setDoorHandler(listen *slick.Listener, msg *slick.Message) {
	state := strings.ToLower(msg.Match[1])
	switch state {
	case "kaputt", "broken", "im eimer":
		setDoorState(doorBroken)
		msg.Reply("Orr ne, schon wieder?!")
	case "ganz", "wieder ganz", "funktional":
		setDoorState(doorFunctional)
		msg.Reply(random.StringFromList(partyGifs))
	case "weg", "unbekannt":
		setDoorState(doorUnknown)
		msg.Reply("Ähm.... Ahja?")
	}
}

func checkDoorState() (string, error) {
	resp, err := http.Get("http://tuer.fsrleaks.de")
	defer resp.Body.Close()
	if err != nil {
		return doorUnknown, err
	}
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return doorUnknown, err
	}

	if bytes.Contains(body, []byte("Ja")) {
		return doorBroken, nil
	} else if bytes.Contains(body, []byte("Nein")) {
		return doorFunctional, nil
	} else {
		return doorUnknown, nil
	}
}

func setDoorState(state string) {
	url := "http://door.fsrleaks.de/set.php?" + state
	http.Get(url)
}

var partyGifs = []string{
	"http://i.giphy.com/6nuiJjOOQBBn2.gif",
	"http://i.giphy.com/EktbegF3J8QIo.gif",
	"http://i.giphy.com/YTbZzCkRQCEJa.gif",
	"http://i.giphy.com/3rgXBQIDHkFNniTNRu.gif",
	"http://i.giphy.com/s2qXK8wAvkHTO.gif",
}

var yesMsgs = []string{
	"Jop, Tür ist im Eimer.",
	"Tür ist 'putt.",
	"Rate mal...",
	"Alles im Arsch, Normalzustand halt.",
	"Computer sagt: Tür ist hin.",
	"Tür pass auf!! Du hast ne Scheibe verloren!",
	"Techniker ist selbstverständlich bereits informiert.",
}

var noMsgs = []string{
	"Die Tür ist... ganz?!",
	"Alles im grünen Bereich.",
	"Sie ist ganz! Also... Zumindest gerade eben. Vermutlich schon nicht mehr.",
	"Rufe Fr. Kapplusch an... Nop, scheint alles gut zu sein. Beeindruckend.",
	"Hab' eben nachgesehen und... Ausnahmezustand!",
}

var maybeMsgs = []string{
	"Ich hab keine Ahnung ¯\\_(ツ)_/¯",
	"Sorry, musst du dieses Mal selber nachschauen.",
	"Quizás, señor/a.",
	"Sorry, no clue.",
	"Schrödingers Tür?",
	"Lässt sich aus diesem Blickwinkel schlecht beurteilen.",
}
