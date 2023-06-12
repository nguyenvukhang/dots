const { readFileSync, writeFileSync } = require("fs");

const INPUT = "gruvbox8.vim";
const OUTPUT = "gruvbox8-mat.vim";

const data = readFileSync(INPUT, "utf8").split("\n");

const from = {
  red: "#fb4934",
  green: "#b8bb26",
  yellow: "#fabd2f",
  blue: "#83a598",
  purple: "#d3869b",
  aqua: "#8ec07c",
  orange: "#fe8019",
  gray: "#928374",
};

const to = {
  red: "#ea6962",
  green: "#a9b665",
  yellow: "#d8a657",
  blue: "#7daea3",
  purple: "#d3869b",
  aqua: "#89b48c",
  orange: "#e78a4e",
  gray: "#928374",
};

const colors = [
  "red",
  "green",
  "yellow",
  "blue",
  "purple",
  "aqua",
  "orange",
  "gray",
];

const converted = data.map((v) => {
  let line = v;
  colors.forEach((c) => {
    line = line.replace(from[c], to[c]);
  });
  return line;
});

writeFileSync(OUTPUT, converted.join("\n"));
