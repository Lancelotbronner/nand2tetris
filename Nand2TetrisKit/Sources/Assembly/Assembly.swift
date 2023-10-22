//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-18.
//

public struct Assembly {

	/// The source text which produced this assembly
	public var source: Substring

	/// The source line which produced this assembly
	public var line: Int

	/// The Hack instruction of this line, if any
	public var rawValue: Instruction?

	/// The instruction's source, if any
	public var instruction: Substring?

	/// The declared label of this line, if any
	public var label: Substring?

	/// The symbol referenced on this line, if any
	public var symbol: Substring?

	/// The comment of this line, if any
	public var comment: Substring?

}

extension Assembly {

	public static func parse(line source: Substring, pedantic: Bool = true) throws -> Assembly {
		var assembly = Assembly(source: source, line: 0)

		var source = source.trimmingPrefix(while: \.isWhitespace)
		guard !source.isEmpty else { return assembly }
		while source.last?.isWhitespace ?? false {
			source.removeLast()
		}

		assembly.comment = Assembly.parse(comment: &source)
		while source.last?.isWhitespace ?? false {
			source.removeLast()
		}
		
		let backup = source
		switch source.first {
		case "@":
			if let symbol = try Assembly.parse(symbol: &source, pedantic: pedantic) {
				assembly.symbol = symbol
			} else if let instruction = try Instruction.parse(addressing: &source, pedantic: pedantic) {
				assembly.instruction = backup
				assembly.rawValue = instruction
			}
		case "(":
			assembly.label = try Assembly.parse(label: &source, pedantic: pedantic)
		case .none:
			return assembly
		default:
			assembly.instruction = backup
			assembly.rawValue = try Instruction.parse(computing: &source, pedantic: pedantic)
		}

		return assembly
	}

	public static func parse(symbol source: inout Substring, pedantic: Bool = true) throws -> Substring? {
		guard source.first == "@" else { return nil }
		let symbol = source.dropFirst()
		guard symbol.contains(where: \.isPedanticInteger.not) else { return nil }
		return symbol
	}

	public static func parse(label source: inout Substring, pedantic: Bool = true) throws -> Substring? {
		guard source.first == "(" else { return nil }
		guard source.last == ")" else {
			throw AssemblyError.labelMissingClosingParenthesis(label: source.dropFirst())
		}
		let label = source.dropFirst().dropLast()
		source.removeAll()
		return label
	}

	public static func parse(comment source: inout Substring, pedantic: Bool = true) -> Substring? {
		if source.starts(with: "//") {
			defer { source.removeAll() }
			return source.dropFirst(2)
		}

		var i = source.endIndex
		var slash = 0
		repeat {
			i = source.index(before: i)
			guard source[i] == "/" else {
				slash = 0
				continue
			}
			slash += 1
		} while !(i <= source.startIndex || slash >= 2)
		guard slash >= 2 else { return nil }
		defer { source.removeLast(source[i...].count) }
		return source[source.index(i, offsetBy: 2)...]
	}

}
