//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-21.
//

import Foundation
import Nand2TetrisKit

private let _cd = false

public enum TestUtils {

	static func cd() {
		guard !_cd else { return }
		let path = URL(filePath: #filePath, directoryHint: .notDirectory)
			.deletingLastPathComponent()
			.path(percentEncoded: false)
		FileManager.default.changeCurrentDirectoryPath(path)
	}

	static func cd(_ path: String) {
		cd()
		FileManager.default.changeCurrentDirectoryPath(path)
	}

	public static func assemble(_ source: String, pedantic: Bool) -> Assembler {
		print("\n[ Assembly Test \(pedantic ? "(pedantic) " : "")]")
		let assembler = Assembler(pedantic: pedantic)
		assembler.file = "<memory>"

		print("\n==> Source")
		print(source)

		assembler.process(Substring(source))
		assembler.assemble()

		print("\n==> \(assembler.diagnostics.count) diagnostics")
		for diagnostic in assembler.diagnostics {
			print(diagnostic.debugDescription)
		}

		print("")
		return assembler
	}

	public static func assemble(contentsOf file: String, pedantic: Bool) throws -> Bool {
		cd()

		print("\n[ Assembly Test \(pedantic ? "(pedantic) " : "")]")
		let assembler = Assembler(pedantic: pedantic)
		assembler.file = file + ".asm"

		print("\n==> \(file).asm")
		let source = try String(contentsOfFile: "Assembler/\(file).asm")
		print(source)

		assembler.process(Substring(source))
		assembler.assemble()

		print("\n==> \(assembler.diagnostics.count) diagnostics")
		for diagnostic in assembler.diagnostics {
			print(diagnostic.debugDescription)
		}

		print("\n==> validation")
		var validation = Substring(try String(contentsOfFile: "Assembler/\(file).hack"))
		var valid = true

		var i = 0
		while !validation.isEmpty, i < assembler.program.count {
			let sourceY = validation.prefix(while: \.isNewline.not)
			let sourceN = assembler.program[i].binary
			let sourceI = i.description
			let instrY = Instruction(rawValue: UInt16(sourceY, radix: 2)!).description
			let instrN = assembler.program[i].description
			let paddingY = String(repeating: " ", count: 8 - instrY.count)
			let paddingN = String(repeating: " ", count: 8 - instrN.count)
			let paddingI = String(repeating: " ", count: 6 - sourceI.count)
			if sourceY == sourceN {
				print(" \(sourceI)\(paddingI)\(instrY)\(paddingY)\(sourceY)")
			} else {
				print("✘\(sourceI)\(paddingI)\(instrN)\(paddingN)\(sourceN)")
				print("✔︎\(sourceI)\(paddingI)\(instrY)\(paddingY)\(sourceY)")
				valid = false
			}
			i += 1
			validation.removeFirst(sourceY.count)
			validation = validation.trimmingPrefix(while: \.isNewline)
		}

		while let line = validation.firstIndex(where: \.isNewline) {
			let required = validation[..<line]
			print("+ \(required)")
			validation.removeFirst(required.count + 1)
		}
		for i in i..<assembler.program.count {
			print("- \(assembler.program[i].binary)")
		}

		print("")
		return valid
	}

}
