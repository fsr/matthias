package googleimages

import (
	"log"
	"regexp"

	"github.com/abourget/slick"
)

// GoogleImages searching
// Commands:
// !image (me) <searchterm> - Returns link to a random image result
type GoogleImages struct{}

func init() {
	slick.RegisterPlugin(&GoogleImages{})
}

// InitPlugin ...
func (images *GoogleImages) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!image( me)? (.*)"),
		MessageHandlerFunc: images.ImageHandler,
	})
}

// ImageHandler ...
func (images *GoogleImages) ImageHandler(listen *slick.Listener, msg *slick.Message) {
	query := msg.Match[2]
	log.Println("Google Image search for", query, "requested by", msg.FromUser.Name)
	msg.Reply(`Sorry, das Feature funktioniert noch nicht ganz :/
Wenn du helfen magst es einzubauen, schau doch bitte mal hier vorbei: https://github.com/google/google-api-go-client
Hier ist die Doku zu dem Custom Search Gedöns: https://godoc.org/google.golang.org/api/customsearch/v1
Hatte beim Schreiben dieser Nachricht aktuell keine Lust mich da einzulesen. Wenn du Lust dazu hast, nur zu :)`)
}
