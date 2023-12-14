//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-13.
//

import SwiftUI

struct AssemblyContentView: View {
	private let configuration: FileDocumentConfiguration<AssemblyDocument>

	init(configuration: FileDocumentConfiguration<AssemblyDocument>) {
		self.configuration = configuration
	}

	private var assembly: Binding<String> {
		configuration.isEditable ? configuration.$document.text : .constant(configuration.document.text)
	}

	var body: some View {
		HStack {
			AssemblyEditor(assembly)
			ProgramContentView(text: assembly.wrappedValue, pedantic: false)
		}
	}
}
