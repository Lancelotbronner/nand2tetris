// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "nand2tetris",
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
	],
    targets: [
		.executableTarget(
			name: "nand2tetris",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
			],
			path: "Sources")
    ]
)
