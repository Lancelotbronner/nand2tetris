//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-13.
//

import SwiftUI
import Nand2TetrisKit

public struct AssemblyProgramView: View {
	@Environment(\.assembler) private var assembler: Assembler
	@State private var selection = 0

	private var instruction: Binding<Instruction> {
		guard !assembler.program.isEmpty else { return .constant(Instruction.zero) }
		return Bindable(assembler).program[selection]
	}

	public var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			InstructionView(instruction)
				.font(.caption)
				.padding(4)
			Divider()
			List(selection: $selection) {
				ForEach(Array(assembler.program.enumerated()), id: \.offset) { line in
					HStack {
						Text(line.offset.description)
							.foregroundStyle(.secondary)
						Text(line.element.description)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					.listRowSeparator(.hidden)
				}
			}
			.listStyle(.plain)
			.scrollContentBackground(.hidden)
			.layoutPriority(1)
		}
		.frame(maxWidth: .infinity)
	}
}
