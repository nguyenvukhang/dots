// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "intuous",
    targets: [
        .executableTarget(
            name: "intuous",
            path: ".",
            exclude: ["Makefile"])
    ])
