//
//  DisassembleCommand.swift
//  nand2tetris
//
//  Created by Christophe Bronner on 2024-08-13.
//

import Foundation
import ArgumentParser
import Nand2TetrisKit

struct DisassembleCommand: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "disassemble",
		abstract: "Disassembles .hack machine code into readable assembly")

	@Argument(
		help: ArgumentHelp("The hack files to disassemble"),
		completion: .file(extensions: ["", "hack", "txt"]))
	var input: [String]

	@Option(help: ArgumentHelp("The disassembled output file"))
	var output: String?

	@Flag(help: ArgumentHelp("Whether to be strict with the standard"))
	var pedantic = false

	func run() throws {

	}

}
