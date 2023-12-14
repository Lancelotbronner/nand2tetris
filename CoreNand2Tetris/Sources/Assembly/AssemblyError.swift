//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public enum AssemblyError: Error {
	case expectedInteger(Substring)
	case expectedIntegerInRange(Substring, min: UInt16, max: UInt16)
	/// Invalid destination and whether it recognized it as an extended destination in pedantic mode
	case invalidDestination(Substring, recognized: Bool)
	case invalidJump(Substring, recognized: Bool)
	case invalidComputation(Substring, recognized: Bool)
	case labelMissingClosingParenthesis(label: Substring)
	/// The program cannot fit within Hack's ROM
	case programTooLarge
	case undefinedSymbol(Substring)
}

extension AssemblyError: CustomStringConvertible {

	public var description: String {
		switch self {
		case let .expectedInteger(source): 
			return "expected integer but got '\(source)'"
		case let .expectedIntegerInRange(source, min, max):
			return "expected integer between \(min) and \(max) but got '\(source)'"
		case let .invalidDestination(source, recognized):
			return recognized
				? "found extended destination in pedantic mode, must be one of A, M, AM, D, AD, MD, AMD"
				: "invalid destination '\(source)'"
		case let .invalidJump(source, recognized):
			return recognized
			? "found extended jump in pedantic mode, must be one of JGT, JGE, JEQ, JNE, JLE, JLT, JMP"
			: "invalid jump '\(source)'"
		case let .invalidComputation(source, recognized):
			return recognized
			? "found extended instruction in pedantic mode, must be one of 0, 1, -1, D, A, M, !D, !A, !M, -D, -A, -M, D+1, A+1, M+1, D-1, A-1, M-1, D+A, D+M, D-A, D-M, A-D, M-D, D&A, D&M, D|A, D|M"
			: "invalid instruction '\(source)'"
		case let .labelMissingClosingParenthesis(label):
			return "label '\(label)' is missing closing parenthesis"
		case .programTooLarge:
			return "program cannot fit within ROM"
		case let .undefinedSymbol(symbol):
			return "undefined symbol '\(symbol)'"
		}
	}

}
