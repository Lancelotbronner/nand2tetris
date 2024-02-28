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
	@State private var path: [VirtualMachineRoute] = []
	let vm: ObservableVirtualMachine

	public init(_ machine: ObservableVirtualMachine) {
		self.vm = machine
	}

	public var body: some View {
		NavigationSplitView {
			VirtualMachineSidebar()
				.onChange(of: navigation.selection) {
					guard 
						navigation.selection.count == 1,
						let route = navigation.selection.first
					else { return }
					
					path.removeAll(keepingCapacity: true)
					DispatchQueue.main.async {
						path.append(route)
					}
				}
		} detail: {
			NavigationStack(path: $path) {
				VirtualMachineView()
					.navigationDestination(for: VirtualMachineRoute.self) {
						switch $0 {
						case let .frame(frame): Text("Frame")
						case let .unit(unit): VirtualUnitCell(unit)
						case let .function(function): VirtualFunctionCell(function)
						}
					}
			}
		}
		.environment(vm)
	}
}
