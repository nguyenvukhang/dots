const { readFileSync, writeFileSync } = require("fs");
const Color = require("color");

const colorscheme = {
  Ansi_0_Color: "#7c6f64",
  Ansi_1_Color: "#ea6962",
  Ansi_2_Color: "#a9b665",
  Ansi_3_Color: "#d8a657",
  Ansi_4_Color: "#7daea3",
  Ansi_5_Color: "#d3869b",
  Ansi_6_Color: "#89b48c",
  Ansi_7_Color: "#ebdbb2",
  Ansi_8_Color: "#7c6f64",
  Ansi_9_Color: "#ea6962",
  Ansi_10_Color: "#a9b665",
  Ansi_11_Color: "#d8a657",
  Ansi_12_Color: "#7daea3",
  Ansi_13_Color: "#d3869b",
  Ansi_14_Color: "#89b48c",
  Ansi_15_Color: "#ebdbb2",

  Background_Color: "#282828",
  Foreground_Color: "#ebdbb2",

  Cursor_Color: "#d5c4a1",
  Cursor_Text_Color: "#282828",
  Link_Color: "#e78a4e",

  Selected_Text_Color: "#504945",
  Selection_Color: "#ebdbb2",

  Bold_Color: "#000000",
  Badge_Color: "#000000",
  Cursor_Guide_Color: "#000000",
};

function color(name, hexCode) {
  name = name.replace(/_/g, " ");
  const color = Color(hexCode);
  return `<key>${name}</key><dict>
		<key>Color Space</key><string>sRGB</string>
		<key>Alpha Component</key><real>1</real>
		<key>Red Component</key><real>${color.red() / 255}</real>
		<key>Green Component</key><real>${color.green() / 255}</real>
		<key>Blue Component</key><real>${color.blue() / 255}</real>
	</dict>`;
}

let lines = [];

lines.push(`
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
`);

Object.entries(colorscheme).forEach(([name, hexCode]) => {
  lines.push(color(name, hexCode));
});
lines.push(color("ggj"));

lines.push("</dict></plist>");

writeFileSync("export.itermcolors", lines.join("\n"));
