package controllers

import (
	"encoding/json"
	"fmt"
	"golang.org/x/crypto/bcrypt"
	"net/http"
	_ "server/authService"
	"server/databaseControllers"
	"server/databaseTypes"
	"server/restTypes"
	_ "strings"
)

func writeJson(w http.ResponseWriter, resp interface{}) {
	jsonResp, err := json.Marshal(resp)
	if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	// Send response
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	w.Write(jsonResp)
}

// LoginHandler handles user authentication and generates an authentication token.
//
// @Summary Authenticate user
// @Description Login to the system and receive an authentication token.
// @Tags Authentication
// @Accept json
// @Produce json
// @Param login body restTypes.LoginRequest true "User login information"
// @Success 200 {object} restTypes.LoginResponse
// @Failure 401 {object} restTypes.ErrorResponse
// @Router /auth/login [post]
func LoginHandler(w http.ResponseWriter, r *http.Request) {
	// Check request method
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Parse request body
	var req restTypes.LoginRequest
	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}

	// Validate credentials
	user, e := databaseControllers.GetUserByEmail(req.Username)
	if e.Code != 0 {
		writeJson(w, e)
		return
	}
	s, _ := bcrypt.GenerateFromPassword([]byte(user.Password), 4)
	fmt.Println(string(s))

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password))
	if err != nil {
		http.Error(w, "Invalid username or password", http.StatusUnauthorized)
		return
	}

	// Generate JWT token
	token, err := databaseControllers.GenerateToken(user.ID)
	if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	// Build response
	resp := restTypes.LoginResponse{
		Status:  "success",
		Message: "Login successful",
		Token:   token,
		UserData: &databaseTypes.User{
			ID:        user.ID,
			FirstName: user.FirstName,
			LastName:  user.LastName,
			Email:     user.Email,
			UserType:  user.UserType,
		},
	}
	writeJson(w, resp)

}

// TestToken greets the user with "Hello, {userName}!" if he's authorized
// @Summary Greet the user if he's authorized
// @Description Greets the user with "Hello, {userName}!" if he's authorized
// @Tags Authentication
// @Accept  json
// @Produce  json
// @Security Bearer
// @Success 200 {string} string "Hello, {userName}!"
// @Failure 401 {object} restTypes.ErrorResponse "Unauthorized"
// @Failure 500 {object} restTypes.ErrorResponse "Internal Server Error"
// @Router /auth/testToken [get]
// @Router /auth/testToken [post]
func TestToken(w http.ResponseWriter, r *http.Request) {
	user, err := databaseControllers.IsAuthorized(w, r)
	if err.Code == 0 {
		fmt.Fprintf(w, "HELLO, "+user.FirstName)
		return
	}
	writeJson(w, err)

}
