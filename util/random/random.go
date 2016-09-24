package random

import (
	"math/rand"
	"time"
)

// Int returns a random int >= 0 and < bound
func Int(bound int) int {
	if bound < 0 {
		// don't crash on invalid input
		bound = -bound
	}
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	return r.Intn(bound)
}

// IntBetween is a helper function returning a random int between to values, inclusive
func IntBetween(lower, upper int) int {
	return Int(upper-lower+1) + lower
}

// StringFromList returns a random element from a given list
func StringFromList(list []string) string {
	return list[Int(len(list))]
}
