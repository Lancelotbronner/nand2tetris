//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-04-19.
//

import SwiftUI

struct AssemblyAssistantSidebar: View {
	@State private var tab = Tab.program

	init() { }

	var body: some View {
		VStack(spacing: 4) {
			Divider()
			HStack {
				Toggle(isOn: $tab == .program) {
					Label("Program", systemImage: "doc.badge.gearshape")
				}
				Toggle(isOn: $tab == .symbols) {
					Label("Symbols", systemImage: "text.line.last.and.arrowtriangle.forward")
				}
			}
			.toggleStyle(.button)
			.buttonStyle(.borderless)
			.labelStyle(.iconOnly)
			VStack(alignment: .leading, spacing: 0) {
				Divider()
				switch tab {
				case .program: AssemblyProgramView()
				case .symbols: AssemblySymbolTableView()
				}
				Spacer()
			}
		}
	}

	private enum Tab: Int {
		case program = 1
		case symbols = 2
	}
}
