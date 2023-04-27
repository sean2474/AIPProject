import random
import re

from ConstantExpressions import ConstantExpressions


class EventRecord:
    def __init__(self, data: list, sport: str, category: str):
        self.raw_data = data

        self.event_date = self.__search_event_date()
        self.date_time = self.__search_date_time()

        _, self.opponent_school = self.__search_sport_group_and_opponent()  # Hardcode
        self.group = category
        self.sport = sport

        self.is_away = self.__search_if_away()
        self.is_win = self.__search_win_data()
        self.game_score = self.__search_score_data()
        self.is_cancelled = self.__was_game_cancelled()

        self.game_location = self.__decide_game_location()

    def __generate_id(self) -> int:
        return random.randint(0, 2147483647)

    def __remove_quotes_and_strip(self, el: str) -> str:
        return el.replace("\"", "").replace("'", "").strip()

    def __search_date_time(self) -> str or None:
        for r in self.raw_data:
            if re.match(ConstantExpressions().REGEX_DAYTIME, r):
                return r
        if "TBD" in self.raw_data[0:3]:
            return "TBD"
        else:
            return None

    def __search_event_date(self) -> str or None:
        if re.match(ConstantExpressions().REGEX_DATE, self.raw_data[0]):
            return self.raw_data[0]
        else:
            if self.raw_data[0].count("/") == 2 and re.match(ConstantExpressions().REGEX_NUMERIC_DATE, self.raw_data[0]):
                return self.raw_data[0]
        return None

    def __search_sport_group_and_opponent(self) -> tuple:
        try:
            vs_index = self.raw_data.index('vs.')
            if vs_index > 1:
                return self.__remove_quotes_and_strip(self.raw_data[vs_index-1]), \
                    self.__remove_quotes_and_strip(self.raw_data[vs_index+1])
        except ValueError:
            return self.__remove_quotes_and_strip(self.raw_data[2]), self.__remove_quotes_and_strip(self.raw_data[3])

    def __was_game_cancelled(self) -> bool:
        if "CANCELLED" in self.raw_data:
            return True
        return False

    def __search_win_data(self) -> bool or None:
        if "Win" in self.raw_data:
            return True
        elif "Loss" in self.raw_data:
            return False
        else:
            return None

    def __search_if_away(self) -> str or None:
        if "Away" in self.raw_data or "away" in self.raw_data:
            return "Away"
        elif "Home" in self.raw_data or "home" in self.raw_data:
            return "Home"
        else:
            return None

    def __search_score_data(self) -> str or None:
        for el in self.raw_data:
            if re.match(ConstantExpressions().REGEX_GAME_SCORE, el) and self.raw_data.index(el) > 4:
                return el
        return None

    def __decide_game_location(self) -> str or None:
        if self.is_away is not None and self.is_away and self.opponent_school is not None:
            return self.opponent_school
        return None

    def __define_sport(self) -> str:
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

    def __make_none_data_null(self):
        if self.sport is None:
            self.sport = "null"
        if self.group is None:
            self.group = "null"
        if self.game_location is None:
            self.game_location = "null"
        if self.opponent_school is None:
            self.opponent_school = "null"
        if self.is_away is None:
            self.is_away = "null"
        if self.game_score is None:
            self.game_score = "null"
        if self.event_date is None:
            self.event_date = ""
        if self.date_time is None:
            self.date_time = ""
        if self.event_date + self.date_time == "":
            self.event_date = "null"

    def get_tuple(self) -> tuple:
        self.__make_none_data_null()
        return str(self.__generate_id()), \
            self.sport, \
            self.group, \
            self.game_location, \
            self.opponent_school, \
            self.is_away, \
            self.game_score, \
            "null", \
            str(self.event_date+" "+self.date_time)

    def __str__(self) -> str:
        return "GameEvent[id=" + str(self.__generate_id()) + \
            ", sport_name=" + self.sport + \
            ", sport_group=" + self.group + \
            ", game_location=" + self.game_location + \
            ", opponent_school=" + self.opponent_school + \
            ", is_away=" + self.is_away + \
            ", match_result=" + self.game_score + \
            ", coach_comment=null" + \
            ", game_schedule=" + self.event_date + " " + self.date_time + "]"
