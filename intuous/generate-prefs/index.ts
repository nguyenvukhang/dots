import fs from 'fs'
import { join } from 'path'
import convert from 'xml-js'
import { RootNode } from './types'
import { getAreaElements } from './area'
import { rect, Rect } from './rect'
import { rmf, apply, hasElement } from './util'

// $ROOT_DIR
// ├── dots.wacomprefs/
// │  ├── .stable                       <-- base state
// │  ├── com.wacom.wacomtablet.prefs   <-- base state + generated
// │  ├── com.wacom.wacomtouch.prefs
// │  └── version.plist
// └── generate-prefs/
//    └── index.ts

const ROOT_DIR = join(__dirname, '..')
const TARGET_DIR = join(ROOT_DIR, 'dots.wacomprefs')
const XML_TARGET = join(TARGET_DIR, 'com.wacom.wacomtablet.prefs')
const XML_SOURCE = join(TARGET_DIR, '.stable', 'com.wacom.wacomtablet.prefs')

const stableJs = convert.xml2js(fs.readFileSync(XML_SOURCE, 'utf8')) as RootNode

function buildPreset(name: string, rect: Rect): string {
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
  console.log(`build: [${name}]\n`, rect.export(), '\n')
  return convert.js2xml(stableJs)
}

rect.setHorizontalMargin(0)

rmf(XML_TARGET)
fs.writeFileSync(XML_TARGET, buildPreset('full', rect))
