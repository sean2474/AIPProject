package dailySchedule

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"server/databaseControllers"
	"server/restTypes"
	"strings"
	"time"
)

// GetDailySchedule @Summary Get the daily schedule image for the current date
// @Summary Get the daily schedule image for the current date
// @Description Retrieves the daily schedule image for the current date from the database
// @Tags DailySchedule
// @Accept  */*
// @Produce  image/jpeg
// @Security Bearer
// @Success 200 {string} OK
// @Failure 401 {string} Unauthorized
// @Failure 404 {string} Not Found
// @Failure 500 {string} Internal Server Error
// @Router /data/daily-schedule/ [get]
func GetDailySchedule(w http.ResponseWriter, r *http.Request) {
	// Check authentication
	_, erro := databaseControllers.IsAuthorized(w, r)
	if erro.Code != 0 {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}
	db, err := sql.Open("sqlite3", "database.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Query the database for the daily schedule image
	query := "SELECT image_file FROM DailySchedule WHERE date = ?"
	row := db.QueryRow(query, time.Now().Format("2006-01-02"))

	// Extract the image data from the row
	var image []byte
	err = row.Scan(&image)
	if err == sql.ErrNoRows {
		http.NotFound(w, r)
		return
	} else if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

	// Set the response headers
	w.Header().Set("Content-Type", "image/jpeg")
	w.WriteHeader(http.StatusOK)

	// Write the image data to the response body
	w.Write(image)
}

// PostDailySchedule @Summary Upload the daily schedule image for the current date
// @Summary Upload the daily schedule image for the current date
// @Description Uploads the daily schedule image for the current date to the database
// @Tags DailySchedule
// @Accept  multipart/form-data
// @Produce  json
// @Security Bearer
// @Param image formData file true "The daily schedule image file"
// @Success 201 {object} restTypes.LoginResponse
// @Failure 400 {string} Bad Request
// @Failure 401 {string} Unauthorized
// @Failure 500 {string} Internal Server Error
// @Router /data/daily-schedule/ [post]
func PostDailySchedule(w http.ResponseWriter, r *http.Request) {
	// Check authentication
	_, erro := databaseControllers.IsAuthorized(w, r)
	if erro.Code != 0 {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	// Parse the form data
	err := r.ParseMultipartForm(32 << 20) // Limit: 32 MB
	if err != nil {
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}

	// Get the image file from the form data
	file, _, err := r.FormFile("image")
	if err != nil {
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}
	defer file.Close()

	// Read the image data from the file
	image, err := ioutil.ReadAll(file)
	if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}
	db, err := sql.Open("sqlite3", "database.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Insert the image data into the database
	query := "INSERT INTO DailySchedule (date, image_file, image_url, file_name) VALUES (?, ?, ?, ?)"
	_, err = db.Exec(query, time.Now().Format("2006-01-02"), image, "", "")
	if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

	// Set the response headers
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusCreated)

	// Write the response
	response := restTypes.LoginResponse{
		Status:  "success",
		Message: "Daily schedule uploaded successfully",
	}
	json.NewEncoder(w).Encode(response)
}

// PutDailySchedule @Summary Update the daily schedule image for a specific date
// @Summary Update the daily schedule for a specific date
// @Description Updates the daily schedule image for a specific date in the database
// @Tags DailySchedule
// @Produce  json
// @Security Bearer
// @Param date path string true "The date of the daily schedule to update (in YYYY-MM-DD format)"
// @Param image formData file true "The updated image file for the daily schedule (limit: 32 MB)"
// @Success 200 {object} restTypes.LoginResponse
// @Failure 400 {string} Bad Request
// @Failure 401 {string} Unauthorized
// @Failure 500 {string} Internal Server Error
// @Router /data/daily-schedule/{date} [put]
func PutDailySchedule(w http.ResponseWriter, r *http.Request) {
	// Check authentication
	_, erro := databaseControllers.IsAuthorized(w, r)
	if erro.Code != 0 {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	// Get the schedule date from the URL path
	parts := strings.Split(r.URL.Path, "/")
	if len(parts) != 4 {
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}
	scheduleDate := parts[3]

	// Parse the form data
	err := r.ParseMultipartForm(32 << 20) // Limit: 32 MB
	if err != nil {
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}

	// Get the image file from the form data
	file, _, err := r.FormFile("image")
	if err != nil {
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}
	defer file.Close()

	// Read the image data from the file
	image, err := ioutil.ReadAll(file)
	if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}
	db, err := sql.Open("sqlite3", "database.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	// Update the image data in the database using the date
	query := "UPDATE DailySchedule SET image_file = ? WHERE date = ?"
	_, err = db.Exec(query, image, scheduleDate)
	if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

	// Set the response headers
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)

	// Write the response
	response := restTypes.LoginResponse{
		Status:  "success",
		Message: "Daily schedule updated successfully",
	}
	json.NewEncoder(w).Encode(response)
}

// DeleteDailySchedule @Summary Delete the daily schedule image for a specific date
// @Summary Delete the daily schedule for a specific date
// @Description Deletes the daily schedule for a specific date from the database
// @Tags DailySchedule
// @Produce  json
// @Security Bearer
// @Param date path string true "The date of the daily schedule to delete (in YYYY-MM-DD format)"
// @Success 200 {object} restTypes.LoginResponse
// @Failure 400 {string} Bad Request
// @Failure 401 {string} Unauthorized
// @Failure 500 {string} Internal Server Error
// @Router /data/daily-schedule/{date} [delete]
func DeleteDailySchedule(w http.ResponseWriter, r *http.Request) {
	// Check authentication
	_, erro := databaseControllers.IsAuthorized(w, r)
	if erro.Code != 0 {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	// Get the schedule date from the URL path
	parts := strings.Split(r.URL.Path, "/")
	if len(parts) != 4 {
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}
	scheduleDate := parts[3]
	fmt.Println(scheduleDate)
	db, err := sql.Open("sqlite3", "database.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Delete the record from the database using the date
	query := "DELETE FROM DailySchedule WHERE date = ?"
	_, err = db.Exec(query, scheduleDate)
	if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

	// Set the response headers
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)

	// Write the response
	response := restTypes.LoginResponse{
		Status:  "success",
		Message: "Daily schedule deleted successfully",
	}
	json.NewEncoder(w).Encode(response)
}
