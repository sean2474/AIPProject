import json
import sys
import pandas as pd
from tqdm import tqdm
from bs4 import BeautifulSoup
import requests as r
from fake_useragent import UserAgent

from EventRecord import EventRecord


def parse_coaches_and_roaster(link):
    response = r.get(link, headers={"User-Agent": UserAgent().random})
    soup = BeautifulSoup(response.text, 'html.parser')

    coaches = soup.find_all("div", class_="fsConstituentItem fsHasPhoto")
    roaster = soup.find("table", class_="fsElementTable")
    for i in coaches:
        print(i.text)
    df = pd.read_html(roaster)
    print(df.iloc(1))
    #class="fsConstituentItem fsHasPhoto"


class Parser:
    def __init__(self):
        self.event_records = []
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
                    "Thirds Blue": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/thirdsbluehockey",
                    "Thirds Red": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/thirdsred"
                },
                "Basketball": {
                    "Varsity": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/varsitybasketball",
                    "JV": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/jvbasketball",
                    "Thirds Blue": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/thirdsbasketballblue",
                    "Thirds Red": "https://www.avonoldfarms.com/athletics/teams-schedules/wintersports/thirdsbasketballred"
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
                    "Varsity B": "https://www.avonoldfarms.com/athletics/teams-schedules/spring-sports/varsityblacrosse",
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

    def parse_all_info(self):
        for season in self.sport_groups.keys():
            for sport in self.sport_groups[season].keys():
                for category in tqdm(self.sport_groups[season][sport], desc="Parsing categories and their matches from "
                                                                            + sport):
                    self.parse_sport(sport, category, self.sport_groups[season][sport][category])
        return self.event_records

    def is_valid_data(self, el):
        el = el.strip()
        if el not in ["Subscribe to Alerts", ""]:
            return True
        return False

    def parse_sport(self, sport, category, link):
        response = r.get(link, headers={"User-Agent": UserAgent().random})
        soup = BeautifulSoup(response.text, 'html.parser')
        # roaster = pd.read_html(soup.find("table"))
        # coaches = soup.find_all("div", class_="fsConstituentItem fsHasPhoto")
        # print(roaster)
        # TODO Finish
        games = soup.find_all("article")
        for i in games:
            if len(i.text.split("\n")) < 2:
                sys.stderr.write(f"[!] Unhandled error with {sport}, {category}")
                continue
            data = [j.strip() for j in i.text.split("\n") if self.is_valid_data(j)]
            self.event_records.append(EventRecord(data, sport=sport, category=category).get_tuple())



