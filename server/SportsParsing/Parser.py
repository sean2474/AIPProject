import logging
import re
import sys
from tqdm import tqdm
from bs4 import BeautifulSoup
import requests as r
from fake_useragent import UserAgent
from EventRecord import EventRecord
from SportInfoRecord import SportsInfoRecord


class NullSoupException(Exception):
    pass


class Parser:
    def __init__(self):
        self.event_records = []
        self.sport_records = []
        self.sport_groups = {
            "Fall Sports": {
                "Football": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/fall-sports/varsityfootball",
                    "JV": "https://www.avonoldfarms.com/athletics/teams-schedules/fall-sports/jvfootball",
                    "Thirds": "https://www.avonoldfarms.com/athletics/teams-schedules/fall-sports/jvfootball-clone"
                },
                "Soccer": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/fall-sports/varsitysoccer",
                    "JV": "https://www.avonoldfarms.com/athletics/teams-schedules/fall-sports/jvsoccer",
                    "Thirds": "https://www.avonoldfarms.com/athletics/teams-schedules/fall-sports/thirdssoccer",
                    "Fourths": "https://www.avonoldfarms.com/athletics/teams-schedules/fall-sports/fourthssoccer",
                    "Fifths": "https://www.avonoldfarms.com/athletics/teams-schedules/fall-sports/fifthssoccer"
                },
                "Cross Country": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/fall-sports/crosscountry"
                }
            },
            "Winter Sports": {
                "Hockey": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/varsityhockey",
                    "Varsity B": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/varsitybhockey",
                    "Thirds Blue": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports"
                                   "/thirdsbluehockey",
                    "Thirds Red": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/thirdsred"
                },
                "Basketball": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/varsitybasketball",
                    "JV": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/jvbasketball",
                    "Thirds Blue": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports"
                                   "/thirdsbasketballblue",
                    "Thirds Red": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports"
                                  "/thirdsbasketballred"
                },
                "Squash": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/varsitysquash",
                    "JV": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/jvsquash",
                    "Thirds": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/thirdssquash"
                },
                "Swimming": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/swimming"
                },
                "Wrestling": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/varsitywrestling"
                }
            },
            "Spring Sports": {
                "Baseball": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/varsitybaseball",
                    "JV": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/jvbaseball",
                    "Thirds": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/baseballthirds"
                },
                "Lacrosse": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/varsitylacrosse",
                    "Varsity B": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/"
                                 "varsityblacrosse",
                    "JV": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/jvlacrosse",
                    "Thirds": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/thirdslacrosse"
                },
                "Golf": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/varsitygolf",
                    "JV": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/jvgolf"
                },
                "Track and Field": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/trackandfield"
                },
                "Tennis": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/varsitytennis",
                    "JV": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/jvtennis",
                    "Thirds": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/thirdstennis"
                }
            }
        }

    def parse_all_info(self) -> tuple:
        """
        Function to parse information about sports from Avon Old Farms website.
        :return: List of records of sport events, that include:
                    - id (generated id from 0 to 2147483647)
                    - sport_name (Sport label)
                    - sport_group (Sport group (e.g Varsity, JV, etc.))
                    - game_location
                    - opponent_school
                    - is_away (True if game was not in Avon, otherwise - False. If not stated - null)
                    - match_result
                    - coach_comment (always null <3 uwu)
                    - game_schedule (Day and time of the game)
                List of sport information records, that include:
                    - sport_label
                    - category
                    - season (Fall, Winter, Spring)
                    - coach_name
                    - coach_contact (phone number)
                    - roster (list of players)
        """
        for season in self.sport_groups.keys():
            for sport in self.sport_groups[season].keys():
                for category in tqdm(self.sport_groups[season][sport], desc="Parsing categories and their matches from "
                                                                            + sport):
                    self.parse_sport(season, sport, category, self.sport_groups[season][sport][category])
        return self.event_records, self.sport_records

    def get_sport_groups(self):
        return self.sport_groups

    def __is_valid_data(self, el: str) -> bool:
        """
        :param el: Element to check
        :return: True if element does not contain useless/empty data else False
        """
        el = el.strip()
        if el not in ["Subscribe to Alerts", ""]:
            return True
        return False

    def get_sport_groups(self) -> dict:
        return self.sport_groups

    def extract_first_appeared_class_content(self, input_string: str) -> str or None:
        pattern = r'class="([^"]*)"'
        match = re.search(pattern, input_string)

        if match:
            return match.group(1)
        else:
            return

    def does_contain_trash_tags(self, string: str) -> bool:
        return ("fsResource" in string) or \
            ("fsStyleAutoclear" in string) or \
            ("fsResourceTypeImage" in string or
            ("fsResourceTypeVideo" in string))

    def parse_sport(self, season: str, sport: str, category: str, link: str):
        """
        Gathers data from particular link from Avon Old Farms website.
        Links might be found in self.sport_groups dictionary. (aka. get_sport_groups())

        :param season: Sport season
        :param sport: Sport label
        :param category: Sport category (group) e.g Varsity, JV, etc.
        :param link: Link to avonoldfarms.com
        :return: Event records, SportInfo records
        """
        # Request to the site
        request_code = -1
        try:
            # Sending request to passed link
            response = r.get(link, headers={"User-Agent": UserAgent().random})
            request_code = response.status_code
            soup = BeautifulSoup(response.text, 'html.parser')

            # Parsing information from the response text
            try:
                # Getting information about coaches
                coach_name = "";coach_phone = ""
                try:
                    # Only completely filled profiles are going to be parsed ( fsHasPhoto )
                    coach_blocks = soup.find_all("div", class_="fsConstituentItem fsHasPhoto")

                    # Getting information about coach
                    for element in coach_blocks:
                        coach_name = element.find("a", "fsConstituentProfileLink").text.strip()
                        coach_phone = element.find("div", "fsPhones").find("a").text.strip()

                except Exception as e:
                    logging.error(f"Unable to gather coach data from {link} - {e}")
                    coach_name = coach_phone = "null"

                # Getting team roster
                roster = []
                try:
                    if not soup:
                        raise NullSoupException("Bad soup")
                    raw_roster = soup.find("table", "fsElementTable").find("tbody").find_all("tr")
                    for element in raw_roster:
                        # Parsing each element of table and cleaning it.
                        roster.append([el.strip() for el in element.text.split("\n") if len(el.strip()) > 0])
                except Exception as e:
                    logging.warning(f"Empty roster in ({link}); ({e})")
                    roster = "Empty roster"

                # Passing data to SportsInfoRecord to organize it
                self.sport_records.append(
                    SportsInfoRecord(sport, category, season, coach_name, coach_phone, roster)
                )

                # Indicator of invalid info
                broken_game = bool()

                # Getting games and information about them
                games = soup.find_all("article")
                broken_link = False
                for game in games:
                    # Filtering meaningless/invalidly parsed data
                    if len(game.text.split("\n")) < 2:
                        classes = self.extract_first_appeared_class_content(str(game)).split(" ")
                        if not self.does_contain_trash_tags(classes):
                            broken_link = True
                            continue
                    else:
                        # Cleaning gathered data
                        data = [j.strip() for j in game.text.split("\n") if self.__is_valid_data(j)]

                        # Passing data to EventRecord to organize it
                        self.event_records.append(EventRecord(data, sport=sport, category=category))
                if broken_link:
                    logging.error(f"Invalid data had been gathered from {sport}, {category} ({link})")

        # Logging errors if there are any
            except Exception as e:
                logging.error(f"Invalid data had been gathered from {link} - exception: {e}")
        except r.exceptions.RequestException as req_ex:
            logging.error(f"Exception occurred with request to {link}. Code: "
                          f"{request_code if request_code != -1 else 'Failed to determine actual request code'}"
                          f", exception:{req_ex}")

