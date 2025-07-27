//
//  Sidebar.swift
//  VirtualMachineUI
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2TetrisKit

struct VirtualMachineSidebar: View {
	var body: some View {
		TabView {
			Tab("Device", systemImage: "computer") {

			}
			TabSection("Debugging") {
				Tab("Memory", systemImage: "ram") {
					
				}
				Tab("Callstack", systemImage: "text.line.last.and.arrowtriangle.forward") {
					VirtualCallstackTab()
				}
			}
			TabSection("Program") {
				Tab("Program", systemImage: "doc.badge.gearshape") {
					VirtualProgramTab()
				}
			}
		}
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

#Preview {
	VirtualMachineSidebar()
		.tabViewStyle(.sidebarAdaptable)
}
