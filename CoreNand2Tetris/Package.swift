// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nand2Tetris",
	platforms: [
		.macOS(.v14),
	],
    products: [
        .library(name: "Nand2Tetris", targets: ["Nand2Tetris"]),
		.library(name: "XCTNand2Tetris", targets: ["XCTNand2Tetris"]),
    ],
    targets: [
        .target(
            name: "Nand2Tetris",
			path: "Sources"),

		.target(
			name: "XCTNand2Tetris",
			dependencies: ["Nand2Tetris"],
			path: "Tests/XCTNand2Tetris"),

        .testTarget(
            name: "Nand2TetrisTests",
			dependencies: ["Nand2Tetris", "XCTNand2Tetris"],
			path: "Tests/Nand2Tetris"),
    ]
)
