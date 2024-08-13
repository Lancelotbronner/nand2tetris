//
//  TranslateCommand.swift
//  nand2tetris
//
//  Created by Christophe Bronner on 2024-08-13.
//

import Foundation
import ArgumentParser
import Nand2TetrisKit

struct TranslateCommand: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "translate",
		abstract: "Translates .vm files into .asm assembly")

	@Argument(
		help: ArgumentHelp("The VM files to translate"),
		completion: .file(extensions: ["", "vm", "txt"]))
	var input: [String]

	@Option(help: ArgumentHelp("The translated output file"))
	var output: String?

	@Flag(help: ArgumentHelp("Whether to be strict with the standard"))
	var pedantic = false

	func run() throws {
		
	}

}
