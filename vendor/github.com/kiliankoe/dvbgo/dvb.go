package dvb

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"net/url"
	"strconv"
)

// Monitor returns a list of upcoming departures at a given stop.
// Offset offsets information minutes into the future, 0 meaning now.
// City defaults to Dresden if empty str, but others in the VVO network are possible as well.
func Monitor(stop string, offset int, city string) (departures []*Departure, err error) {
	if city == "" {
		city = "Dresden"
	}

	vvoURL, _ := url.Parse("http://widgets.vvo-online.de/abfahrtsmonitor/Abfahrten.do")
	params := vvoURL.Query()
	params.Set("ort", city)
	params.Set("hst", stop)
	params.Set("vz", strconv.Itoa(offset))
	params.Set("lim", "0")
	vvoURL.RawQuery = params.Encode()

	resp, err := http.Get(vvoURL.String())
	if err != nil {
		return
	}

	respData, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return
	}

	var departuresData [][]string
	err = json.Unmarshal(respData, &departuresData)
	if err != nil {
		return
	}

	for _, depAttrs := range departuresData {
		departure, _ := initDeparture(depAttrs)
		departures = append(departures, departure)
	}

	return
}
