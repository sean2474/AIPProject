package controllers

import (
	"fmt"
	"net/http"
)

func SayHello(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Привет!")
}
