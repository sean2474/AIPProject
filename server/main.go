package main

import (
	httpSwagger "github.com/swaggo/http-swagger"
	"net/http"
	"server/controllers"
	_ "server/docs"
	_ "strings"
)

// @title Go Rest API with Swagger for school system
// @version 1.0
// @description Simple swagger implementation in Go HTTP

// @contact.name Senya

// @securityDefinitions.apikey ApiKeyAuth
// @in header
// @name Authorization

// @host 172.16.130.25
// @BasePath /api/
func main() {
	http.HandleFunc("/swagger/", httpSwagger.WrapHandler)

	http.HandleFunc("/auth/login", controllers.AuthLogin)
	http.HandleFunc("/", controllers.SayHello)

	http.ListenAndServe(":8082", nil)
}
