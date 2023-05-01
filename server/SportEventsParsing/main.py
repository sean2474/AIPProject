# main.py
from datetime import datetime
from typing import List, Tuple, Any

from Parser import Parser
import logging
import sqlite3
import argparse
import time
import re

from ConstantExpressions import ConstantExpressions

database_filename = "../database.db"


def time_remaining(task):
    """
    :param task: Current task from scheduled ones
    :return: Time until task will be executed
    """
    next_run = task.next_run
    now = datetime.now()
    time_diff = next_run - now
    return time_diff


def is_time24_format(time_str) -> str:
    """
    :param time_str: Possible string to check if it satisfies 24h time format.
    :return: True if time_str satisfies format HH:mm else False
    """
    if not re.match(ConstantExpressions().HOURS24_FORMAT_CHECK, time_str):
        raise argparse.ArgumentTypeError(f"Invalid time format: '{time_str}'. Expected format: HH:mm (24-hour).")
    return time_str


def parse_data() -> Tuple[List[Any], List[Any]] or None:
    logging.info("Starting parsing...")

    # Creating parser object - required for parsing any information.
    parser = Parser()

    try:
        events, sport_infos = parser.parse_all_info()
        logging.info("Successfully parsed all information.")
        return events, sport_infos
    except Exception as e:
        logging.critical(f"Parsing failed. Exception: {e}")
    return None


def write_to_database(events: List[Any], sport_infos: List[Any]) -> bool:
    if events is None or sport_infos is None:
        return False
    else:
        try:
            # Connecting to the database
            sqlite_connection = sqlite3.connect(database_filename)
            cursor = sqlite_connection.cursor()
            logging.info("Successfully connected to database, started uploading data to DB")

            # Inserting parsed data to SportsGames
            #
            logging.info("Inserting information to SportsGames")
            # Getting records from SportGame record (EventRecord)
            cursor.executemany(ConstantExpressions().SPORTS_GAMES_SQL_INSERT_QUERY,
                               tuple(el.get_tuple() for el in events))
            sqlite_connection.commit()

            # Inserting parsed data to SportsInfo
            #
            logging.info("Inserting information to SportsInfo")
            # Getting records from SportInfo record (SportInfoRecord)
            cursor.executemany(ConstantExpressions().SPORTS_INFO_SQL_INSERT_QUERY,
                               tuple(el.get_tuple() for el in sport_infos))
            sqlite_connection.commit()

            # Closing connection with database
            cursor.close()
            logging.info("Successfully uploaded information to database")
            return True

        # Logging information about working with database
        except sqlite3.Error as error:
            logging.error(f"Writing to database failed with sqlite3.Error: {error}")
        except Exception as ex:
            logging.error(f"Writing to database failed with unhandled exception: {ex}")
    return False


def setup() -> None:
    # global database_filename
    # Logging settings
    logging.basicConfig(filename=f'launch_{datetime.now()}', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    #
    # # Parser settings
    # arg_parser = argparse.ArgumentParser(description='Program that accepts multiple time values in 24-hour format and '
    #                                                  'database filename')
    # # Argument for setting up the time
    # arg_parser.add_argument('-t', '--times', type=is_time24_format, nargs='+',
    #                         help='Time values in 24-hour format (HH:mm)')
    #
    # # Argument for setting up database filename
    # arg_parser.add_argument('-d', '--database', type=str, required=True, help='Path to the SQLite database file')
    #
    # # Parsing command line arguments
    # args = arg_parser.parse_args()

    # Set up database file
    # database_filename = args.database
    #
    # # Scheduling parsing
    # schedule_logging_message = ""
    # if len(args.times) > 0:
    #     # Custom parsing time
    #     for t in args.times:
    #         schedule.every().day.at(t).do(update)
    #         schedule_logging_message += t + " "
    # else:
    #     # Default time
    #     schedule.every().day.at("00:00").do(update)
    #     schedule.every().day.at("12:00").do(update)
    #     schedule_logging_message += "00.00 12.00"

    # Logging setup information
    # logging.info(f"Successfully scheduled parsing processes at {schedule_logging_message} every day")
    # logging.info(f"Database filename: {database_filename}")


def update() -> None:
    sport_events, sport_information = parse_data()
    commit_factor = False
    if not(sport_events is None) and not(sport_information is None):
        commit_factor = write_to_database(sport_events, sport_information)
    if commit_factor:
        logging.info("Update finished.")
        return
    else:
        time.sleep(3600)
        update()


if __name__ == "__main__":
    setup()     # Setup of argument parser, logging
    update()    # Regular parsing based on a schedule
    # while True:
    #     # Getting information about scheduled tasks
    #     job = schedule.get_jobs()[0]
    #     remaining_time = time_remaining(job)
    #
    #     # Printing information about current scheduled task.
    #     sys.stdout.write(f"[T] Time remaining until the next complete sport parsing: {remaining_time}\n")
    #     sys.stdout.write("\033[F")  # Move cursor up one line
    #     sys.stdout.write("\033[K")  # Clear the line
    #     sys.stdout.flush()
    #
    #     # Checking if there is a task to run
    #     schedule.run_pending()
    #
    #     # Waiting until the next check
    #     time.sleep(60)
