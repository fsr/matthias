package speiseplan

import "strings"

// FeedURL is the URL of the Menu RSS Feed
const FeedURL = "http://www.studentenwerk-dresden.de/feeds/speiseplan-ifsr.rss"

// const FeedURL = "https://users.ifsr.de/~koeltzsch/debugmensa.xml"

// Mensa names to be used with GetCurrentForCanteen
const (
	AlteMensa           = "Alte Mensa"
	Bruehl              = "Mensa Brühl"
	GrillCube           = "Grill Cube"
	Goerlitz            = "Mensa Görlitz"
	Johannstadt         = "Mensa Johannstadt"
	Kindertagesstaetten = "Kindertagesstätten"
	Kreuzgymnasium      = "Mensa Kreuzgymnasium"
	Mensologie          = "Mensologie"
	PaluccaHochschule   = "Mensa Palucca Hochschule"
	Reichenbachstrasse  = "Mensa Reichenbachstraße"
	Siedepunkt          = "Mensa Siedepunkt"
	Sport               = "Mensa Sport"
	StimmGabel          = "Mensa Stimm-Gabel"
	TellerRandt         = "Mensa TellerRandt"
	UBoot               = "BioMensa U-Boot"
	WUEins              = "Mensa WUeins"
	Zeltschloesschen    = "Zeltschlösschen"
	Zittau              = "Mensa Zittau"
)

// GetCurrent returns current menu data
func GetCurrent() (meals []*Meal, err error) {
	items, err := parseURL(FeedURL)
	if err != nil {
		return nil, err
	}

	for _, mealItem := range items {
		meal := mealFromFeedItem(mealItem)
		meals = append(meals, &meal)
	}

	return meals, nil
}

// GetCurrentForCanteen returns all current meals for a given canteen, the name
// of which is also returned in case the user used a common alias.
func GetCurrentForCanteen(canteen string) (meals []*Meal, canteenName string, err error) {
	canteenName = commonAliases(canteen)
	all, err := GetCurrent()
	for _, meal := range all {
		if strings.ToLower(meal.Canteen) == strings.ToLower(canteenName) {
			meals = append(meals, meal)
		}
	}
	return
}

func commonAliases(search string) string {
	switch strings.ToLower(search) {
	case "alte", "mensa", "mommsa", "brat2", "bratquadrat":
		return AlteMensa
	case "uboot", "bio", "biomensa":
		return UBoot
	case "brühl", "hfbk":
		return Bruehl
	case "görlitz":
		return Goerlitz
	case "jotown", "ba", "alte fakultät":
		return Johannstadt
	case "palucca", "tanz":
		return PaluccaHochschule
	case "reichenbach", "htw", "reiche", "club mensa":
		return Reichenbachstrasse
	case "siede", "siedepunkt", "drepunct", "drehpunkt", "siedepunct", "slub":
		return Siedepunkt
	case "stimmgabel", "hfm", "musik", "musikhochschule":
		return StimmGabel
	case "tharandt", "tellerrand":
		return TellerRandt
	case "wu", "wu1", "wundtstraße":
		return WUEins
	case "neue", "bruchbude":
		return "Neue Mensa"
	case "zelt", "zeltmensa", "schlösschen", "feldschlösschen":
		return Zeltschloesschen
	case "grill", "cube", "fresswürfel", "würfel", "burger", "grillcube":
		return GrillCube
	default:
		return search
	}
}
