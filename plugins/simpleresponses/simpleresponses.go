package simpleresponses

import (
	"math/rand"
	"regexp"
	"strings"

	"github.com/abourget/slick"
)

type simpleresponses struct{}

func init() {
	slick.RegisterPlugin(&simpleresponses{})
}

// InitPlugin ...
func (simple *simpleresponses) InitPlugin(bot *slick.Bot) {
	for listener := range simpleResponses {
		bot.Listen(&slick.Listener{
			Matches:            regexp.MustCompile("(?i)" + listener),
			MessageHandlerFunc: simple.simpleHandler,
		})
	}
	for listener := range sometimesResponses {
		bot.Listen(&slick.Listener{
			Matches:            regexp.MustCompile("(?i)" + listener),
			MessageHandlerFunc: simple.sometimesHandler,
		})
	}
}

func (simple *simpleresponses) simpleHandler(listen *slick.Listener, msg *slick.Message) {
	response := simpleResponses[strings.ToLower(msg.Match[0])]
	msg.Reply(response)
}

func (simple *simpleresponses) sometimesHandler(listen *slick.Listener, msg *slick.Message) {
	response := sometimesResponses[strings.ToLower(msg.Match[0])]
	randomInt := rand.Intn(5)
	if randomInt == 0 {
		msg.Reply(response)
	}
}

// careful with these, as they're replied if a message contains the key anwhere
// they're also case-insensitive
var simpleResponses = map[string]string{
	"filmlist":                "Vorschläge: http://letterboxd.com/kiliankoe/list/ifsr-filmvorschlage/\nGeschaute Filme: http://letterboxd.com/kiliankoe/list/ifsr-movie-night/",
	"wat is wacken":           "Dat ist Wacken. Einmal im Jahr kommen hier alle bösen schwarzen Männer aus Mittelerde her, um ma richtig die Sau rauszulassen.",
	"marco":                   "POLO",
	"pimmel":                  "Höhöhö, du hast Pimmel gesagt.",
	"jehova":                  "http://i.imgur.com/01PMBGj.gif",
	"muss man wissen":         "http://i.imgur.com/FmEyA8t.png",
	"fefe":                    "http://i.imgur.com/FmEyA8t.png",
	"sascha lobo":             "http://i.imgur.com/FmEyA8t.png",
	"axel stoll":              "http://i.imgur.com/FmEyA8t.png",
	"you're tearing me apart": "http://i.giphy.com/pTrgmCL2Iabg4.gif",
	"the room":                "http://i.giphy.com/pTrgmCL2Iabg4.gif",
	"tommy wiseau":            "http://i.giphy.com/pTrgmCL2Iabg4.gif",
	"anyway":                  "How's your sex life?",
}

// these don't match on every single occurence, but are somewhat randomized
var sometimesResponses = map[string]string{
	"game":  "Hab' das Spiel verloren.",
	"spiel": "Hab' das Spiel verloren.",
}

// FIXME: Don't have a clue yet how to make these work... Any ideas?
// these match only on their given regex
var regexResponses = map[*regexp.Regexp]string{
	regexp.MustCompile("^pizza$"): "Ich bin Matthias Stuhlbein, Nöthnitzer Str. 46, 01187 Dresden. Fakultät Informatik. Mail: pizza@ifsr.de, Telefon: 0351 46338223 - Pizzen schneiden nicht vergessen ;)",
	regexp.MustCompile("^nein$"):  "Doch!",
}

// TODO: Simple reactions would be cool. Listeners that are reacted upon automatically.
// e.g. react with :mind-the-quack: if someone mentions ducks

// TODO: Simple replacements? something like "matthias ist (.*)" -> "deine mudda ist {match}", where {match} is replaced with the msg.Match[1] of the listen
