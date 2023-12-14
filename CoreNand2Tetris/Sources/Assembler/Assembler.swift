//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-18.
//

public final class Assembler {

	public init(pedantic: Bool = true) {
		self.pedantic = pedantic
	}

	public func assemble() {
		if program.count > 32_768 && pedantic {
			diagnose(AssemblyError.programTooLarge, at: 32_768)
		}

		var variable: UInt16 = 16
		for (symbol, offset) in placeholders {
			if let instruction = symbols[symbol] {
				program[offset] = instruction
				continue
			}
			let instruction = Instruction(rawValue: variable)
			symbols[symbol] = instruction
			program[offset] = instruction
			variable += 1
		}
		placeholders.removeAll()
	}

	//MARK: - Configuration Management

	/// Whether the assembler should only accept the standard.
	public let pedantic: Bool

	//MARK: - Diagnostics Management

	public private(set) var diagnostics: [Diagnostic] = []
	public var file: String?
	public var line = 1

	//TODO: line map for diagnostics to capture the source range and add column information

	public func diagnose(_ error: AssemblyError, from source: Substring? = nil, at line: Int) {
		let diagnostic = Diagnostic(message: error, from: source, at: line, of: file)
		diagnostics.append(diagnostic)
	}

	public func diagnose(_ error: AssemblyError, from source: Substring? = nil) {
		diagnose(error, from: source, at: line)
	}

	//MARK: - Symbol Management

	public private(set) var symbols: [Substring : Instruction] = [
		"R0": 0, "R1": 1, "R2": 2, "R3": 3, "R4": 4, "R5": 5,
		"R6": 6, "R7": 7, "R8": 8, "R9": 9, "R10": 10, "R11": 11,
		"R12": 12, "R13": 13, "R14": 14, "R15": 15,
		"SP": 0, "LCL": 1, "ARG": 2, "THIS": 3, "THAT": 4,
		"SCREEN": 16384, "KBD": 24576,
	]
	private var placeholders: [(Substring, Int)] = []

	public func assign(_ symbol: Substring, to address: UInt16) {
		let instruction = Instruction(addressing: address)
		symbols[symbol] = instruction
	}

	private func insert(placeholder symbol: Substring, from source: Substring) {
		defer { program.append(Instruction.nop) }
		placeholders.append((symbol, program.count))
	}

	//MARK: - Program Management

	public private(set) var program: [Instruction] = []

	public func process(assembly: Assembly) {
		if let instruction = assembly.rawValue {
			program.append(instruction)
		} else if let symbol = assembly.symbol {
			if let instruction = symbols[symbol] {
				program.append(instruction)
				return
			}
			insert(placeholder: symbol, from: assembly.source)
		} else if let label = assembly.label {
			assign(label, to: UInt16(program.count))
		}
	}

	public func process(line source: Substring) {
		line += 1
		do {
			let assembly = try Assembly.parse(line: source, pedantic: pedantic)
			process(assembly: assembly)
		} catch let error as AssemblyError {
			diagnose(error, from: source)
		} catch { }
	}

	public func process(_ source: Substring) {
		var source = source
		while let l = source.firstIndex(where: \.isNewline) {
			let line = source[..<l]
			process(line: line)
			source.removeFirst(line.count)
			source = source.trimmingPrefix(while: \.isWhitespace)
		}
		if !source.isEmpty {
			process(line: source)
		}
	}

	public func process(_ source: String) {
		process(Substring(source))
	}

}

#if canImport(Foundation)
import Foundation

extension Assembler {
	public func process(data: Data) {
		let instructions = data.read(as: Instruction.self)
		program.append(contentsOf: instructions)
	}
}

#endif
