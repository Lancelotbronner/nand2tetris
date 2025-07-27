//
//  CodeFormatting.swift
//  Nand2TetrisUI
//
//  Created by Christophe Bronner on 2025-07-27.
//

import SwiftUI
import Nand2TetrisKit

public struct Nand2TetrisFormatting: AttributedTextFormattingDefinition {
	public var body: some AttributedTextFormattingDefinition<AttributeScopes.Nand2TetrisAttributes> {
		SyntaxHighlighting()
	}
}

private struct SyntaxHighlighting<Scope: AttributeScope>: AttributedTextValueConstraint {
	typealias AttributeKey = AttributeScopes.SwiftUIAttributes.ForegroundColorAttribute

	func constrain(_ container: inout Attributes) {
		guard let token = container.nand2tetris.token else { return }
		switch token {
		case .string: container.foregroundColor = Color(.string)
		case .number: container.foregroundColor = Color(.number)
		case .keyword: container.foregroundColor = Color(.keyword)
		}
	}
}
