//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-13.
//

import SwiftUI
import Nand2TetrisKit

struct AssemblyContentView: View {
	private let configuration: FileDocumentConfiguration<AssemblyDocument>

	init(configuration: FileDocumentConfiguration<AssemblyDocument>) {
		self.configuration = configuration
	}

	private var assembler: Assembler {
		let assembler = Assembler()
		assembler.file = configuration.fileURL?.lastPathComponent ?? "<memory>"
		return assembler
	}

	private var assembly: Binding<String> {
		configuration.isEditable ? configuration.$document.text : .constant(configuration.document.text)
	}

	var body: some View {
		let assembler = assembler
		NavigationStack {
			AssemblyEditor(assembly)
		}
		.environment(\.assembler, assembler)
		.inspector(isPresented: .constant(true)) {
			AssemblyAssistantSidebar()
				.environment(\.assembler, assembler)
				.onChange(of: configuration.document.text, initial: true) {
					assembler.process(configuration.document.text)
					assembler.assemble()
					print(assembler.program)
				}
		}
	}
}

private struct AssemblyAssistant: View {
	private let assembler: Assembler
	private let assembly: String?

	public init(assembler: Assembler) {
		self.assembler = assembler
		self.assembly = nil
	}

	public init(text: String, pedantic: Bool) {
		self.assembler = Assembler(pedantic: pedantic)
		self.assembly = text
	}

	public var body: some View {
		AssemblyAssistantSidebar()
			.environment(\.assembler, assembler)
			.task {
				if let assembly {
					assembler.process(assembly)
					assembler.assemble()
				}
			}
	}
}
