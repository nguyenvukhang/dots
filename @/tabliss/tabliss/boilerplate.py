from tabliss.icons import Icon

TIMEZONE = "Asia/Taipei"
STATIC_IDS = [
    "f2FvggOlNUkW",
    "Fxv4UDBjRZZo",
    "aOabLvrJi2gA",
    "e6mxGgmywUsk",
    "G6G0bZQ1JZ45",
    "puii2xZGkjLf",
    "eYSyIW1TOGgs",
    "rg6w14FQHOmh",
]


def google_sheet(spreadsheet_id: str) -> str:
    return f"https://docs.google.com/spreadsheets/d/{spreadsheet_id}"


class StaticIds:
    def __init__(self) -> None:
        self.idx = 0

    def get(self) -> tuple[str, int]:
        if self.idx < len(STATIC_IDS):
            result = STATIC_IDS[self.idx]
            self.idx += 1
            return result, self.idx
        raise Exception("Ran out of static IDs.")

    def order(self, static_id: str) -> int:
        return STATIC_IDS.index(static_id)


class Config:
    def __init__(self, fg: str, bg: str, fg_dim: str) -> None:
        self.ids = StaticIds()
        self.tree = {
            "version": 3,
            "timeZone": TIMEZONE,
            "focus": False,
            "widget/default-greeting": None,
            "locale": "en",
            # Background Config
            "background": {
                "id": "IAoLHIrMU3E7",
                "key": "background/colour",
                "display": {"blur": 0},
            },
            "data/IAoLHIrMU3E7": {"colour": bg},
            # Time Config
            "widget/default-time": {
                "id": "default-time",
                "key": "widget/time",
                "order": 0,
                "display": {
                    "position": "middleCentre",
                    "fontSize": 32,
                    "fontWeight": 100,
                    "colour": fg,
                },
            },
            "data/default-time": {
                "timeZone": TIMEZONE,
                "mode": "digital",
                "hour12": False,
                "showDate": False,
                "showMinutes": True,
                "showSeconds": False,
                "showDayPeriod": True,
                "name": "",
            },
        }
        self.last_inserted_id: str | None = None
        self.fg_dim = fg_dim

    def new_row(self):
        widget_id, order = self.ids.get()
        self.tree[f"data/{widget_id}"] = {
            "columns": 0,
            "links": [],
            "visible": True,
            "linkOpenStyle": False,
        }
        self.tree[f"widget/{widget_id}"] = {
            "id": widget_id,
            "key": "widget/links",
            "order": order,
            "display": {
                "position": "middleCentre",
                "fontSize": 22,
                "fontWeight": 300,
                "colour": self.fg_dim,
            },
        }
        self.last_inserted_id = widget_id

    def link(self, name: str, url: str, icon: Icon):
        if self.last_inserted_id is None:
            raise Exception("Last inserted widget ID is None. Failing.")
        widget_id = self.last_inserted_id

        data = self.tree[f"data/{widget_id}"]
        data["links"].append({"url": url, "name": name, "icon": icon})
        data["columns"] = len(data["links"])

    def save(self, path: str):
        with open(path, "w") as f:
            import json

            json.dump(self.tree, f, indent=4)
