# pyright: reportMissingImports=false

import datetime, json
from alatty.fast_data_types import get_options
from alatty.tab_bar import as_rgb, draw_title
from alatty.utils import color_as_int

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


def _draw_right_status(sc, is_last):
    if not is_last:
        return sc.cursor.x

    cells = [
        (BDAE_FG, 0, birthday()),
        (DATE_FG, 0, NOW.strftime("  %d %b ")),
        (CLOCK_FG, 0, NOW.strftime(" %H:%M  ")),
    ]

    right_status_length = sum([len(x) for _, _, x in cells])
    draw_spaces = sc.columns - sc.cursor.x - right_status_length

    if draw_spaces > 0:
        sc.draw(" " * draw_spaces)

    for fg, bg, cell in cells:
        sc.cursor.fg, sc.cursor.bg = fg, bg
        sc.draw(cell)

    sc.cursor.fg, sc.cursor.bg = 0, 0
    sc.cursor.x = max(sc.cursor.x, sc.columns - right_status_length)
    return sc.cursor.x


def _draw_left_status(dd, sc, tab, b, mtl, idx, is_last) -> int:
    if dd.leading_spaces:
        sc.draw(" " * dd.leading_spaces)

    # draw tab title
    draw_title(dd, sc, tab, idx)

    trailing_spaces = min(max_title_length - 1, dd.trailing_spaces)
    max_title_length -= trailing_spaces
    extra = sc.cursor.x - b - max_title_length
    if extra > 0:
        sc.cursor.x -= extra + 1
        sc.draw("…")
    if trailing_spaces:
        sc.draw(" " * trailing_spaces)

    sc.cursor.bold = sc.cursor.italic = False
    sc.cursor.fg = 0
    if not is_last:
        sc.cursor.bg = as_rgb(color_as_int(dd.inactive_bg))
        sc.draw(dd.sep)
    sc.cursor.bg = 0
    return sc.cursor.x


def draw_tab(dd, sc, tab, b, mtl, idx, is_last, _):
    end = _draw_left_status(dd, sc, tab, b, mtl, idx, is_last)
    _draw_right_status(sc, is_last)
    return end
