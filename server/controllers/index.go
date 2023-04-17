package controllers

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"golang.org/x/crypto/bcrypt"
	"log"
	"net/http"
	_ "server/authService"
	"server/databaseControllers"
	"server/databaseTypes"
	"server/restTypes"
	"strings"
	_ "strings"
	"time"
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

func FoodMenuByHandler(w http.ResponseWriter, r *http.Request) {
	path := strings.TrimPrefix(r.URL.Path, "/food-menu/")
	switch r.Method {
	case "POST":
		postFoodMenuHandler(w, r)
		break
	case "PUT":
		putFoodMenuHandler(w, r, path)
		break
	case "DELETE":
		deleteFoodMenu(w, r, path)
		break
	case "GET":
		getFoodMenu(w, r)
		break
	default:
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
}

// @Summary Add a food menu
// @Description Add a new food menu to the database
// @Tags FoodMenu
// @Security Bearer
// @ID addFoodMenu
// @Accept json
// @Produce json
// @Param foodMenu body databaseTypes.FoodMenu true "Food menu to add"
// @Success 200 {object} restTypes.LoginResponse
// @Failure 400 {string} string "Bad Request"
// @Failure 401 {string} string "Unauthorized"
// @Failure 500 {string} string "Internal Server Error"
// @Router /food-menu/ [post]
func postFoodMenuHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Verify authentication here if needed

	var foodMenu databaseTypes.FoodMenu
	err := json.NewDecoder(r.Body).Decode(&foodMenu)
	if err != nil {
		http.Error(w, "Failed to parse request body", http.StatusBadRequest)
		return
	}

	db, err := sql.Open("sqlite3", "database.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	stmt, err := db.Prepare("INSERT INTO FoodMenu (date, breakfast, lunch, dinner) VALUES (?, ?, ?, ?)")
	if err != nil {
		log.Fatal(err)
	}
	defer stmt.Close()

	_, err = stmt.Exec(foodMenu.Date, foodMenu.Breakfast, foodMenu.Lunch, foodMenu.Dinner)
	if err != nil {
		log.Fatal(err)
	}

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(restTypes.LoginResponse{
		Status:  "success",
		Message: "Food menu added successfully",
	})
}

// putFoodMenuHandler handles a PUT request to /food-menu/{id}
// @Summary Update a food menu
// @Description Update the food menu with the specified ID
// @Tags FoodMenu
// @Security Bearer
// @Accept json
// @Produce json
// @Param id path string true "ID of the food menu to update"
// @Param foodMenu body databaseTypes.FoodMenu true "New values for the food menu"
// @Success 200 {object} restTypes.LoginResponse
// @Failure 400 {object} restTypes.ErrorResponse
// @Failure 401 {object} restTypes.ErrorResponse
// @Failure 404 {object} restTypes.ErrorResponse
// @Router /food-menu/{id} [put]
func putFoodMenuHandler(w http.ResponseWriter, r *http.Request, id string) {
	if r.Method != "PUT" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Verify authentication here if needed

	var foodMenu databaseTypes.FoodMenu
	err := json.NewDecoder(r.Body).Decode(&foodMenu)
	if err != nil {
		http.Error(w, "Failed to parse request body", http.StatusBadRequest)
		return
	}

	db, err := sql.Open("sqlite3", "database.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	stmt, err := db.Prepare("UPDATE FoodMenu SET date=?, breakfast=?, lunch=?, dinner=? WHERE date=?")
	if err != nil {
		log.Fatal(err)
	}
	defer stmt.Close()

	_, err = stmt.Exec(foodMenu.Date, foodMenu.Breakfast, foodMenu.Lunch, foodMenu.Dinner, id)
	if err != nil {
		log.Fatal(err)
	}

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(restTypes.LoginResponse{
		Status:  "success",
		Message: "Food menu updated successfully",
	})
}

// @Summary Delete a food menu
// @Description Delete a food menu from the database for a given date
// @Tags FoodMenu
// @Security Bearer
// @ID deleteFoodMenu
// @Param date path string true "The date of the food menu to delete"
// @Success 200 {object} restTypes.DeleteResponse
// @Failure 400 {string} string "Bad Request"
// @Failure 404 {string} string "Not Found"
// @Failure 500 {string} string "Internal Server Error"
// @Router /food-menu/{date} [delete]
func deleteFoodMenu(w http.ResponseWriter, r *http.Request, date string) {
	// Check if the request method is DELETE
	if r.Method != http.MethodDelete {
		w.WriteHeader(http.StatusMethodNotAllowed)
		return
	}

	// Open the database connection
	db, err := sql.Open("sqlite3", "database.db")
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	defer db.Close()

	// Delete the food menu for the given date
	stmt, err := db.Prepare("DELETE FROM FoodMenu WHERE date = ?")
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	res, err := stmt.Exec(date)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// Check if any row was affected by the delete operation
	rowsAffected, err := res.RowsAffected()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	if rowsAffected == 0 {
		w.WriteHeader(http.StatusNotFound)
		return
	}

	// Return a success message in JSON format
	response := restTypes.DeleteResponse{Status: "success", Message: "Food menu deleted successfully"}
	jsonResponse, err := json.Marshal(response)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	w.Write(jsonResponse)
}

// @Summary Get the food menu for the current date
// @Description Retrieves the breakfast, lunch, and dinner menu for the current date from the database
// @Tags FoodMenu
// @Accept  json
// @Produce  json
// @Security Bearer
// @Success 200 {object} databaseTypes.FoodMenu
// @Failure 401 {string} Unauthorized
// @Failure 404 {string} Not Found
// @Failure 500 {string} Internal Server Error
// @Router /food-menu/ [get]
func getFoodMenu(w http.ResponseWriter, r *http.Request) {
	// Check authentication
	_, erro := databaseControllers.IsAuthorized(w, r)
	if !(erro.Code != 0) {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	// Get the current date
	date := time.Now()
	db, err := sql.Open("sqlite3", "database.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	// Query the database for the food menu for the current date
	query := "SELECT breakfast, lunch, dinner FROM FoodMenu WHERE date = ?"
	row := db.QueryRow(query, date.Format("2006-01-02"))

	// Extract the values from the row
	var breakfast, lunch, dinner string
	err = row.Scan(&breakfast, &lunch, &dinner)
	if err == sql.ErrNoRows {
		http.NotFound(w, r)
		return
	} else if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

	// Create a FoodMenu struct from the values
	foodMenu := databaseTypes.FoodMenu{
		Date:      date.Format("2006-01-02"),
		Breakfast: breakfast,
		Lunch:     lunch,
		Dinner:    dinner,
	}

	// Convert the FoodMenu struct to a JSON object
	jsonData, err := json.Marshal(foodMenu)
	if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

	// Set the response headers
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)

	// Write the response
	w.Write(jsonData)
}
