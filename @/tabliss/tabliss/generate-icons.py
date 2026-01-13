import json, sys
from os import path
from tabliss.paths import *

cwd = path.dirname(__file__)

with open(ICONS_JSON_PATH, "r") as f:
    data = json.load(f)

icon_paths = [str(x["path"]) for x in data["entries"]]

with open(path.join(cwd, "icons.py"), "w") as sys.stdout:
    print("from typing import Literal")
    print("Icon = Literal[")
    for ip in icon_paths:
        print('"%s",' % ip.removeprefix("icons/").removesuffix(".svg"))
    print("]")
