import random


class SportsInfoRecord:
    def __init__(self, sport_label: str, category: str, season: str, coach_name: str, coach_contact: str, roster: list):
        self.id = self.__generate_id()
        self.sport_label = sport_label
        self.category = self.__define_category(category)
        self.season = self.__define_season(season)
        self.coach_name = coach_name
        self.coach_contact = coach_contact
        self.roster = roster

    def __generate_id(self) -> int:
        return random.randint(0, 2147483647)

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
    def __define_season(self, season: str) -> int:
        season_enum = {
            "Fall": 0,
            "Winter": 1,
            "Spring": 2,
            "NA": 3
        }
        for k in season_enum.keys():
            if k in season:
                return season_enum[k]
        return season_enum["NA"]

    def __str__(self) -> str:
        return (f"SportsInfoRecord[sport_label={self.sport_label}, "
                f"category={self.category}, "
                f"season={self.season}, "
                f"coach_name={self.coach_name}, "
                f"coach_number={self.coach_contact}, "
                f"roster={str(sum([' '.join(i) for i in self.roster], [])) if isinstance(self.roster, list) else self.roster}")

    def get_tuple(self) -> tuple:
        return self.id, self.sport_label, self.category, self.season, self.coach_name, self.coach_contact, str(self.roster)

