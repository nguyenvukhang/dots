def read_file(f):
    with open(f) as f:
        return f.read()


def write_file(f, buffer):
    with open(f, "w") as f:
        f.write(buffer)


def load(buf, prev, next):
    for k, v in prev.items():
        buf = buf.replace(v, next[k])
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


SRC_FILE = "gruvbox.vim.bak"
OUT_FILE = "gruvbox8.vim"

buf = read_file(SRC_FILE)
buf = load(buf, gruvbox, material)

write_file(OUT_FILE, buf)
