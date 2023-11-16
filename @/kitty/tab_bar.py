# pyright: reportMissingImports=false

import datetime, json
from kitty.fast_data_types import get_options
from kitty.tab_bar import as_rgb, draw_tab_with_separator
from kitty.utils import color_as_int

OPTS = get_options()
CLOCK_FG = as_rgb(color_as_int(OPTS.color3))
DATE_FG = as_rgb(color_as_int(OPTS.color5))
BDAE_FG = as_rgb(color_as_int(OPTS.color2))
NOW = datetime.datetime.now()


def birthday():
    from os import environ, path

    with open(path.join(environ["DOTS"], "personal/birthdays/db.json"), "r") as f:
        p = json.load(f).get(NOW.strftime("%d-%b"), None)
        # return 
        # return str(j)
        # return str(p)
        return "↑" if not p else f"{', '.join(p)} lvl up ↑"


def _draw_right_status(screen):
    cells = [
        (BDAE_FG, 0, birthday()),
        (DATE_FG, 0, NOW.strftime("  %d %b ")),
        (CLOCK_FG, 0, NOW.strftime(" %H:%M  ")),
    ]

    right_status_length = sum([len(x) for _, _, x in cells])
    draw_spaces = screen.columns - screen.cursor.x - right_status_length

    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)

    for fg, bg, cell in cells:
        screen.cursor.fg, screen.cursor.bg = fg, bg
        screen.draw(cell)

    screen.cursor.fg, screen.cursor.bg = 0, 0
    screen.cursor.x = max(screen.cursor.x, screen.columns - right_status_length)
    return screen.cursor.x


def draw_tab(dd, sc, tab, b, mtl, idx, is_last, exd):
    if is_last:
        _draw_right_status(sc)
        return sc.cursor.x
    else:
        return draw_tab_with_separator(dd, sc, tab, b, mtl, idx, is_last, exd)
