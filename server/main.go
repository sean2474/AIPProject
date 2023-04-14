package main

import (
	"log"
	"net/http"
	"server/controllers"
)

func main() {
	http.HandleFunc("/", controllers.SayHello)
	err := http.ListenAndServe(":7653", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
