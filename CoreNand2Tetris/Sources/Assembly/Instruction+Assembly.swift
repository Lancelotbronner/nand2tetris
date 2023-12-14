//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

extension Instruction: LosslessStringConvertible {

	public static func parse(addressing source: inout Substring, pedantic: Bool = true) throws -> Instruction? {
		guard source.first == "@" else { return nil }
		let _value = source
			.dropFirst()
			.prefix(while: \.isPedanticInteger)

		guard let value = UInt16(_value), value <= 32_768 else {
			throw AssemblyError.expectedIntegerInRange(_value, min: 0, max: 32_768)
		}

		source = _value
		return Instruction(rawValue: value)
	}

	public static func parse(computing source: inout Substring, pedantic: Bool = true) throws -> Instruction? {
		let destination: Destination
		let jump: Jump

		if let d = source.firstIndex(of: "=") {
			let _destination = source.prefix(upTo: d)
			destination = try Destination.parse(_destination, pedantic: pedantic)
			source.removeFirst(_destination.count + 1)
		} else {
			destination = .null
		}

		if !pedantic {
			source = source.trimmingPrefix(while: \.isWhitespace)
		}

		if let j = source.lastIndex(of: ";") {
			let _jump = source.suffix(from: source.index(after: j))
			jump = try Jump(_jump, pedantic: pedantic)
			source.removeLast(_jump.count + 1)
		} else {
			jump = .none
		}

		let computation = try Computation(source, pedantic: pedantic)

		return Instruction(assign: computation, to: destination, jump: jump)
	}

	public static func parse(_ source: inout Substring, pedantic: Bool = true) throws -> Instruction? {
		if let instruction = try Instruction.parse(addressing: &source, pedantic: pedantic) {
			return instruction
		}
		return try Instruction.parse(computing: &source, pedantic: pedantic)
	}

	public init?(_ description: Substring, pedantic: Bool = true) throws {
		var tmp = description
		guard let value = try Instruction.parse(&tmp, pedantic: pedantic) else { return nil }
		self = value
	}

	public init?(_ description: String) {
		try? self.init(Substring(description))
	}

	public var description: String {
		guard isComputing else { return "@\(value)" }
		return "\(destination)\(destination == .null ? "" : "=")\(computation)\(jump == .none ? "" : ";")\(jump)"
	}

}
