//
//  CompileCommand.swift
//  nand2tetris
//
//  Created by Christophe Bronner on 2024-08-13.
//

import Foundation
import ArgumentParser
import Nand2TetrisKit

struct DecompileCommand: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "decompile",
		abstract: "Decompiles .vm files into .jack source code")

	@Argument(
		help: ArgumentHelp("The vm files to decompile"),
		completion: .file(extensions: ["", "vm"]))
	var input: [String]

	@Option(help: ArgumentHelp("The decompiled output file"))
	var output: String?

	@Flag(help: ArgumentHelp("Whether to be strict with the standard"))
	var pedantic = false

	func run() throws {
		
	}

}
