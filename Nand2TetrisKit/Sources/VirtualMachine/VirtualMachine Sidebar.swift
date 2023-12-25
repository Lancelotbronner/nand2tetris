//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2Tetris

struct VirtualMachineSidebar: View {
	@State private var tab = Tab.program

	init() { }

	private var isProgram: Binding<Bool> {
		Binding { tab == .program } set: {
			if $0 { tab = .program}
		}
	}

	private var isCallstack: Binding<Bool> {
		Binding { tab == .callstack } set: {
			if $0 { tab = .callstack}
		}
	}

	var body: some View {
		Divider()
		HStack {
			Toggle(isOn: isProgram) {
				Label("Program", systemImage: "doc.badge.gearshape")
			}
			Toggle(isOn: isCallstack) {
				Label("Callstack", systemImage: "text.line.last.and.arrowtriangle.forward")
			}
		}
		.toggleStyle(.button)
		.buttonStyle(.borderless)
		.labelStyle(.iconOnly)
		Divider()
		switch tab {
		case .program: VirtualProgramTab()
		case .callstack: VirtualCallstackTab()
		}
		Spacer()
	}

	private enum Tab: Int {
		case program = 1
		case callstack = 2
	}
}

@Observable final class VirtualMachineNavigation {
	var path: [VirtualMachineRoute] = []
	var selection: Set<VirtualMachineRoute> = []
}

public enum VirtualMachineRoute: Hashable {
	case frame(RawVirtualFrame)

	case unit(VirtualUnit)
	case function(VirtualFunction)
}
