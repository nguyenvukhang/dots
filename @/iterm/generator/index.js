const { writeFileSync } = require('fs')
const { build } = require('./prelude')

const colors = [
  '#7c6f64',
  '#ea6962',
  '#a9b665',
  '#d8a657',
  '#7daea3',
  '#d3869b',
  '#89b48c',
  '#ebdbb2',
]

const colorscheme = {
  Ansi_0_Color: colors[0],
  Ansi_1_Color: colors[1],
  Ansi_2_Color: colors[2],
  Ansi_3_Color: colors[3],
  Ansi_4_Color: colors[4],
  Ansi_5_Color: colors[5],
  Ansi_6_Color: colors[6],
  Ansi_7_Color: colors[7],
  Ansi_8_Color: colors[0],
  Ansi_9_Color: colors[1],
  Ansi_10_Color: colors[2],
  Ansi_11_Color: colors[3],
  Ansi_12_Color: colors[4],
  Ansi_13_Color: colors[5],
  Ansi_14_Color: colors[6],
  Ansi_15_Color: colors[7],

  Background_Color: '#282828',
  Foreground_Color: '#ebdbb2',

  Cursor_Color: '#d5c4a1',
  Cursor_Text_Color: '#282828',
  Link_Color: '#e78a4e',

  Selected_Text_Color: '#504945',
  Selection_Color: '#ebdbb2',

  Bold_Color: '#000000',
  Badge_Color: '#000000',
  Cursor_Guide_Color: '#000000',
}

writeFileSync('gruvbox-material.itermcolors', build(colorscheme))
