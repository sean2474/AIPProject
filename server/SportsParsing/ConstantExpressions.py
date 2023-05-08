SPORTS_INFO_SQL_INSERT_QUERY = "INSERT INTO SportsInfo (id, sport_name, category, season, coach_name, coach_contact, roster) VALUES (?, ?, ?, ?, ?, ?, ?);"
SPORTS_GAMES_SQL_INSERT_QUERY = "INSERT INTO SportsGames (id, sport_name, category, game_location, opponent_school, home_or_away, match_result, coach_comment, game_schedule) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
REGEX_DAYTIME = "^([1-9]|1[0-2]):([0-5][0-9])\s(AM|PM)$"
REGEX_DATE = "^(Sun|Mon|Tue|Wed|Thu|Fri|Sat)\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s([1-9]|[12][0-9]|3[01])$"
REGEX_NUMERIC_DATE = "^(0?[1-9]|1[0-2])\/(0?[1-9]|[12]\d|3[01])\/\d{2}$"
REGEX_GAME_SCORE = "^\d{1,3}-\d{1,3}$"
HOURS24_FORMAT_CHECK = r'^([01]\d|2[0-3]):([0-5]\d)$'