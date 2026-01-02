//
//  main.swift
//  intuous
//
//  Created by khang on 22/2/23.
//

import Cocoa
import Foundation

let eventSource = CGEventSource(stateID: .hidSystemState)

final class Press {
    let keycode: KeyCode
    let flags: CGEventFlags

    init(_ keycode: KeyCode, _ flags: CGEventFlags) {
        self.keycode = keycode
        self.flags = flags
    }

    private func event(down: Bool) -> CGEvent {
        let ev = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: keycode.rawValue,
            keyDown: down)!
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
    Press(.e, [.maskCommand, .maskAlternate]) // Eraser
]

let d = UserDefaults.standard
let i = d.integer(forKey: "tool")

var tbl: [Press]

// tbl = notability
// tbl = goodNotes
tbl = onenote

tbl[i].press()
d.setValue(i >= tbl.count - 1 || i < 0 ? 0 : i + 1, forKey: "tool")

usleep(5000)
