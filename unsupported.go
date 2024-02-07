//go:build !amd64 && (!linux || !windows)

package main

import (
	"fmt"
	"os"
)

func main() {
	fmt.Println("This OS or architecture is not supported!")
	os.Exit(1)
}
