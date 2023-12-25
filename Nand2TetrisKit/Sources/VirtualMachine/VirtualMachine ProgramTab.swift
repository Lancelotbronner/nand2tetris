//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2Tetris

struct VirtualProgramTab: View {
	@Environment(ObservableVirtualMachine.self) private var vm
	@State private var tab = Tab.unit
	@State private var units: [VirtualUnit] = []
	@State private var functions: [VirtualFunction] = []

	private var byUnit: Binding<Bool> {
		Binding { tab == .unit } set: {
			if $0 { tab = .unit }
		}
	}

	private var byFunction: Binding<Bool> {
		Binding { tab == .function } set: {
			if $0 { tab = .function }
		}
	}

	public var body: some View {
		HStack {
			Spacer()
			Toggle(isOn: byUnit) {
				Text("Units")
					.badge(vm.units.count)
			}
			Toggle(isOn: byFunction) {
				Text("Functions")
					.badge(vm.functions.count)
			}
			Spacer()
		}
		.tint(.blue)
		.toggleStyle(.button)
		.buttonStyle(.accessoryBar)
		Divider()
		switch tab {
		case .unit: ProgramByUnit($units)
		case .function: ProgramByFunction($functions)
		}
	}

	private enum Tab: Int {
		case unit
		case function
	}
}

private struct ProgramByUnit: View {
	@Environment(ObservableVirtualMachine.self) private var vm
	@Environment(VirtualMachineNavigation.self) private var navigation
	@Binding private var units: [VirtualUnit]

	init(_ units: Binding<[VirtualUnit]>) {
		_units = units
	}

	private func sort(_ functions: Set<VirtualFunction>) -> [VirtualFunction] {
		functions.sorted { $0.name < $1.name }
	}

	var body: some View {
		@Bindable var navigation = navigation
		List(selection: $navigation.selection) {
			ForEach(units) { unit in
				DisclosureGroup {
					ForEach(sort(unit.functions)) { function in
						VirtualFunctionCell(function)
							.tag(VirtualMachineRoute.function(function))
					}
				} label: {
					VirtualUnitCell(unit)
						.tag(VirtualMachineRoute.unit(unit))
				}
			}
		}
		.onAppear {
			if units.isEmpty {
				units = vm.units.sorted { $0.name < $1.name }
			}
		}
	}
}

private struct ProgramByFunction: View {
	@Environment(ObservableVirtualMachine.self) private var vm
	@Environment(VirtualMachineNavigation.self) private var navigation
	@Binding private var functions: [VirtualFunction]

	init(_ functions: Binding<[VirtualFunction]>) {
		_functions = functions
	}

	var body: some View {
		@Bindable var navigation = navigation
		List(selection: $navigation.selection) {
			ForEach(functions) { function in
				VirtualFunctionCell(function)
					.tag(VirtualMachineRoute.function(function))
			}
		}
		.onAppear {
			if functions.isEmpty {
				functions = vm.functions.sorted { $0.name < $1.name }
			}
		}
	}
}
