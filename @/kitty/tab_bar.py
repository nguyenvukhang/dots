"""draw kitty tab"""
# pyright: reportMissingImports=false
# pylint: disable=E0401,C0116,C0103,W0603,R0913

import datetime, json, os

from kitty.fast_data_types import get_options
from kitty.tab_bar import as_rgb, draw_title
from kitty.utils import color_as_int

OPTS = get_options()
CLOCK_FG = as_rgb(color_as_int(OPTS.color3))
DATE_FG = as_rgb(color_as_int(OPTS.color5))
BDAE_FG = as_rgb(color_as_int(OPTS.color2))
NOW = datetime.datetime.now()


def birthday(filepath="/Users/khang/dots/personal/birthdays/db.json"):
    if not os.path.isfile(filepath):
        return None

    with open(filepath, "r") as f:
        p = json.load(f).get(NOW.strftime("%d-%b"), None)
        return "↑" if not p else f"{', '.join(p)} lvl up ↑"


def _draw_left_status(dd, sc, tab, before, mtl, index, is_last):
    if dd.leading_spaces:
        sc.draw(" " * dd.leading_spaces)

    # draw tab title
    draw_title(dd, sc, tab, index)

    trailing_spaces = min(mtl - 1, dd.trailing_spaces)
    mtl -= trailing_spaces
    extra = sc.cursor.x - before - mtl
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


def _draw_right_status(sc, is_last):
    if not is_last:
        return sc.cursor.x

    b = birthday()
    cells = [
        (BDAE_FG, 0, b if b else "x"),
        (DATE_FG, 0, NOW.strftime("  %d %b ")),
        (CLOCK_FG, 0, NOW.strftime(" %H:%M  ")),
    ]

    right_status_length = 0
    for _, _, cell in cells:
        right_status_length += len(cell)

    draw_spaces = sc.columns - sc.cursor.x - right_status_length
    if draw_spaces > 0:
        sc.draw(" " * draw_spaces)

    for fg, bg, cell in cells:
        sc.cursor.fg = fg
        sc.cursor.bg = bg
        sc.draw(cell)
    sc.cursor.fg = 0
    sc.cursor.bg = 0

    sc.cursor.x = max(sc.cursor.x, sc.columns - right_status_length)
    return sc.cursor.x


def draw_tab(dd, sc, tab, before, mtl, index, is_last, _):
    end = _draw_left_status(dd, sc, tab, before, mtl, index, is_last)
    _draw_right_status(sc, is_last)
    return end
