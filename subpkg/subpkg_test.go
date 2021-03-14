package subpkg_test

import (
	"testing"

	"github.com/jjhegedus/proto/subpkg"
)

func TestGreet(t *testing.T) {
	subpkg.Greet()
}
