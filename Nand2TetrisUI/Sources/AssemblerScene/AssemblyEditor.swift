//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-13.
//

import SwiftUI
import Nand2TetrisUI

public struct AssemblyEditor: View {
	@Binding var text: String

	public var body: some View {
		CodeEditor($text)
	}
}

#Preview {
	@Previewable @State var text = AssemblyDocument().text
	AssemblyEditor(text: $text)
		.padding()
}
