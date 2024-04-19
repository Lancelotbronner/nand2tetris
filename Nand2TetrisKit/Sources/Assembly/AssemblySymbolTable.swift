//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-04-19.
//

import SwiftUI
import Nand2TetrisKit

public struct AssemblySymbolTableView: View {
	@State private var selection: Substring?
	@Environment(\.assembler) private var assembler: Assembler

	typealias Symbol = Dictionary<Substring, Instruction>.Element

	private func isUserSymbol(_ symbol: Symbol) -> Bool {
		!Assembler.defaultSymbols.contains(symbol.key)
	}

	private func isDefaultSymbol(_ symbol: Symbol) -> Bool {
		Assembler.defaultSymbols.contains(symbol.key)
	}

	public var body: some View {
		let symbols = assembler.symbols.sorted(by: \.key)
		List(selection: $selection) {
			Section("USER") {
				ForEach(symbols.filter(isUserSymbol), id: \.key) { pair in
					LabeledContent(pair.key, value: pair.value.rawValue.description)
						.tag(pair.key)
						.listRowSeparator(.hidden)
				}
			}
			Section("DEFAULT") {
				ForEach(symbols.filter(isDefaultSymbol), id: \.key) { pair in
					LabeledContent(pair.key, value: pair.value.rawValue.description)
						.tag(pair.key)
						.listRowSeparator(.hidden)
				}
			}
		}
		.listStyle(.inset)
		.scrollContentBackground(.hidden)
		.lineLimit(1)
	}
}
