import argparse
import logging
import re
import sqlite3
from datetime import datetime
from typing import Tuple, Dict, Any


from FoodMenuEntries import FoodMenuEntries

SQL_INSERT_QUERY = "INSERT INTO FoodMenu (id, date, breakfast, lunch, dinner) VALUES (?, ?, ?, ?, ?)"
SQL_DELETE_QUERY = "DELETE FROM FoodMenu"
database_filename = "../database.db"


def get_current_date() -> Tuple[str, str, str]:
    now = datetime.now()
    return now.strftime("%Y"), now.strftime("%m"), now.strftime("%d")


def parse_content() -> Dict[Any, Dict[Any, Any]]:
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
            logging.info("Successfully connected to database")

            logging.info("Started clearing the contents of FoodMenu table")
            cursor.execute(SQL_DELETE_QUERY)
            logging.info("Cleared the contents of FoodMenu table")

            # Inserting parsed data to FoodMenu
            #
            logging.info("Inserting new data to FoodMenu")
            # Creating data records from FoodMenu record (EventRecord)
            cursor.executemany(SQL_INSERT_QUERY, cast_to_tuple(data))

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
    logging.basicConfig(filename=f'food_parsing_launch_{datetime.now()}', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


if __name__ == "__main__":
    setup()
    update()
