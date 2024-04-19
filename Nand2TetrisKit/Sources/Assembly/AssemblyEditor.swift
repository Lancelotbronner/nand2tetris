//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-13.
//

import SwiftUI

public struct AssemblyEditor: View {
	@Binding private var text: String

	public init(_ text: Binding<String>) {
		_text = text
	}

	public var body: some View {
		HStack {
			VStack(alignment: .trailing) {
				var i = 0
				ForEach(text.split(separator: "\n", omittingEmptySubsequences: false), id: \.startIndex) { line in
					let line = { () -> Int in
						defer { i += 1 }
						return i
					}()
					Text(verbatim: "\(line)")
				}
			}
			.foregroundStyle(.secondary)
			TextEditor(text: $text)
		}
		.monospaced()
	}
}
