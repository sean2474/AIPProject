package restTypes

type ErrorResp struct {
	Error string `json:"error"`
}

type IndexResp struct {
	Message string `json:"message"`
}

type MeResp struct {
	Username string `json:"username"`
	Fullname string `json:"fullname"`
}

type AuthResp struct {
	Token string `json:"token"`
}

type AuthParam struct {
	Username string `json:"username"`
	Password string `json:"password"`
}
