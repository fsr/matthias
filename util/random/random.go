package random

import (
	"math/rand"
	"time"
)

// Int returns a random int >= 0 and < bound
func Int(bound int) int {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	return r.Intn(bound)
}

// StringFromList returns a random element from a given list
func StringFromList(list []string) string {
	return list[Int(len(list))]
}
