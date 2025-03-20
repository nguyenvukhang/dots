# pyright: reportMissingImports=false
# pyright: reportCallIssue=false

from datetime import datetime, date
from alatty.fast_data_types import get_options
from alatty.tab_bar import as_rgb, draw_title
from alatty.utils import color_as_int

OPTS = get_options()
NWEEKS_FG = as_rgb(color_as_int(OPTS.color8))
NOW = datetime.now


WEEKS = (
    "W1",
    "W2",
    "W3",
    "W4",
    "W5",
    "W6",
    "RC",
    "W7",
    "W8",
    "W9",
    "W10",
    "W11",
    "W12",
    "W13",
    "RD",
    "E1",
    "E2",
)


def week(now: date):
    WEEK_ZERO_MONDAY = date(2025, 1, 6)
    n = int((now - WEEK_ZERO_MONDAY).days / 7) - 1
    return WEEKS[n] if n < len(WEEKS) else None


def right_cells(now: datetime):
    cells = []
    w = week(now.date())
    if w is not None:
        cells.append((NWEEKS_FG, w + "  "))
    return cells


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

    sc.cursor.fg = 0
    if not is_last:
        sc.cursor.bg = as_rgb(color_as_int(dd.inactive_bg))
        sc.draw(dd.sep)
    sc.cursor.bg = 0
    return sc.cursor.x


def _draw_right_status(sc, is_last):
    if not is_last:
        return sc.cursor.x

    cells = right_cells(NOW())

    rlen = sum([len(c) for _, c in cells])
    s = sc.columns - sc.cursor.x - rlen
    if s > 0:
        sc.draw(" " * s)

    for fg, cell in cells:
        sc.cursor.fg, sc.cursor.bg, _ = fg, 0, sc.draw(cell)
    sc.cursor.fg, sc.cursor.bg, sc.cursor.x = 0, 0, max(sc.cursor.x, sc.columns - rlen)
    return sc.cursor.x


def draw_tab(dd, sc, tab, before, mtl, index, is_last, _):
    end = _draw_left_status(dd, sc, tab, before, mtl, index, is_last)
    _draw_right_status(sc, is_last)
    return end
