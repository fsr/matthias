package speiseplan

import (
	"regexp"
	"strconv"
)

// A Meal object
type Meal struct {
	Name          string  `json:"name"`
	ImageURL      string  `json:"imageURL"`
	PageURL       string  `json:"detailURL"`
	Canteen       string  `json:"canteen"`
	StudentPrice  float64 `json:"studentPrice,omitempty"`
	EmployeePrice float64 `json:"employeePrice,omitempty"`
}

var (
	pricesRegex, _ = regexp.Compile(`\d+.\d+`)
	parensRegex, _ = regexp.Compile(` \(.*\)`)
)

func readPrices(title string) (student, employee float64) {
	prices := pricesRegex.FindAllStringSubmatch(title, -1)
	if len(prices) > 0 {
		student, _ = strconv.ParseFloat(prices[0][0], 64)
	}
	if len(prices) > 1 {
		employee, _ = strconv.ParseFloat(prices[1][0], 64)
	}

	return
}

func trimTitle(title string) string {
	parensIndex := parensRegex.FindAllStringIndex(title, 1)
	if len(parensIndex) == 0 {
		parensIndex = [][]int{[]int{len(title)}}
	}
	return title[:parensIndex[0][0]]
}

func mealFromFeedItem(item item) Meal {
	studentPrice, employeePrice := readPrices(item.Title)

	return Meal{
		Name:          trimTitle(item.Title),
		ImageURL:      item.ImageURL,
		PageURL:       item.Link,
		Canteen:       item.Author,
		StudentPrice:  studentPrice,
		EmployeePrice: employeePrice,
	}
}

func (m Meal) String() string {
	return m.Name
}
