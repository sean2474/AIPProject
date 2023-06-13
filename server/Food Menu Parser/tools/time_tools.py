from datetime import datetime
from typing import Tuple


def get_current_date() -> Tuple[str, str, str]:
    now = datetime.now()
    return now.strftime("%Y"), now.strftime("%m"), now.strftime("%d")
