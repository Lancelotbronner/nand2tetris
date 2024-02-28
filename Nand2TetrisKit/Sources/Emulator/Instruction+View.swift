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
	let instruction: Instruction

	public init(_ instruction: Instruction) {
		self.instruction = instruction
	}

	public var body: some View {
		//TODO: Add help to each flag
		HStack {
			flag("i", \.i)
			Divider()
			flag("zx", \.zx)
			flag("nx", \.nx)
			flag("zy", \.zy)
			flag("ny", \.ny)
			flag("f", \.f)
			flag("no", \.no)
			Divider()
			flag("a", \.a)
			flag("d", \.d)
			flag("m", \.m)
			Divider()
			flag("gt", \.gt)
			flag("eq", \.eq)
			flag("lt", \.lt)
			Text(instruction.description)
				.padding(.leading)
		}
		.monospaced()
	}

	private func flag(_ title: LocalizedStringKey, _ keyPath: KeyPath<Instruction, Bool>) -> some View {
		Text(title)
			.foregroundStyle(instruction.isComputing && instruction[keyPath: keyPath] ? .primary : .tertiary)
	}
}
#endif
