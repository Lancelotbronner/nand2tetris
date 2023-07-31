//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

extension Instruction: LosslessStringConvertible {

	public init?(_ description: Substring, pedantic: Bool = true) throws {
		guard !description.isEmpty else { return nil }

		if description.first == "@" {
			let _value = description.dropFirst()
			guard let value = UInt16(_value) else {
				throw AssemblyError.expectedInteger(_value)
			}
			guard value <= 32_768 else {
				throw AssemblyError.outOfRange(value, min: 0, max: 32_768)
			}

			self.init(rawValue: value)
			return
		}

		let destination: Destination
		let jump: Jump
		var startIndex = description.startIndex
		var endIndex = description.endIndex

		if let d = description.firstIndex(of: "=") {
			destination = try Destination(description.prefix(upTo: d), pedantic: pedantic)
			startIndex = description.index(after: d)
		} else {
			destination = .none
		}

		if let j = description.lastIndex(of: ";") {
			jump = try Jump(description.suffix(from: j), pedantic: pedantic)
			endIndex = j
		} else {
			jump = .none
		}

		let computation = try Computation(description[startIndex..<endIndex], pedantic: pedantic)

		self.init(assign: computation, to: destination, jump: jump)
	}

	public init?(_ description: String) {
		try? self.init(Substring(description))
	}

	public var description: String {
		guard isComputing else { return "@\(value)" }
		return "\(destination)\(destination == .none ? "" : "=")\(computation)\(jump == .none ? "" : ";")\(jump)"
	}

}

extension Computation: LosslessStringConvertible {

	public init(_ description: Substring, pedantic: Bool = true) throws {
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
			throw AssemblyError.invalidComputation(description, pedantic: pedantic)
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

extension Destination: LosslessStringConvertible {

	public init(_ description: Substring, pedantic: Bool = true) throws {
		switch description {
		case "": self = .none
		case "M": self = .m
		case "D": self = .d
		case "MD": self = .md
		case "A": self = .a
		case "AM": self = .am
		case "AD": self = .ad
		case "AMD": self = .amd
		default:
			if !pedantic {
				switch description {
				case "DM": self = .md
				case "AM": self = .am
				case "DA": self = .ad
				case "MAD", "DMA", "DAM", "ADM", "MDA": self = .amd
				default: break
				}
			}
			throw AssemblyError.invalidDestination(description, pedantic: pedantic)
		}
	}

	public init?(_ description: String) {
		try? self.init(Substring(description))
	}

	public var description: String {
		switch self {
		case .none: return ""
		case .a: return "A"
		case .m: return "M"
		case .d: return "D"
		case .am: return "AM"
		case .ad: return "AD"
		case .md: return "MD"
		case .amd: return "AMD"
		default: return "?"
		}
	}

}

extension Jump: LosslessStringConvertible {

	public init(_ description: Substring, pedantic: Bool = true) throws {
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
			throw AssemblyError.invalidJump(description, pedantic: pedantic)
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

