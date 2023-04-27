from bs4 import BeautifulSoup
import pandas as pd
import requests as r
import sqlite3
from Parser import Parser


def main():
    # TODO Set up work with SportsInfo table.
    # TODO Set up auto-launch.
    # TODO Set up error handling
    parser = Parser()
    # parser.parse_sport("1", "1", "https://www.avonoldfarms.com/athletics/teams-schedules/fall-sports/varsitysoccer")
    events = parser.parse_all_info()

    try:
        sqlite_connection = sqlite3.connect('database.db')
        cursor = sqlite_connection.cursor()

        print("[~] Uploading data to DB...")
        cursor.executemany('''
        INSERT INTO SportsGames (id, sport_name, category, game_location, opponent_school, home_or_away, match_result, coach_comment, game_schedule)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
        ''', events)

        sqlite_connection.commit()
        print("[~] Done!")
        cursor.close()

    except sqlite3.Error as error:
        print('Error occurred - ', error)


if __name__ == "__main__":
    main()