//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-18.
//

extension Computation: LosslessStringConvertible {

	private static func parse(pedantic description: Substring) -> Computation? {
		switch description {
		case "0": .zero
		case "1": .one
		case "-1": .minusOne
		case "D": .x
		case "A": .y
		case "M": .y.indirect
		case "!D": .notX
		case "!A": .notY
		case "!M": .notY.indirect
		case "-D": .negX
		case "-A": .negY
		case "-M": .negY.indirect
		case "D+1": .incX
		case "A+1": .incY
		case "M+1": .incY.indirect
		case "D-1": .decX
		case "A-1": .decY
		case "M-1": .decY.indirect
		case "D+A": .add
		case "D+M": .add.indirect
		case "D-A": .subY
		case "D-M": .subY.indirect
		case "A-D": .subX
		case "M-D": .subX.indirect
		case "D&A": .and
		case "D&M": .and.indirect
		case "D|A": .or
		case "D|M": .or.indirect
		default: nil
		}
	}

	private static func parse(extended description: Substring) -> Computation? {
		switch description {
		default: nil
		}
	}

	public static func parse(_ description: Substring, pedantic: Bool) throws -> Computation {
		let description = pedantic ? description : Substring(description.uppercased())
		let _pedantic = Computation.parse(pedantic: description)
		let _extended = Computation.parse(extended: description)
		if let destination = _pedantic ?? (pedantic ? nil : _extended) {
			return destination
		}
		throw AssemblyError.invalidComputation(description, recognized: _extended != nil)
	}

	public init(_ description: Substring, pedantic: Bool) throws {
		self = try Self.parse(description, pedantic: pedantic)
	}

	public init?(_ description: String) {
		try? self.init(Substring(description), pedantic: true)
	}

	public var description: String {
		switch self {
		case .zero: "0"
		case .one: "1"
		case .minusOne: "-1"
		case .x: "D"
		case .y: "A"
		case .y.indirect: "M"
		case .notX: "!D"
		case .notY: "!A"
		case .notY.indirect: "!M"
		case .negX: "-D"
		case .negY: "-A"
		case .negY.indirect: "-M"
		case .incX: "D+1"
		case .incY: "A+1"
		case .incY.indirect: "M+1"
		case .decX: "D-1"
		case .decY: "A-1"
		case .decY.indirect: "M-1"
		case .add: "D+A"
		case .add.indirect: "D+M"
		case .subY: "D-A"
		case .subY.indirect: "D-M"
		case .subX: "A-D"
		case .subX.indirect: "M-D"
		case .and: "D&A"
		case .and.indirect: "D&M"
		case .or: "D|A"
		case .or.indirect: "D|M"
		default: "?"
		}
	}

}
