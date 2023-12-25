// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nand2TetrisKit",
	platforms: [
		.macOS(.v14),
	],
    products: [
        .library(name: "Nand2TetrisKit", targets: ["Nand2TetrisKit"]),
		.library(name: "XCTNand2Tetris", targets: ["XCTNand2Tetris"]),
    ],
    targets: [
        .target(
            name: "Nand2TetrisKit",
			path: "Sources"),

		.target(
			name: "XCTNand2Tetris",
			dependencies: ["Nand2TetrisKit"],
			path: "Tests/XCTNand2Tetris"),

        .testTarget(
            name: "Nand2TetrisTests",
			dependencies: ["Nand2TetrisKit", "XCTNand2Tetris"],
			path: "Tests/Nand2Tetris"),
    ]
)
