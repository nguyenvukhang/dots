//
//  utils.swift
//  intuous
//
//  Created by khang on 22/2/23.
//

import Foundation

func getCacheDir() -> URL {
    if let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
        return dir
    }
    exit(1)
}

func readToolIndex(toolFile: URL) -> Int {
    do {
        return Int(try String(contentsOf: toolFile, encoding: .utf8)) ?? 0
    } catch {
        return 0
    }
}

func writeToolIndex(toolFile: URL, current: Int, size: Int) {
    let parentURL = toolFile.deletingLastPathComponent()
    let next = current >= size - 1 || current < 0 ? 0 : current + 1

    var isDir: ObjCBool = true
    if !FileManager.default.fileExists(atPath: parentURL.path, isDirectory: &isDir) {
        do {
            print("Creating create cache directory")
            try FileManager.default.createDirectory(at: parentURL, withIntermediateDirectories: false)
        } catch {
            print("Unable to create cache directory", parentURL)
            exit(1)
        }
    }

    do {
        try String(next).write(to: toolFile, atomically: true, encoding: .utf8)
    } catch {
        print("Unable to write to tools cache")
        exit(1)
    }
}
