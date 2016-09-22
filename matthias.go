package main

import (
	"flag"
	"os"

	_ "github.com/fsr/matthias/plugins/mensa"
	_ "github.com/fsr/matthias/plugins/random"

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
