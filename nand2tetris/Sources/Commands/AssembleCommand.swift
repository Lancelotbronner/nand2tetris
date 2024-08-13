//
//  AssembleCommand.swift
//  nand2tetris
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

	@Option(help: ArgumentHelp("The assembled output file"))
	var output: String?

	@Flag(help: ArgumentHelp("Whether to be strict with the standard"))
	var pedantic = false

	func run() throws {
		let assembler = Assembler()
		for path in input {
			try process(path, with: assembler)
		}
		assembler.assemble()
		for diagnostic in assembler.diagnostics {
			print(diagnostic.debugDescription)
		}

		let outputURL: URL
		if let output {
			outputURL = URL(filePath: output, directoryHint: .notDirectory)
		} else if input.count == 1, let input = input.first {
			outputURL = URL(filePath: input, directoryHint: .notDirectory)
				.deletingPathExtension()
				.appendingPathExtension("hack")
		} else {
			outputURL = URL(filePath: "output.hack", directoryHint: .notDirectory)
		}

		try assembler.program.withUnsafeBufferPointer { buffer in
			try Data(buffer: buffer).write(to: outputURL)
		}
	}

	private func process(_ input: String, with assembler: Assembler) throws {
		var directory: ObjCBool = false
		let exists = FileManager.default.fileExists(atPath: input, isDirectory: &directory)
		guard exists else {
			throw ValidationError("Input '\(input)' does not exist")
		}

		if directory.boolValue {
			print("Input '\(input)' is a directory which isn't currently supported")
			return
		}

		assembler.file = URL(filePath: input, directoryHint: .notDirectory).lastPathComponent

		if input.hasSuffix(".hack"), let data = try? String(contentsOfFile: input) {
			assembler.process(data)
			return
		}

		let source = try String(contentsOfFile: input)
		assembler.process(source)
	}

}
