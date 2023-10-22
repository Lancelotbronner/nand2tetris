//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-18.
//

extension Jump: LosslessStringConvertible {

	public init(_ description: Substring, pedantic: Bool = true) throws {
		let description = pedantic ? description : Substring(description.uppercased())
		switch description {
		case "": self = .none
		case "JGT": self = .jgt
		case "JEQ": self = .jeq
		case "JGE": self = .jge
		case "JLT": self = .jlt
		case "JNE": self = .jne
		case "JLE": self = .jle
		case "JMP": self = .jmp
		default:
			if !pedantic {
				switch description {
				default: break
				}
			}
			throw AssemblyError.invalidJump(description, recognized: false)
		}
	}

	public init?(_ description: String) {
		try? self.init(Substring(description))
	}

	public var description: String {
		switch self {
		case .none: return ""
		case .jgt: return "JGT"
		case .jeq: return "JEQ"
		case .jge: return "JGE"
		case .jlt: return "JLT"
		case .jne: return "JNE"
		case .jle: return "JLE"
		case .jmp: return "JMP"
		default: return "?"
		}
	}

}


