//
//  CodeEditor.swift
//  Nand2TetrisUI
//
//  Created by Christophe Bronner on 2025-07-27.
//

import SwiftUI

public struct CodeEditor: View {
	@Binding private var text: AttributedString
	@State private var selection = AttributedTextSelection()

	public init(_ text: Binding<String>) {
		_text = Binding<AttributedString> {
			AttributedString(text.wrappedValue)
		} set: {
			text.wrappedValue = String($0.characters[...])
		}
	}

	public var body: some View {
		TextEditor(text: $text, selection: $selection)
			.textInputFormattingControlVisibility(.hidden, for: .all)
			.attributedTextFormattingDefinition(Nand2TetrisFormatting())
			.monospaced()
	}
}

#Preview {
	@Previewable @State var text = ""
	CodeEditor($text)
		.padding()
}
