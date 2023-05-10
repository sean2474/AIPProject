import argparse
import logging
import re
import sqlite3
# import schedule as schedule
from datetime import datetime
from typing import Tuple, Dict, Any


from FoodMenuEntries import FoodMenuEntries

SQL_INSERT_STATEMENT = "INSERT INTO FoodMenu (id, date, breakfast, lunch, dinner) VALUES (?, ?, ?, ?, ?)"

database_filename = "../database.db"


def get_current_date() -> Tuple[str, str, str]:
    now = datetime.now()
    return now.strftime("%Y"), now.strftime("%m"), now.strftime("%d")


def parse_content() -> Tuple[Dict[Tuple[Any, str], dict], Dict[str, str]]:
    parser = FoodMenuEntries(get_current_date())    # Constructor calls parsing function
    return parser.get_parsed_data()


def write_data_to_database(data: Dict[Any, Dict[Any, Any]], database) -> bool:
    if data is None:
        return False
    else:
        try:
            def get_max_id(conn):
                c = conn.cursor()
                c.execute('SELECT MAX(id) FROM FoodMenu')
                result = c.fetchone()
                return (result[0] + 1) if result[0] else 1

            def cast_to_tuple(d):
                temporary_list = list()
                max_id = get_max_id(sqlite_connection)
                for key, value in d.items():
                    max_id += 1
                    temporary_list.append(
                        (max_id,
                         key,
                         str(value["breakfast"]),
                         str(value["lunch"]),
                         str(value["dinner"]))
                    )
                return tuple(temporary_list)

            # Connecting to the database
            sqlite_connection = sqlite3.connect(database)
            cursor = sqlite_connection.cursor()
            logging.info("Successfully connected to database, started uploading data to DB")

            # Inserting parsed data to FoodMenu
            #
            logging.info("Inserting information to FoodMenu")
            # Creating data records from FoodMenu record (EventRecord)
            cursor.executemany(SQL_INSERT_STATEMENT, cast_to_tuple(data))

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


def is_time24_format(time_str) -> str:
    """
    :param time_str: Possible string to check if it satisfies 24h time format.
    :return: True if time_str satisfies format HH:mm else False
    """
    if not re.match(r'^([01]\d|2[0-3]):([0-5]\d)$', time_str):
        raise argparse.ArgumentTypeError(f"Invalid time format: '{time_str}'. Expected format: HH:mm (24-hour).")
    return time_str


def time_remaining(task):
    """
    :param task: Current task from scheduled ones
    :return: Time until task will be executed
    """
    next_run = task.next_run
    now = datetime.now()
    time_diff = next_run - now
    return time_diff


def update() -> None:
    logging.info("Started parsing")
    content = parse_content()
    logging.info("Parsing finished, writing to database started")
    write_data_to_database(content, database_filename)
    logging.info("Writing to database finished")


def setup() -> None:
    # global database_filename
    # Logging settings
    logging.basicConfig(filename=f'food_parsing_launch_{datetime.now()}', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
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
    #
    # # Set up database file
    # database_filename = args.database
    #
    # # Passing user times to schedule if there are any
    # schedule_logging_message = list()
    # if len(args.times) > 0:
    #     # Custom parsing time
    #     for t in args.times:
    #         schedule.every().day.at(t).do(update)
    #         schedule_logging_message += t + " "
    # else:
    #     # Default time
    #     schedule.every().day.at("00:00").do(update)
    #     schedule.every().day.at("12:00").do(update)
    #     schedule_logging_message.append("00.00")
    #     schedule_logging_message.append("12.00")
    #
    # # Logging setup information
    # logging.info(f"Successfully scheduled parsing processes at {schedule_logging_message} every day")

#
# def check_if_update() -> None:
#     # Getting information about scheduled tasks
#     job = schedule.get_jobs()[0]
#     remaining_time = time_remaining(job)
#
#     # Printing information about current scheduled task.
#     print(f"[T] Time remaining until the next complete sport parsing: {remaining_time}")
#     print("\033[F", end='')  # Move cursor up one line
#     print("\033[K", end='')  # Clear the line
#
#     # Checking if there is a task to run
#     schedule.run_pending()


if __name__ == "__main__":
    setup()
    update()
    # while True:
    #     check_if_update()
    #     time.sleep(60)  # Waiting until the next check
