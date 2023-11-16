# pyright: reportMissingImports=false

import datetime
from kitty.fast_data_types import get_options
from kitty.tab_bar import as_rgb, draw_tab_with_separator
from kitty.utils import color_as_int

OPTS = get_options()
CLOCK_FG = as_rgb(color_as_int(OPTS.color3))
DATE_FG = as_rgb(color_as_int(OPTS.color5))


def _draw_right_status(screen, is_last):
    if not is_last:
        return screen.cursor.x

    cells = [
        (DATE_FG, 0, datetime.datetime.now().strftime(" %d %b ")),
        (CLOCK_FG, 0, datetime.datetime.now().strftime(" %H:%M  ")),
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


def draw_tab(dd, sc, tab, b, mtl, idx, il, exd):
    end = draw_tab_with_separator(dd, sc, tab, b, mtl, idx, il, exd)
    _draw_right_status(sc, il)
    return end
