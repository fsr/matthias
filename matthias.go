package main

import (
	"flag"
	"os"

	_ "github.com/fsr/matthias/plugins/apbdoor"
	_ "github.com/fsr/matthias/plugins/drsommer"
	_ "github.com/fsr/matthias/plugins/dvb"
	_ "github.com/fsr/matthias/plugins/firat"
	_ "github.com/fsr/matthias/plugins/fsr"
	_ "github.com/fsr/matthias/plugins/googleimages"
	_ "github.com/fsr/matthias/plugins/mensa"
	_ "github.com/fsr/matthias/plugins/porn"
	_ "github.com/fsr/matthias/plugins/random"
	_ "github.com/fsr/matthias/plugins/urbandictionary"
	_ "github.com/fsr/matthias/plugins/version"

	"github.com/abourget/slick"
)

var isProduction = flag.Bool("production", false, "production mode, uses $HOME/.matthias.conf")

func main() {
	flag.Parse()

	configFile := "./matthias_debug.conf"

	if *isProduction {
		configFile = os.Getenv("HOME") + "/.matthias.conf"
	}

	bot := slick.New(configFile)
	bot.Run()
}
