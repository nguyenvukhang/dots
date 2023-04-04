//
//  main.swift
//  intuous
//
//  Created by khang on 22/2/23.
//

import Cocoa
import Foundation

let src = CGEventSource(stateID: .hidSystemState)

func press(_ key: KeyCode, withModifiers modifiers: CGEventFlags = .init()) {
    let down = CGEvent(keyboardEventSource: src, virtualKey: key.rawValue, keyDown: true)!
    let up = CGEvent(keyboardEventSource: src, virtualKey: key.rawValue, keyDown: false)!

    down.flags = modifiers
    up.flags = modifiers
    down.post(tap: .cghidEventTap)
    up.post(tap: .cghidEventTap)
}

func press(_ key: KeyPress) {
    press(key.key, withModifiers: key.modifiers)
}

let tools = [
    KeyPress.p, // Pen
    KeyPress.e // Eraser
]

let d = UserDefaults.standard, t = tools.count
let key = "wacom-tablet-cycle-tool"

let a = d.integer(forKey: key)
press(tools[a])
d.setValue((a == 0 ? t : a) - 1, forKey: key)
usleep(5000)
