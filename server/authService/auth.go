package authService

import "net/http"

func Login(login string, password string) (string, error) {
	return "", nil
}

// basicAuthMW is middleware function to check whether user is authenticated or not
// actually you could write better code for this function
func basicAuthMW(w http.ResponseWriter, r *http.Request) {

}
