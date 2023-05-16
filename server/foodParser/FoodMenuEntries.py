from datetime import datetime
import json
from typing import List, Tuple, Dict, Any

import requests as r
from fake_useragent import UserAgent


class FoodMenuEntries:
    def __init__(self, date_from: tuple):
        self.from_year = date_from[0]
        self.from_month = date_from[1]
        self.from_day = date_from[2]
        self.food_menu_entries = self.parse_until_unfilled_data_appears()

    def parse_until_unfilled_data_appears(self) -> Dict[Any, Dict[Any, Any]]:
        def get_json(intake: str):
            link = f"https://avonoldfarms.api.flikisdining.com/menu/api/weeks/school/avon-old-farms/menu-type/" \
                   f"{intake}/{self.from_year}/{self.from_month}/{self.from_day}/?format=json"
            res = r.get(link, headers={"User-Agent": UserAgent().random}).text
            return res

        def day_of_week(date_str) -> str:
            date_obj = datetime.strptime(date_str, '%Y-%m-%d')
            days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
            return days[date_obj.weekday()]

        def sort_dates(strings_list_of_tuples) -> List[str]:
            datetime_objects = [datetime.strptime(d[0], '%Y-%m-%d') for d in strings_list_of_tuples]
            sorted_datetime_objects = sorted(datetime_objects)
            sorted_dates = [d.strftime('%Y-%m-%d') for d in sorted_datetime_objects]
            return sorted_dates

        daily_food_intakes = dict()
        dates = list()

        for food_intake in ["breakfast", "lunch", "dinner"]:
            food_data = json.loads(get_json(food_intake)).get("days")
            for day in range(0, 6):
                date = food_data[day].get("date")
                dict_key = date
                dates.append(dict_key)

                try:
                    daily_food_intakes[dict_key][food_intake] = []
                except KeyError:
                    daily_food_intakes[dict_key] = dict()

                meals_data = list()
                for meal_number in range(1, len(food_data[day].get("menu_items")) - 1):
                    try:
                        meals_data.append(food_data[day].get("menu_items")[meal_number].get("food").get("name"))
                    except AttributeError:
                        meals_data.append("null")
                daily_food_intakes[dict_key][food_intake] = [meal for meal in meals_data if meal != "null"] \
                    if meals_data else ["null"]

        # dates = sort_dates(dates)
        return daily_food_intakes

    def get_parsed_data(self) -> Dict[Any, Dict[Any, Any]]:
        return self.food_menu_entries

