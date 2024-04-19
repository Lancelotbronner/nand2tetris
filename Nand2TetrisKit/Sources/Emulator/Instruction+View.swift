//
//  File.swift
//
//
//  Created by Christophe Bronner on 2023-08-28.
//

import Nand2TetrisKit

#if canImport(SwiftUI)
import SwiftUI

public struct InstructionView: View {
	@Binding private var instruction: Instruction

	public init(_ instruction: Binding<Instruction>) {
		_instruction = instruction
	}

	@inlinable
	public init(_ instruction: Instruction) {
		self.init(.constant(instruction))
	}

	public var body: some View {
		//TODO: Add help to each flag
		HStack(spacing: 0) {
			Toggle("i", isOn: $instruction.i)

			Divider()
				.padding(.horizontal, 2)

			Toggle("zx", isOn: $instruction.zx)
			Toggle("nx", isOn: $instruction.nx)
			Toggle("zy", isOn: $instruction.zy)
			Toggle("ny", isOn: $instruction.ny)
			Toggle("f", isOn: $instruction.f)
			Toggle("no", isOn: $instruction.no)

			Divider()
				.padding(.horizontal, 2)

			Toggle("a", isOn: $instruction.a)
			Toggle("d", isOn: $instruction.d)
			Toggle("m", isOn: $instruction.m)

			Divider()
				.padding(.horizontal, 2)

			Toggle("gt", isOn: $instruction.gt)
			Toggle("eq", isOn: $instruction.eq)
			Toggle("lt", isOn: $instruction.lt)

			Divider()
				.padding(.horizontal, 2)

			Text(instruction.description)
				.minimumScaleFactor(0.6)
				.padding(.horizontal, 4)

			Text("●")
				.foregroundStyle(.red)
				.opacity(instruction.legal ? 0 : 1)
				.help("The '\(instruction.computation.description)' instruction is illegal in pedantic mode")
		}
		.monospaced()
		.lineLimit(1)
		.toggleStyle(.text)
		.foregroundStyle(.primary, .tertiary)
		.fixedSize(horizontal: false, vertical: true)
	}
}
#endif

#Preview {
	struct ContentPreview: View {
		@State var tmp = Instruction(assign: .add, to: .amd, jump: .jgt)

		var body: some View {
			VStack(alignment: .leading, spacing: 0) {
				InstructionView($tmp)
			}
			.padding()
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
	return ContentPreview()
}
