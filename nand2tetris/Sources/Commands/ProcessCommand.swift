//
//  ProcessCommand.swift
//  nand2tetris
//
//  Created by Christophe Bronner on 2024-08-13.
//

import Foundation
import ArgumentParser
import Nand2TetrisKit

struct ProcessCommand: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "process",
		abstract: "Processes the input files into the output files, detects what you're trying to do")

	@Argument(
		help: ArgumentHelp("The translated output file"))
	var output: String?

	@Argument(
		help: ArgumentHelp("The input files"),
		completion: .file(extensions: ["", "asm", "hack", "txt", "vm", "jack"]))
	var input: [String]

	@Flag(help: ArgumentHelp("Whether to be strict with the standard"))
	var pedantic = false

	func run() throws {

	}

}
