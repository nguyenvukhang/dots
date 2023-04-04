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
    CGEvent(keyboardEventSource: s, virtualKey: v, keyDown: true)!.post(tap: .cghidEventTap)
    CGEvent(keyboardEventSource: s, virtualKey: v, keyDown: false)!.post(tap: .cghidEventTap)
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
