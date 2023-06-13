from FormatChanger import FormatChanger
from FoodMenuParser import FoodMenuParser
from DatabaseFoodMenuWriter import DatabaseFoodMenuWriter

from tools.logging_tools import setup_logging


def update():
    food_menu_parser = FoodMenuParser()
    gathered_data = food_menu_parser.get_data()

    format_changer = FormatChanger(gathered_data)
    content_to_write_to_db = format_changer.get_output()
    print(content_to_write_to_db)

    with DatabaseFoodMenuWriter(database_file="../database.db") as database_food_menu_writer:
        database_food_menu_writer.execute_food_menu_data_writing(content_to_write_to_db)


def setup():
    setup_logging("food_menu_parsing.log")


if __name__ == "__main__":
    setup()
    update()
