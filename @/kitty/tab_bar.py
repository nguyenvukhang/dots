# pyright: reportMissingImports=false

import datetime, json, os
from kitty.fast_data_types import get_options
from kitty.tab_bar import as_rgb, draw_title
from kitty.utils import color_as_int

OPTS = get_options()
CLOCK_FG = as_rgb(color_as_int(OPTS.color3))
DATE_FG = as_rgb(color_as_int(OPTS.color5))
BDAE_FG = as_rgb(color_as_int(OPTS.color2))
NOW = lambda: datetime.datetime.now()

BIRTHDAY_FILE = "/Users/khang/dots/personal/birthdays/db.json"
BIRTHDAYS = {}
if os.path.isfile(BIRTHDAY_FILE):
    with open(BIRTHDAY_FILE, "r") as f:
        BIRTHDAYS = json.load(f)
FIXED_TAB_NAMES = ("editor", "server")


def birthday():
    p = BIRTHDAYS.get(NOW().strftime("%d-%b"), None)
    return "↑" if not p else f"{', '.join(p)} lvl up ↑"


def _draw_left_status(dd, sc, tab, before, mtl, index, is_last):
    if 1 <= index and index <= len(FIXED_TAB_NAMES):
        tab = tab._replace(title=FIXED_TAB_NAMES[index - 1])

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

    now, b = NOW(), birthday()
    cells = [
        (BDAE_FG, 0, b if b else "x"),
        (DATE_FG, 0, now.strftime("  %d %b ")),
        (CLOCK_FG, 0, now.strftime(" %H:%M  ")),
    ]

    rlen = sum([len(c) for _, _, c in cells])
    s = sc.columns - sc.cursor.x - rlen
    if s > 0:
        sc.draw(" " * s)

    for fg, bg, cell in cells:
        sc.cursor.fg, sc.cursor.bg = fg, bg
        sc.draw(cell)
    sc.cursor.fg, sc.cursor.bg = 0, 0
    sc.cursor.x = max(sc.cursor.x, sc.columns - rlen)
    return sc.cursor.x


def draw_tab(dd, sc, tab, before, mtl, index, is_last, _):
    end = _draw_left_status(dd, sc, tab, before, mtl, index, is_last)
    _draw_right_status(sc, is_last)
    return end
