import random
from regex_constants import *
import re


class EventRecord:
    def __init__(self, data: list, sport: str = "", category: str = ""):
        self.raw_data = data

        self.event_date = self._search_event_date()
        self.date_time = self._search_date_time()

        _, self.opponent_school = self._search_sport_group_and_opponent()
        self.group = category
        self.sport = sport

        self.is_away = self._search_if_away()
        self.is_win = self._search_win_data()
        self.game_score = self._search_score_data()
        self.is_cancelled = self._was_game_cancelled()

        self.game_location = self._decide_game_location()

    def _generate_id(self):
        return random.randint(0, 2147483647)

    def _remove_quotes_and_strip(self, el):
        return el.replace("\"", "").replace("'", "").strip()

    def _search_date_time(self):
        for r in self.raw_data:
            if re.match(REGEX_DAYTIME, r):
                return r
        if "TBD" in self.raw_data[0:3]:
            return "TBD"
        else:
            return None

    def _search_event_date(self):
        if re.match(REGEX_DATE, self.raw_data[0]):
            return self.raw_data[0]
        else:
            if self.raw_data[0].count("/") == 2 and re.match(REGEX_NUMERIC_DATE, self.raw_data[0]):
                return self.raw_data[0]
        return None

    def _search_sport_group_and_opponent(self):
        try:
            vs_index = self.raw_data.index('vs.')
            if vs_index > 1:
                return self._remove_quotes_and_strip(self.raw_data[vs_index-1]), \
                    self._remove_quotes_and_strip(self.raw_data[vs_index+1])
        except ValueError:
            return self._remove_quotes_and_strip(self.raw_data[2]), self._remove_quotes_and_strip(self.raw_data[3])

    def _was_game_cancelled(self):
        if "CANCELLED" in self.raw_data:
            return True
        return False

    def _search_win_data(self):
        if "Win" in self.raw_data:
            return True
        elif "Loss" in self.raw_data:
            return False
        else:
            return None

    def _search_if_away(self):
        if "Away" in self.raw_data or "away" in self.raw_data:
            return "Away"
        elif "Home" in self.raw_data or "home" in self.raw_data:
            return "Home"
        else:
            return None

    def _search_score_data(self):
        for el in self.raw_data:
            if re.match(REGEX_GAME_SCORE, el) and self.raw_data.index(el) > 4:
                return el
        return None

    def _decide_game_location(self):
        if self.is_away is not None and self.is_away and self.opponent_school is not None:
            return self.opponent_school
        return None

    def _define_sport(self):
        if self.group is not None:
            if "Track" in self.group and "Field" in self.group:
                return "Track & Field"
            elif "Football" in self.group:
                return "Football"
            elif "Soccer" in self.group:
                return "Soccer"
            elif "Cross" in self.group and "Country" in self.group:
                return "Cross Country"
            elif "Hockey" in self.group:
                return "Hockey"
            elif "Basketball" in self.group:
                return "Basketball"
            elif "Squash" in self.group:
                return "Squash"
            elif "Swimming" in self.group:
                return "Swimming"
            elif "Wrestling" in self.group:
                return "Wrestling"
            elif "Baseball" in self.group:
                return "Baseball"
            elif "Lacrosse" in self.group:
                return "Lacrosse"
            elif "Golf" in self.group:
                return "Golf"
            elif "Tennis" in self.group:
                return "Tennis"

    def _make_None_data_null(self):
        if self.sport is None: self.sport = "null"
        if self.group is None: self.group = "null"
        if self.game_location is None: self.game_location = "null"
        if self.opponent_school is None: self.opponent_school = "null"
        if self.is_away is None: self.is_away = "null"
        if self.game_score is None: self.game_score = "null"
        if self.event_date is None: self.event_date = ""
        if self.date_time is None: self.date_time = ""
        if self.event_date + self.date_time == "":
            self.event_date = "null"

    def get_tuple(self):
        self._make_None_data_null()
        return str(self._generate_id()), \
            self.sport, \
            self.group, \
            self.game_location, \
            self.opponent_school, \
            self.is_away, \
            self.game_score, \
            "null", \
            str(self.event_date+" "+self.date_time)

    def __str__(self):
        return "GameEvent[id="+str(self._generate_id())+ \
              ", sport_name="+self.sport+ \
              ", sport_group="+self.group+ \
              ", game_location="+self.game_location+ \
              ", opponent_school="+self.opponent_school+ \
              ", is_away="+self.is_away+ \
              ", match_result="+self.game_score+ \
              ", coach_comment=null"+ \
              ", game_schedule="+self.event_date+" "+self.date_time+"]"
