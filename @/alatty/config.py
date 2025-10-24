from dataclasses import dataclass


def print_config(obj, attrs: list[str]):
    for attr in attrs:
        val = getattr(obj, attr)
        if val is not None:
            if type(val) == list:
                for val in val:
                    print(f"{attr} {val}")
            else:
                print(f"{attr} {val}")


@dataclass
class Style:
    background_opacity: float
    background_blur: int | None
    hide_window_decorations: str | None

    def print(self):
        attrs = ["background_opacity", "background_blur", "hide_window_decorations"]
        print_config(self, attrs)


class Font:
    font_family: str
    font_size: float
    modify_font: list[str] | None
    symbol_map: list[str] | None

    def __init__(
        self,
        f: tuple[str, float],
        modify_font: list[str] | None,
        symbol_map: list[str] | None,
    ) -> None:
        self.font_family = f[0]
        self.font_size = f[1]
        self.modify_font = modify_font
        self.symbol_map = symbol_map

    def print(self):
        attrs = ["font_family", "font_size", "modify_font", "symbol_map"]
        print_config(self, attrs)


# Map CMD to ALT by brute force.
for x in map(chr, range(97, 123)):
    print(f"map cmd+shift+{x} send_text all \\x1b{x}")
    print(f"map cmd+{x} send_text all \\x1b{x}")


# Styling background + titlebar on macOS.
styles = (
    Style(0.94, 6, "titlebar-only"),
    Style(0.94, 6, None),
    Style(1, None, None),
)
styles[1].print()

# print("modify_font cell_width 100%")
# print("modify_font cell_height +0px")

fonts = (
    # macos Stuff
    Font(
        ("JetBrains Mono NL", 14),
        ["cell_width 95%"],
        ["U+1D4DD JuliaMono"],
    ),
    Font(
        ("Cascadia Mono", 15),
        ["cell_height +2px"],
        ["U+1D4DD JuliaMono"],
    ),
    Font(
        ("CommitMono", 14),
        None,
        ["U+1D4DD JuliaMono"],
    ),
    Font(
        ("Monaco", 14),
        None,
        ["U+1D4DD JuliaMono"],
    ),
    Font(
        ("SF Mono Regular", 14),
        None,
        ["U+1D4DD JuliaMono"],
    ),
    Font(
        ("JetBrains Mono NL Light", 11),
        [],
        # ["cell_width 110%"],
        ["U+1D4DD JuliaMono"],
    ),
    Font(
        ("CommitMono Regular", 11),
        [],
        # ["cell_width 110%"],
        ["U+1D4DD JuliaMono"],
    ),
)
x = False
# fonts[0 if x else -1].print()
