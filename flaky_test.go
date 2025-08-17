package flaky_test

import (
	"math/rand"
	"testing"
	"time"
)

func TestRandomFlake(t *testing.T) {
	t.Parallel()
	rand.Seed(time.Now().UnixNano()) // different each run
	if rand.Intn(5) == 0 {           // ~20% chance
		t.Fatalf("flaked: unlucky roll")
	}
}

