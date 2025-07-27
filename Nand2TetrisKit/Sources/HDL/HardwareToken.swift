//
//  HardwareToken.swift
//  Nand2TetrisKit
//
//  Created by Christophe Bronner on 2025-01-12.
//

/// Tokens of the hardware language.
public enum HardwareToken {
	case keyword(HardwareKeyword)
	case symbol(Substring)
	case identifier(Substring)
	case constant(Int)
}

/// Keywords of the hardware language.
public enum HardwareKeyword {
	case chip
	case `in`
	case out
	case builtin
	case clocked
	case parts
}
