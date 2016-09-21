package main

import (
	"flag"
	"os"

	_ "./scripts/random"

	"github.com/abourget/slick"
)

var isDebug = flag.Bool("debug", false, "debug mode, uses ./matthias_debug.conf")
var configFile = flag.String("config", os.Getenv("HOME")+"/.matthias.conf", "config file")

func main() {
	flag.Parse()

	if *isDebug {
		debugPath := "./matthias_debug.conf"
		configFile = &debugPath
	}

	bot := slick.New(*configFile)
	bot.Run()
}
