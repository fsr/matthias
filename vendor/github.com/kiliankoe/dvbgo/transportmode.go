package dvb

import (
	"errors"
	"fmt"
	"regexp"
	"strconv"
)

// A TransportMode e.g tram, citybus, etc.
type TransportMode struct {
	Title   string
	Name    string
	IconURL string
}

// Values for possible modes of transport
var (
	Tram = TransportMode{
		Title:   "Straßenbahn",
		Name:    "tram",
		IconURL: "https://www.dvb.de/assets/img/trans-icon/transport-tram.svg",
	}
	Citybus = TransportMode{
		Title:   "Stadtbus",
		Name:    "citybus",
		IconURL: "https://www.dvb.de/assets/img/trans-icon/transport-citybus.svg",
	}
	Regiobus = TransportMode{
		Title:   "Regionalbus",
		Name:    "regiobus",
		IconURL: "https://www.dvb.de/assets/img/trans-icon/transport-bus.svg",
	}
	Metropolitan = TransportMode{
		Title:   "S-Bahn",
		Name:    "metropolitan",
		IconURL: "https://www.dvb.de/assets/img/trans-icon/transport-metropolitan.svg",
	}
	Lift = TransportMode{
		Title:   "Seil-/Schwebebahn",
		Name:    "lift",
		IconURL: "https://www.dvb.de/assets/img/trans-icon/transport-lift.svg",
	}
	Ferry = TransportMode{
		Title:   "Fähre",
		Name:    "ferry",
		IconURL: "https://www.dvb.de/assets/img/trans-icon/transport-ferry.svg",
	}
	Ast = TransportMode{
		Title:   "Anrufsammeltaxi (AST)/ Rufbus",
		Name:    "ast",
		IconURL: "https://www.dvb.de/assets/img/trans-icon/transport-alita.svg",
	}
	Train = TransportMode{
		Title:   "Zug",
		Name:    "train",
		IconURL: "https://www.dvb.de/assets/img/trans-icon/transport-train.svg",
	}
)

func parseMode(modeStr string) (mode TransportMode, err error) {
	if intMode, convErr := strconv.Atoi(modeStr); convErr == nil {
		switch {
		case 0 <= intMode && intMode < 60:
			return Tram, convErr
		case 60 <= intMode && intMode < 100:
			return Citybus, convErr
		case 100 <= intMode && intMode < 1000:
			return Regiobus, convErr
		}
	}

	if modeStr == "SWB" {
		return Lift, nil
	}

	if eR, _ := regexp.Compile("^E(\\d+)"); eR.Match([]byte(modeStr)) {
		matches := eR.FindStringSubmatch(modeStr)
		if intMode, convErr := strconv.Atoi(matches[1]); convErr == nil {
			switch {
			case 0 <= intMode && intMode < 60:
				return Tram, convErr
			case 60 <= intMode && intMode < 100:
				return Citybus, convErr
			}
		}
	}

	if evR, _ := regexp.Compile("^EV\\d+"); evR.Match([]byte(modeStr)) {
		return Citybus, nil
	}

	if modeStr == "E" {
		return Tram, nil
	}

	if regioR, _ := regexp.Compile("^\\D$|^\\D\\/\\D$"); regioR.Match([]byte(modeStr)) {
		return Regiobus, nil
	}

	if ferryR, _ := regexp.Compile("^F"); ferryR.Match([]byte(modeStr)) {
		return Ferry, nil
	}

	if trainR, _ := regexp.Compile("^RE|^IC|^TL|^RB|^SB|^SE|^U\\d"); trainR.Match([]byte(modeStr)) {
		return Train, nil
	}

	if metroR, _ := regexp.Compile("^S"); metroR.Match([]byte(modeStr)) {
		return Metropolitan, nil
	}

	if astR, _ := regexp.Compile("alita"); astR.Match([]byte(modeStr)) {
		return Ast, nil
	}

	errDesc := fmt.Sprintf("failed to parse departure identifier into transport mode for \"%s\"", modeStr)
	err = errors.New(errDesc)
	return
}
