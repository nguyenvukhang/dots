import { ColorScheme } from "./types";

// bg0_h = "#1d2021"
// bg1   = "#3c3836"
// bg2   = "#504945"
// bg3   = "#665c54"
// bg4   = "#7c6f64"
//
// bg0_s = "#32302f"
// fg4   = "#a89984"
// fg3   = "#bdae93"
// fg2   = "#d5c4a1"
// fg1   = "#ebdbb2"
// fg0   = "#f9f5d7"

const themes: Record<string, ColorScheme> = {};

themes["gruvbox"] = {
  kind: "dark",
  term: ["#282828", "#fb4934", "#b8bb26", "#fabd2f", "#83a598", "#d3869b", "#8ec07c", "#ebdbb2"],
  main: { bg: "#282828", fg: "#ebdbb2" },
  select: { bg: "#ebdbb2", fg: "#504945" },
};
