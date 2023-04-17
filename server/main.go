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
// @BasePath /api
// @securityDefinitions.apikey Bearer
// @in header
// @name Authorization
// @description Type "Bearer" followed by a space and JWT token.
func main() {
	http.HandleFunc("/swagger/", httpSwagger.WrapHandler)
	http.HandleFunc("/auth/login", controllers.LoginHandler)
	http.HandleFunc("/auth/testToken", controllers.TestToken)
	http.HandleFunc("/food-menu/", controllers.FoodMenuByHandler)

	http.ListenAndServe(":8082", nil)
	//fmt.Println(databaseControllers.GetUserByEmail("johnsmith@example.com"))

}
