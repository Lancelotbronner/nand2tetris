//
//  FormattingAttributes.swift
//  Nand2TetrisKit
//
//  Created by Christophe Bronner on 2025-07-27.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

/// Classification of tokens for the code editor.
public enum TokenClassification: String, Codable, Sendable {
	case string
	case number
	case keyword
}

#if canImport(Foundation)
import Foundation

public extension AttributeScopes {
	struct Nand2TetrisAttributes: AttributeScope {
		public let token: TokenAttribute
		public let instruction: InstructionAttribute

		public let link: FoundationAttributes.LinkAttribute
		
#if canImport(SwiftUI)
		public let foregroundColor: SwiftUIAttributes.ForegroundColorAttribute
#endif
	}

	var nand2tetris: Nand2TetrisAttributes.Type { Nand2TetrisAttributes.self }
}

public extension AttributeScopes.Nand2TetrisAttributes {
	struct TokenAttribute: CodableAttributedStringKey, Sendable {
		public typealias Value = TokenClassification
		public static let name = "token"
	}

	struct InstructionAttribute: CodableAttributedStringKey, Sendable {
		public typealias Value = Instruction
		public static let name = "instruction"
	}
}
#endif
