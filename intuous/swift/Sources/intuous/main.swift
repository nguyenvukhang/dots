//
//  main.swift
//  intuous
//
//  Created by khang on 22/2/23.
//

import Cocoa
import Foundation

func press(_ key: KeyCode) {
    let v = key.rawValue, s = CGEventSource(stateID: .hidSystemState)

    let down = CGEvent(keyboardEventSource: s, virtualKey: v, keyDown: true)!
    down.flags = [.maskCommand, .maskShift, .maskControl, .maskAlternate]
    down.post(tap: .cghidEventTap)

    let up = CGEvent(keyboardEventSource: s, virtualKey: v, keyDown: true)!
    up.flags = [.maskCommand, .maskShift, .maskControl, .maskAlternate]
    up.post(tap: .cghidEventTap)
}

let tools = [
    KeyCode.p, // Pen
    KeyCode.e // Eraser
]

let d = UserDefaults.standard
let app = "wacom-tablet-cycle-tool"
let i = d.integer(forKey: app)

press(tools[i])
d.setValue(i >= tools.count - 1 || i < 0 ? 0 : i + 1, forKey: app)
usleep(5000)
