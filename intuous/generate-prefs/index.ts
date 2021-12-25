import fs from 'fs'
import { join } from 'path'
import convert from 'xml-js'
import { RootNode } from './types'
import { getAreaElements } from './area'
import { rect, Rect } from './rect'
import { rmf, apply, hasElement, mkdir } from './util'

const ROOT_DIR = join(__dirname, '..')
const PRESET_DIR = join(ROOT_DIR, 'presets')
const TARGET_DIR = join(ROOT_DIR, 'dots.wacomprefs')
const XML_TARGET = join(TARGET_DIR, 'com.wacom.wacomtablet.prefs')
const XML_STABLE = join(TARGET_DIR, '.stable', 'com.wacom.wacomtablet.prefs')

mkdir(PRESET_DIR)

const stableXml = fs.readFileSync(XML_STABLE, 'utf8')
console.log(XML_STABLE)
const stableJs = convert.xml2js(stableXml) as RootNode
const preset = (p: string) => join(PRESET_DIR, p + '.prefs')

function buildPreset(name: string, rect: Rect) {
  for (let i = 0; i < stableJs.elements.length; i++) {
    apply(
      stableJs.elements[i],
      (n) =>
        n.type === 'element' &&
        n.name === 'ScreenArea' &&
        hasElement(n, 'AreaType', '1'),
      (n) =>
        apply(
          n,
          (n) => n.type === 'element' && n.name === 'ScreenOutputArea',
          (n) =>
            n.type === 'element' &&
            (n.elements = getAreaElements(rect.export()))
        )
    )
  }
  rmf(preset(name))
  fs.writeFileSync(preset(name), convert.js2xml(stableJs))
  console.log(`Preset: [${name}]\n`, rect.export(), '\n')
}

rect.setHorizontalMargin(0)
buildPreset('full', rect)

fs.copyFileSync(preset('full'), XML_TARGET)
