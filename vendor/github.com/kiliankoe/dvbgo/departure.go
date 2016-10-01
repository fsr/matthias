package dvb

import (
	"fmt"
	"strconv"
)

// Departure encapsulates info regarding the line, direction and relative departure time in minutes.
type Departure struct {
	Line         string
	Direction    string
	RelativeTime int
}

func (dep Departure) String() string {
	return fmt.Sprintf("%s %s in %d minutes", dep.Line, dep.Direction, dep.RelativeTime)
}

// Mode returns the departure's mode of transport
func (dep Departure) Mode() (mode TransportMode, err error) {
	return parseMode(dep.Line)
}

func initDeparture(attrs []string) (departure *Departure, err error) {
	var rel int
	if attrs[2] == "" {
		rel = 0
	} else {
		rel, err = strconv.Atoi(attrs[2])
		if err != nil {
			return
		}
	}
	departure = &Departure{
		Line:         attrs[0],
		Direction:    attrs[1],
		RelativeTime: rel,
	}
	return
}
