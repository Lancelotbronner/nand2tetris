//
//  UntranslateCommand.swift
//  nand2tetris
//
//  Created by Christophe Bronner on 2024-08-13.
//

import Foundation
import ArgumentParser
import Nand2TetrisKit

struct UntranslateCommand: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "untranslate",
		abstract: "Untranslates .asm files into .vm virtual machine code")

	@Argument(
		help: ArgumentHelp("The assembly files to untranslate"),
		completion: .file(extensions: ["", "asm", "hack", "txt"]))
	var input: [String]

	@Option(help: ArgumentHelp("The untranslated output file"))
	var output: String?

	@Flag(help: ArgumentHelp("Whether to be strict with the standard"))
	var pedantic = false

	func run() throws {

	}

}
