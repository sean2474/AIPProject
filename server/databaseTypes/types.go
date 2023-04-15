package main

import "time"

type User struct {
	ID        int    `json:"id"`
	Token     string `json:"token"`
	UserType  int    `json:"user_type"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Email     string `json:"email"`
	Password  string `json:"-"`
}
type DailySchedule struct {
	ID        int    `json:"id"`
	Date      string `json:"date"`
	ImageFile []byte `json:"image_file,omitempty"`
	ImageURL  string `json:"image_url,omitempty"`
	FileName  string `json:"file_name"`
}

type FoodMenu struct {
	ID        int    `json:"id"`
	Date      string `json:"date"`
	Breakfast string `json:"breakfast"`
	Lunch     string `json:"lunch"`
	Dinner    string `json:"dinner"`
}

type LostAndFound struct {
	ID            int       `json:"id"`
	ItemName      string    `json:"item_name"`
	Description   string    `json:"description,omitempty"`
	DateFound     time.Time `json:"date_found"`
	LocationFound string    `json:"location_found"`
	Status        int       `json:"status"`
	ImageFile     []byte    `json:"image_file,omitempty"`
	SubmitterID   int       `json:"submitter_id"`
}

type SportsGame struct {
	ID             int       `json:"id"`
	SportName      string    `json:"sport_name"`
	Category       int       `json:"category"`
	GameLocation   string    `json:"game_location"`
	OpponentSchool string    `json:"opponent_school"`
	HomeOrAway     int       `json:"home_or_away"`
	MatchResult    string    `json:"match_result,omitempty"`
	CoachComment   string    `json:"coach_comment,omitempty"`
	GameSchedule   time.Time `json:"game_schedule"`
}

type SportsInfo struct {
	ID           int      `json:"id"`
	SportName    string   `json:"sport_name"`
	Category     int      `json:"category"`
	Season       int      `json:"season"`
	CoachName    []string `json:"coach_name"`
	CoachContact []string `json:"coach_contact"`
	Roster       string   `json:"roster,omitempty"`
}

type SchoolStore struct {
	ID          int       `json:"ID"`
	ProductName string    `json:"Product_Name"`
	Category    int       `json:"Category"`
	Price       float64   `json:"Price"`
	Stock       int       `json:"Stock"`
	Description string    `json:"Description,omitempty"`
	ImageFile   []byte    `json:"image_file,omitempty"`
	DateAdded   time.Time `json:"Date_Added"`
}
