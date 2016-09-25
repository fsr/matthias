package googleimages

import (
	"regexp"

	"github.com/abourget/slick"
)

type googleimages struct{}

func (images *googleimages) String() string {
	return `!image (me) <suchbegriff> - Gibt ein Zufallsbild der Google Bildersuche zum <suchbegriff> aus`
}

func init() {
	slick.RegisterPlugin(&googleimages{})
}

// InitPlugin ...
func (images *googleimages) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!image( me)? (.*)"),
		MessageHandlerFunc: images.imageHandler,
	})
}

func (images *googleimages) imageHandler(listen *slick.Listener, msg *slick.Message) {
	// query := msg.Match[2]
	msg.Reply(`Sorry, das Feature funktioniert noch nicht ganz :confused:
Wenn du helfen magst es einzubauen, schau doch bitte mal hier vorbei: https://github.com/google/google-api-go-client
Hier ist die Doku zu dem Custom Search Gedöns: https://godoc.org/google.golang.org/api/customsearch/v1
Hatte beim Schreiben dieser Nachricht aktuell keine Lust mich da einzulesen. Wenn du Lust dazu hast, nur zu :smile:
Solltest du ein alternatives golang Package findest, was das schon implementiert, wär das natürlich auch klasse :blush:`)
}
