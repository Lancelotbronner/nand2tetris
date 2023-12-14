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
    ],
	dependencies: [
		.package(name: "swift-nand2tetris", path: "../CoreNand2Tetris"),
	],
    targets: [
        .target(
            name: "Nand2TetrisKit",
			dependencies: [
				.product(name: "Nand2Tetris", package: "swift-nand2tetris"),
			],
			path: "Sources"),
    ]
)
