//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2TetrisKit

public struct VirtualMachineContentView: View {
	@Environment(VirtualMachineNavigation.self) private var navigation
	let vm: ObservableVirtualMachine

	public init(_ machine: ObservableVirtualMachine) {
		self.vm = machine
	}

	public var body: some View {
		NavigationSplitView {
			VirtualMachineSidebar()
		} detail: {
			VirtualMachineView()
		}
		.inspector(isPresented: .constant(true)) {
			switch navigation.selection.first {
			case let .frame(frame): Text("Frame")
			case let .unit(unit): VirtualUnitCell(unit)
			case let .function(function): VirtualFunctionCell(function)
			case .none: EmptyView()
			}
		}
		.environment(vm)
	}
}
