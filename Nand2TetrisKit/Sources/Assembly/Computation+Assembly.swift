//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-18.
//

extension Computation: LosslessStringConvertible {

	public init(_ description: Substring, pedantic: Bool = true) throws {
		let description = pedantic ? description : Substring(description.uppercased())
		switch description {
		case "0": self = .zero
		case "1": self = .one
		case "-1": self = .minusOne
		case "D": self = .x
		case "A": self = .y
		case "M": self = .y.indirect
		case "!D": self = .notX
		case "!A": self = .notY
		case "!M": self = .notY.indirect
		case "-D": self = .negX
		case "-A": self = .negY
		case "-M": self = .negY.indirect
		case "D+1": self = .incX
		case "A+1": self = .incY
		case "M+1": self = .incY.indirect
		case "D-1": self = .decX
		case "A-1": self = .decY
		case "M-1": self = .decY.indirect
		case "D+A": self = .add
		case "D+M": self = .add.indirect
		case "D-A": self = .subY
		case "D-M": self = .subY.indirect
		case "A-D": self = .subX
		case "M-D": self = .subX.indirect
		case "D&A": self = .and
		case "D&M": self = .and.indirect
		case "D|A": self = .or
		case "D|M": self = .or.indirect
		default:
			if !pedantic {
				switch description {
					//TODO: Non-pedantic parsing
				default: break
				}
			}
			//TODO: recognize extended errors in pedantic mode
			throw AssemblyError.invalidComputation(description, recognized: false)
		}
	}

	public init?(_ description: String) {
		try? self.init(Substring(description))
	}

	public var description: String {
		switch self {
		case .zero: return "0"
		case .one: return "1"
		case .minusOne: return "-1"
		case .x: return "D"
		case .y: return "A"
		case .y.indirect: return "M"
		case .notX: return "!D"
		case .notY: return "!A"
		case .notY.indirect: return "!M"
		case .negX: return "-D"
		case .negY: return "-A"
		case .negY.indirect: return "-M"
		case .incX: return "D+1"
		case .incY: return "A+1"
		case .incY.indirect: return "M+1"
		case .decX: return "D-1"
		case .decY: return "A-1"
		case .decY.indirect: return "M-1"
		case .add: return "D+A"
		case .add.indirect: return "D+M"
		case .subY: return "D-A"
		case .subY.indirect: return "D-M"
		case .subX: return "A-D"
		case .subX.indirect: return "M-D"
		case .and: return "D&A"
		case .and.indirect: return "D&M"
		case .or: return "D|A"
		case .or.indirect: return "D|M"
		default: return "?"
		}
	}

}
