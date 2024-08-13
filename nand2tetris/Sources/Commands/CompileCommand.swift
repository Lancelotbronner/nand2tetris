//
//  CompileCommand.swift
//  nand2tetris
//
//  Created by Christophe Bronner on 2024-08-13.
//

import Foundation
import ArgumentParser
import Nand2TetrisKit

struct CompileCommand: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "compile",
		abstract: "Compiles .jack files into .vm virtual machine code")

	@Argument(
		help: ArgumentHelp("The jack files to assemble"),
		completion: .file(extensions: ["", "jack"]))
	var input: [String]

	@Option(help: ArgumentHelp("The compiled output file"))
	var output: String?

	@Flag(help: ArgumentHelp("Whether to be strict with the standard"))
	var pedantic = false

	func run() throws {
		
	}

}
