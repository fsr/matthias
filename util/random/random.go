package random

import "math/rand"

// IntBetween is a helper function returning a random int between to values, inclusive
func IntBetween(lower, upper int) int {
	bound := upper - lower
	if bound < 0 {
		// don't crash on invalid input
		bound *= -1
	}
	return rand.Intn(bound+1) + lower
}

// StringFromList returns a random element from a given list
func StringFromList(list []string) string {
	return list[rand.Intn(len(list))]
}
