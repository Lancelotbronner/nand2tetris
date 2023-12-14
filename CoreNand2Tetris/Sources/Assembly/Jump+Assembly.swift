//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-18.
//

extension Jump: LosslessStringConvertible {

	private static func parse(pedantic description: Substring) -> Jump? {
		switch description {
		case "": Jump.none
		case "JGT": .jgt
		case "JEQ": .jeq
		case "JGE": .jge
		case "JLT": .jlt
		case "JNE": .jne
		case "JLE": .jle
		case "JMP": .jmp
		default: nil
		}
	}

	private static func parse(extended description: Substring) -> Jump? {
		switch description {
		default: nil
		}
	}

	public static func parse(_ description: Substring, pedantic: Bool) throws -> Jump {
		let description = pedantic ? description : Substring(description.uppercased())
		let _pedantic = Jump.parse(pedantic: description)
		let _extended = Jump.parse(extended: description)
		if let destination = _pedantic ?? (pedantic ? nil : _extended) {
			return destination
		}
		throw AssemblyError.invalidJump(description, recognized: _extended != nil)
	}

	public init(_ description: Substring, pedantic: Bool) throws {
		self = try Self.parse(description, pedantic: pedantic)
	}

	public init?(_ description: String) {
		try? self.init(Substring(description), pedantic: true)
	}

	public var description: String {
		switch self {
		case .none: ""
		case .jgt: "JGT"
		case .jeq: "JEQ"
		case .jge: "JGE"
		case .jlt: "JLT"
		case .jne: "JNE"
		case .jle: "JLE"
		case .jmp: "JMP"
		default: "?"
		}
	}

}
