import random


class SportsInfoRecord:
    def __init__(self, sport_label: str, category: str, season: str, coach_name: str, coach_contact: str, roster: list):
        self.id = self.__generate_id()
        self.sport_label = sport_label
        self.category = category
        self.season = season
        self.coach_name = coach_name
        self.coach_contact = coach_contact
        self.roster = roster

    def __generate_id(self) -> int:
        return random.randint(0, 2147483647)

    def __str__(self) -> str:
        return (f"SportsInfoRecord[sport_label={self.sport_label}, "
                f"category={self.category}, "
                f"season={self.season}, "
                f"coach_name={self.coach_name}, "
                f"coach_number={self.coach_contact}, "
                f"roster={str(sum([' '.join(i) for i in self.roster], []))}")

    def get_tuple(self) -> tuple:
        return self.id, self.sport_label, self.category, self.season, self.coach_name, self.coach_contact, str(self.roster)
