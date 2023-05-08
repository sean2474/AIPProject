import random
import re

import ConstantExpressions


class EventRecord:
    def __init__(self, data: list, sport: str, category: str):
        self.raw_data = data

        self.event_date = self.__search_event_date()
        self.date_time = self.__search_date_time()

        self.opponent_school = self.__search_opponent()

        self.category = self.__define_category(category)
        self.sport = self.__define_sport(sport)

        self.is_away = self.__search_if_away()
        '''
        0 -> Away
        1 -> Home
        2 -> NA
        '''
        self.is_win = self.__search_win_data()
        self.game_score = self.__search_score_data()
        self.is_cancelled = self.__was_game_cancelled()

        self.game_location = self.__decide_game_location()

    def __define_sport(self, sport: str) -> int:
        sport_list = {
            "Football": 0,
            "Soccer": 1,
            "Cross Country": 2,
            "Hockey": 3,
            "Basketball": 4,
            "Squash": 5,
            "Swimming": 6,
            "Wrestling": 7,
            "Baseball": 8,
            "Lacrosse": 9,
            "Golf": 10,
            "Track and Field": 11,
            "Tennis": 12,
            "NA": 13
        }
        if sport in sport_list.keys():
            return sport_list[sport]
        elif "Track" in sport and "Field" in sport:
            return sport_list["Track & Field"]
        elif "Cross" in sport and "Country" in sport:
            return sport_list["Cross Country"]
        return 13

    def __define_category(self, category: str) -> int:
        sport_groups = {
            "Varsity": 0,
            "JV": 1,
            "Varsity B": 2,
            "Thirds": 3,
            "Thirds Blue": 4,
            "Thirds Red": 5,
            "Fourths": 6,
            "Fifths": 7,
            "NA": 8
        }
        if category in sport_groups.keys():
            return sport_groups[category]
        else:
            return sport_groups["NA"]

    def __generate_id(self) -> int:
        return random.randint(0, 2147483647)

    def __remove_quotes_and_strip(self, el: str) -> str:
        return el.replace("\"", "").replace("'", "").strip()

    def __search_date_time(self) -> str or None:
        for r in self.raw_data:
            if re.match(ConstantExpressions.REGEX_DAYTIME, r):
                return r
        if "TBD" in self.raw_data[0:3]:
            return "TBD"
        else:
            return None

    def __search_event_date(self) -> str or None:
        if re.match(ConstantExpressions.REGEX_DATE, self.raw_data[0]):
            return self.raw_data[0]
        else:
            if self.raw_data[0].count("/") == 2 and re.match(ConstantExpressions.REGEX_NUMERIC_DATE,
                                                             self.raw_data[0]):
                return self.raw_data[0]
        return None

    def __search_opponent(self) -> str:
        try:
            vs_index = self.raw_data.index('vs.')
            if vs_index > 1:
                return self.__remove_quotes_and_strip(self.raw_data[vs_index + 1])
        except ValueError:
            return self.__remove_quotes_and_strip(self.raw_data[3])

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
            return 0
        elif "Home" in self.raw_data or "home" in self.raw_data:
            return 1
        else:
            return 2

    def __search_score_data(self) -> str or None:
        for el in self.raw_data:
            if re.match(ConstantExpressions.REGEX_GAME_SCORE, el) and self.raw_data.index(el) > 4:
                return el
        return None

    def __decide_game_location(self) -> str or None:
        if self.is_away is not None and self.is_away and self.opponent_school is not None:
            return self.opponent_school
        return None

    def __make_none_data_null(self):
        if self.sport is None:
            self.sport = "null"
        if self.category is None:
            self.category = "null"
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
            self.category, \
            self.game_location, \
            self.opponent_school, \
            self.is_away, \
            self.game_score, \
            "null", \
            str(self.event_date + " " + self.date_time)

    def __str__(self) -> str:
        self.__make_none_data_null()
        return "GameEvent[id=" + str(self.__generate_id()) + \
            ", sport_name=" + str(self.sport) + \
            ", sport_category=" + str(self.category) + \
            ", game_location=" + self.game_location + \
            ", opponent_school=" + self.opponent_school + \
            ", is_away=" + self.is_away + \
            ", match_result=" + self.game_score + \
            ", coach_comment=null" + \
            ", game_schedule=" + self.event_date + " " + self.date_time + "]"
