//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-13.
//

import SwiftUI
import Nand2TetrisKit

public struct ProgramContentView: View {
	@State private var selection: Int?
	private let assembler: Assembler

	public init(assembler: Assembler) {
		self.assembler = assembler
	}

	public init(text: String, pedantic: Bool) {
		self.assembler = Assembler(pedantic: pedantic)
		assembler.process(text)
		assembler.assemble()
	}

	public var body: some View {
		HStack {
			ProgramView(assembler.program, selection: $selection)
			SymbolTableView(assembler.symbols)
		}
		.monospaced()
		.inspector(isPresented: .constant(true)) {
			if let selection {
				InstructionView(assembler.program[selection])
			}
		}
	}
}

public struct ProgramView: View {
	@Binding private var selection: Int?
	private let program: [(offset: Int, element: Instruction)]

	public init(_ program: [Instruction], selection: Binding<Int?>) {
		_selection = selection
		self.program = Array(program.enumerated())
	}

	public var body: some View {
		List(selection: $selection) {
			ForEach(program, id: \.offset) { line in
				HStack {
					Text(line.offset.description)
						.foregroundStyle(.secondary)
					Text(line.element.description)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
			}
		}
		.listStyle(.plain)
		.frame(maxWidth: .infinity)
	}
}

public struct SymbolTableView: View {
	private let table: [(key: Substring, value: Instruction)]

	init(_ table: [Substring : Instruction]) {
		self.table = table.sorted { $0.key < $1.key }
	}

	public var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(table, id: \.key) { pair in
					LabeledContent(pair.key, value: pair.value.rawValue.description)
				}
			}
		}
		.lineLimit(1)
	}
}
