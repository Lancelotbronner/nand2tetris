//
//  VirtualAssemblyEditor.swift
//  Nand2TetrisCompanionKit
//
//  Created by Christophe Bronner on 2024-08-13.
//

import SwiftUI

struct VirtualAssemblyEditor: View {
	@Environment(\.virtualAssembly) private var model: VirtualAssemblyModel

	init() { }

	var body: some View {
		@Bindable var model = model
		HStack {
			VStack(alignment: .trailing) {
				ForEach(Array(model.lines.enumerated()), id: \.offset) {
					Text(verbatim: "\($0.offset + 1)")
				}
			}
			.foregroundStyle(.secondary)
			TextEditor(text: $model.source)
		}
		.monospaced()
	}
}
