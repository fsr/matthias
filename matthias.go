package main

import (
	"flag"
	"os"

	_ "./scripts/mensa"
	_ "./scripts/random"

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
