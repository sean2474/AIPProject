package databaseControllers

import (
	"database/sql"
	"fmt"
	"github.com/google/uuid"
	_ "github.com/mattn/go-sqlite3"
	"net/http"
	"server/databaseTypes"
	"server/restTypes"
	"strings"
	"time"
)

func GetTokenForUser(userID int) (string, error) {
	db, err := sql.Open("sqlite3", "./database.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	// Query the database for the most recent token for the given user ID
	var token string
	var addedAt time.Time
	err = db.QueryRow("SELECT token, added_at FROM LoginTokens WHERE user_id = ? ORDER BY added_at DESC LIMIT 1", userID).Scan(&token, &addedAt)
	if err != nil {
		if err == sql.ErrNoRows {
			// If there are no tokens for the given user ID, return an empty string and nil error
			return "", nil
		}
		// If there was an error querying the database, return an error
		return "", err
	}

	// Check if the token is older than one day
	if time.Since(addedAt) > 24*time.Hour {
		// If the token is older than one day, delete it from the database
		_, err = db.Exec("DELETE FROM LoginTokens WHERE token = ?", token)
		if err != nil {
			return "", err
		}
		// Return an empty string and nil error to indicate that the token was deleted
		return "", nil
	}

	// If the token is not older than one day, return it
	return token, nil
}

func IsAuthorized(w http.ResponseWriter, r *http.Request) (databaseTypes.User, restTypes.ErrorResponse) {
	db, err := sql.Open("sqlite3", "./database.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	// Get the Authorization header from the request
	authHeader := r.Header.Get("Authorization")
	// Check if the Authorization header is present and has the correct format
	if authHeader == "" {
		// If the Authorization header is missing, return error
		return databaseTypes.User{}, restTypes.ErrorResponse{
			Message: "Authorization header is missing",
			Code:    401,
		}
	}
	if !strings.HasPrefix(authHeader, "Bearer ") {
		// If the Authorization header has an invalid format, return error
		return databaseTypes.User{}, restTypes.ErrorResponse{
			Message: "Authorization header has an invalid format",
			Code:    401,
		}
	}

	// Extract the token from the Authorization header
	token := strings.TrimPrefix(authHeader, "Bearer ")

	// Query the database for the most recent token for the given token
	var addedAt time.Time
	var user databaseTypes.User
	err = db.QueryRow("SELECT id, user_type, first_name,last_name, email, added_at FROM LoginTokens, Users WHERE (LoginTokens.user_id = Users.id AND token = ? )ORDER BY added_at DESC LIMIT 1", token).Scan(&user.ID, &user.UserType, &user.FirstName, &user.LastName, &user.Email, &addedAt)
	fmt.Println(err)
	if err != nil {
		if err == sql.ErrNoRows {
			//TODO: add a delay, to avoid brut force
			// If the token is not found in the database, return error
			return databaseTypes.User{}, restTypes.ErrorResponse{
				Message: "Token is not found in the database",
				Code:    401,
			}
		}
		// If there was an error querying the database, return error
		return databaseTypes.User{}, restTypes.ErrorResponse{
			Message: "Internal Server Error",
			Code:    500,
		}
	}

	// Check if the token is older than one day
	if time.Since(addedAt) > 24*time.Hour {
		// If the token is older than one day, delete it from the database
		_, err = db.Exec("DELETE FROM LoginTokens WHERE token = ?", token)
		if err != nil {
			// If there was an error deleting the token from the database, return error
			return databaseTypes.User{}, restTypes.ErrorResponse{
				Message: "Internal Server Error",
				Code:    500,
			}
		}
		// Return false to indicate that the token was deleted
		return databaseTypes.User{}, restTypes.ErrorResponse{
			Message: "Token is too old",
			Code:    401,
		}
	}
	return user, restTypes.ErrorResponse{Code: 0}
}

func GetUserByEmail(email string) (*databaseTypes.User, restTypes.ErrorResponse) {
	db, err := sql.Open("sqlite3", "./database.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	var user databaseTypes.User
	row := db.QueryRow("SELECT * FROM Users WHERE email = ?", email)
	err = row.Scan(&user.ID, &user.UserType, &user.FirstName, &user.LastName, &user.Email, &user.Password)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, restTypes.ErrorResponse{Message: "user not found", Code: 401}
		}
		fmt.Println(err.Error())
		return nil, restTypes.ErrorResponse{Message: "FATAL", Code: 500}
	}
	return &user, restTypes.ErrorResponse{Code: 0}
}

func GenerateToken(userID int) (string, error) {
	db, err := sql.Open("sqlite3", "./database.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()
	t, _ := GetTokenForUser(userID)
	if t != "" {
		return t, nil
	}
	token := uuid.New().String()

	// Insert the token and user_id into the LoginTokens table
	_, err = db.Exec("INSERT INTO LoginTokens (token, user_id) VALUES (?, ?)", token, userID)
	if err != nil {
		return "", fmt.Errorf("error inserting token into database: %w", err)
	}

	// Return the generated token
	return token, nil
}
