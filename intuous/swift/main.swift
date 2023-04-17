//
//  main.swift
//  intuous
//
//  Created by khang on 22/2/23.
//

import Cocoa
import Foundation

let s = CGEventSource(stateID: .hidSystemState)

final class Press {
    let keycode: KeyCode, flags: CGEventFlags
    init(_ keycode: KeyCode, _ flags: CGEventFlags) { self.keycode = keycode; self.flags = flags }

    private func event(down: Bool) -> CGEvent {
        let ev = CGEvent(keyboardEventSource: s, virtualKey: keycode.rawValue, keyDown: down)!
        ev.flags = self.flags
        return ev
    }

    func press() {
        self.event(down: true).post(tap: .cghidEventTap)
        self.event(down: false).post(tap: .cghidEventTap)
    }
}

let hyper: CGEventFlags = [.maskCommand, .maskShift, .maskAlternate, .maskControl]

let goodNotes = [
    Press(.p, []), // Pen
    Press(.e, []) // Eraser
]

let notability = [
    Press(.p, hyper), // Pen
    Press(.e, hyper) // Eraser
]

let onenote = [
    Press(.p, [.maskCommand, .maskShift]), // Pen
    Press(.e, [.maskAlternate, .maskCommand]) // Eraser
]

let d = UserDefaults.standard
let i = d.integer(forKey: "tool")

let tbl = goodNotes

tbl[i].press()
d.setValue(i >= tbl.count - 1 || i < 0 ? 0 : i + 1, forKey: "tool")

usleep(5000)
