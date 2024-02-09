const Color = require('color')

const DOC_START = `
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
`
const DOC_END = '</dict>\n</plist>'

function color(name, hexCode) {
  name = name.replace(/_/g, ' ')
  const color = Color(hexCode)
  return `
  <key>${name}</key>
  <dict>
		<key>Color Space</key><string>sRGB</string>
		<key>Alpha Component</key><real>1</real>
		<key>Red Component</key><real>${color.red() / 255}</real>
		<key>Green Component</key><real>${color.green() / 255}</real>
		<key>Blue Component</key><real>${color.blue() / 255}</real>
	</dict>`.trim()
}

module.exports = {
  build: (colorscheme) => {
    let lines = [DOC_START.trim()]
    Object.entries(colorscheme).forEach(([n, hex]) => lines.push(color(n, hex)))
    lines.push(DOC_END.trim())
    return lines.join('\n')
  },
}
