def read_file(f):
    with open(f) as f:
        return f.read()


def write_file(f, buffer: str):
    with open(f, "w") as f:
        f.write(buffer)


def load(buf: str, h0: dict[str, str], h1: dict[str, str]):
    for k, v in h0.items():
        buf = buf.replace(v, h1[k])
    return buf


gruvbox = {
    "bg0": "#282828",
    "bg1": "#3c3836",
    "bg2": "#504945",
    "bg3": "#665c54",
    "bg4": "#7c6f64",
    "fg0": "#fbf1c7",
    "fg1": "#ebdbb2",
    "fg2": "#d5c4a1",
    "fg3": "#bdae93",
    "fg4": "#a89984",
    "red": "#fb4934",
    "green": "#b8bb26",
    "yellow": "#fabd2f",
    "blue": "#83a598",
    "purple": "#d3869b",
    "aqua": "#8ec07c",
    "orange": "#fe8019",
    "gray": "#928374",
}


material = {
    "bg0": "#282828",
    "bg1": "#3c3836",
    "bg2": "#504945",
    "bg3": "#665c54",
    "bg4": "#7c6f64",
    "fg0": "#fbf1c7",
    "fg1": "#ebdbb2",
    "fg2": "#d5c4a1",
    "fg3": "#bdae93",
    "fg4": "#a89984",
    "red": "#ea6962",
    "green": "#a9b665",
    "yellow": "#d8a657",
    "blue": "#7daea3",
    "purple": "#d3869b",
    "aqua": "#89b48c",
    "orange": "#e78a4e",
    "gray": "#928374",
}

nord = {
    "bg0": "#282828",
    "bg1": "#3c3836",
    "bg2": "#504945",
    "bg3": "#665c54",
    "bg4": "#7c6f64",
    "fg0": "#fbf1c7",
    "fg1": "#ebdbb2",
    "fg2": "#d5c4a1",
    "fg3": "#bdae93",
    "fg4": "#a89984",
    "red": "#BF616A",
    "green": "#A3BE8C",
    "yellow": "#EBCB8B",
    "blue": "#81A1C1",
    "purple": "#B48EAD",
    "aqua": "#8FBCBB",
    "orange": "#D08770",
    "gray": "#928374",
}

SRC_FILE = "gruvbox.vim.bak"
OUT_FILE = "gruvbox8.vim"

buf = read_file(SRC_FILE)
buf = load(buf, gruvbox, material)

write_file(OUT_FILE, buf)
