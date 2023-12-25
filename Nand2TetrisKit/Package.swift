// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nand2TetrisCompanionKit",
	platforms: [
		.macOS(.v14),
	],
    products: [
        .library(name: "Nand2TetrisCompanionKit", targets: ["Nand2TetrisCompanionKit"]),
    ],
	dependencies: [
		.package(name: "swift-nand2tetris", path: "../CoreNand2Tetris"),
	],
    targets: [
        .target(
            name: "Nand2TetrisCompanionKit",
			dependencies: [
				.product(name: "Nand2TetrisKit", package: "swift-nand2tetris"),
			],
			path: "Sources"),
    ]
)
