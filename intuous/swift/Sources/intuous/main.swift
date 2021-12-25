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

let tool_file = getCacheDir().appendingPathComponent("intuous-cache").appendingPathComponent("tool")

let tools = [
    KeyPress.p, // Pen
    KeyPress.e // Eraser
]

let a = readToolIndex(toolFile: tool_file)
press(tools[a])
writeToolIndex(toolFile: tool_file, current: a, size: tools.count)
usleep(10_000)
