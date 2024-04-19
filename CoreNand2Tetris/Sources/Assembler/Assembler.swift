//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-18.
//

import Observation

@Observable
public final class Assembler {

	public init(pedantic: Bool = true) {
		self.pedantic = pedantic
	}

	//MARK: - Assembly Management

	public func assemble() {
		if program.count > Hack.memory && pedantic {
			diagnose(AssemblyError.programTooLarge, at: Hack.memory)
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
	public var pedantic = true

	//MARK: - Diagnostics Management

	public private(set) var diagnostics: [Diagnostic] = []
	public var file: String?
	public var line = 1

	//TODO: line map for diagnostics to capture the source range and add column information

	public func diagnose(_ error: AssemblyError, from source: Substring? = nil, at line: Int) {
		let diagnostic = Diagnostic(message: error, from: source, at: line, of: file)
		diagnostics.append(diagnostic)
	}

	//MARK: - Symbol Management

	public static let defaultSymbols: Set<Substring> = [
		"R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8",
		"R9", "R10", "R11", "R12", "R13", "R14", "R15",
		"SP", "LCL", "ARG", "THIS", "THAT",
		"SCREEN", "KBD",
	]

	public private(set) var symbols: [Substring : Instruction] = [
		"R0": 0, "R1": 1, "R2": 2, "R3": 3, "R4": 4, "R5": 5,
		"R6": 6, "R7": 7, "R8": 8, "R9": 9, "R10": 10, "R11": 11,
		"R12": 12, "R13": 13, "R14": 14, "R15": 15,
		"SP": 0, "LCL": 1, "ARG": 2, "THIS": 3, "THAT": 4,
		"SCREEN": 16384, "KBD": 24576,
	]

	@ObservationIgnored
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

	public var program: [Instruction] = []

	public func append(_ instruction: Instruction) {
		program.append(instruction)
	}

	public func append(_ instructions: some Sequence<Instruction>) {
		program.append(contentsOf: instructions)
	}

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

}

extension Assembler {

	@inlinable @inline(__always)
	public func diagnose(_ error: AssemblyError, from source: Substring? = nil) {
		diagnose(error, from: source, at: line)
	}

	@inlinable
	public func process(line source: Substring) {
		line += 1
		do {
			let assembly = try Assembly.parse(line: source, pedantic: pedantic)
			process(assembly: assembly)
		} catch let error as AssemblyError {
			diagnose(error, from: source)
		} catch { }
	}

	@inlinable
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

	@inlinable
	public func process(_ source: some StringProtocol) {
		process(Substring(source))
	}

}

#if canImport(Foundation)
import Foundation

extension Assembler {
	@inlinable
	public func append(data: Data) {
		append(data.read(as: Instruction.self))
	}
}
#endif
