package controllers

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"server/authService"
	"server/restTypes"
	"strings"
)

// writeJSON provides function to format output response in JSON
func writeJSON(w http.ResponseWriter, code int, payload interface{}) {
	resp, err := json.Marshal(payload)
	if err != nil {
		log.Println("Error Parsing JSON")
	}

	w.Header().Set("Content-type", "application/json")
	w.WriteHeader(code)
	w.Write(resp)
}

func decodePost(r *http.Request, structure interface{}) {
	decoder := json.NewDecoder(r.Body)
	err := decoder.Decode(structure)
	if err != nil {
		log.Println("Error parsing post data")
	}
}

// basicAuthMW is middleware function to check whether user is authenticated or not
// actually you could write better code for this function
func basicAuthMW(w http.ResponseWriter, r *http.Request) map[string]string {
	errorAuth := restTypes.ErrorResp{
		Error: "Unauthorized access",
	}

	header := r.Header.Get("Authorization")
	if header == "" {
		writeJSON(w, 401, errorAuth)
		return map[string]string{}
	}

	apiKey := strings.Split(header, " ")

	if len(apiKey) != 2 {
		writeJSON(w, 401, errorAuth)
		return map[string]string{}
	}

	if apiKey[0] != "Basic" {
		writeJSON(w, 401, errorAuth)
		return map[string]string{}
	}

	users := map[string]map[string]string{
		"28b662d883b6d76fd96e4ddc5e9ba780": map[string]string{
			"username": "linggar",
			"fullname": "Linggar Primahastoko",
		},
	}

	if _, ok := users[apiKey[1]]; !ok {
		writeJSON(w, 401, errorAuth)
		return map[string]string{}
	}

	return users[apiKey[1]]
}

// AuthLogin godoc
// @Summary Auth Login
// @Description Auth Login
// @Tags auth
// @ID auth-login
// @Accept  json
// @Produce  json
// @Param authLogin body restTypes.AuthParam true "Auth Login Input"
// @Success 200 {object} restTypes.AuthResp
// @Router /auth/login [post]
func AuthLogin(w http.ResponseWriter, r *http.Request) {
	var param restTypes.AuthParam
	decodePost(r, &param)
	token, err := authService.Login(param.Username, param.Password)
	if err != nil {
		failResp := restTypes.ErrorResp{
			Error: "Wrong username/password",
		}
		writeJSON(w, 401, failResp)
		return
	}
	respAuth := restTypes.AuthResp{
		Token: token,
	}
	writeJSON(w, 200, respAuth)
}

func SayHello(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Привет!")
}
