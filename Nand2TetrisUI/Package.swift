// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "Nand2TetrisUI",
	platforms: [
		.macOS(.v15),
		.iOS(.v18),
	],
	products: [
		.library(name: "Nand2TetrisUI", targets: [
			"Nand2TetrisUI",
			"AssemblerScene", "EmulatorScene", "VirtualMachineScene",
		]),
	],
	dependencies: [
		.package(name: "swift-nand2tetris", path: "../Nand2TetrisKit"),
	],
	targets: [
			.target(name: "Nand2TetrisUI", dependencies: [
				.product(name: "Nand2TetrisKit", package: "swift-nand2tetris"),
			]),

			.target(name: "AssemblerScene", dependencies: ["Nand2TetrisUI"]),
			.target(name: "EmulatorScene", dependencies: ["Nand2TetrisUI"]),
			.target(name: "VirtualMachineScene", dependencies: ["Nand2TetrisUI"]),
	]
)
