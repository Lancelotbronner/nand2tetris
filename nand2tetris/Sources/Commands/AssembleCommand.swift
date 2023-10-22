//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-18.
//

import Foundation
import ArgumentParser
import Nand2TetrisKit

struct AssembleCommand: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "assemble",
		abstract: "Assembles .asm files into .hack machine code")

	@Argument(
		help: ArgumentHelp("The assembly files to assemble"),
		completion: .file(extensions: ["", "asm", "hack", "txt"]))
	var input: [String]

	@Argument(
		help: ArgumentHelp("The assembled output file"))
	var output: String

	@Flag(help: ArgumentHelp("Wether to be strict with the standard"))
	var pedantic = true

	func run() throws {
		let assembler = Assembler()
		for path in input {
			try process(path, with: assembler)
		}
		try assembler.finalize()
		for diagnostic in assembler.diagnostics {
			print(diagnostic)
		}

		let output = URL(filePath: output, directoryHint: .notDirectory)
		try assembler.program.withUnsafeBufferPointer { buffer in
			try Data(buffer: buffer).write(to: output)
		}
	}

	private func process(_ input: String, with assembler: Assembler) throws {
		var directory: ObjCBool = false
		let exists = FileManager.default.fileExists(atPath: input, isDirectory: &directory)
		guard exists else {
			print("Input '\(input)' does not exist")
			return
		}

		if directory.boolValue {
			print("Found directory which aren't currently supported '\(input)'")
		}

		if input.hasSuffix(".hack"), let data = FileManager.default.contents(atPath: input) {
			//TODO: Support text version
			assembler.process(data: data)
			return
		}

		let source = try String(contentsOfFile: input)
		assembler.assemble(Substring(source))
	}

}
