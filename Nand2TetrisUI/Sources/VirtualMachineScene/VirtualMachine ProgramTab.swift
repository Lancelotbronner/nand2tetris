//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2TetrisKit

struct VirtualProgramTab: View {
	@Environment(ObservableVirtualMachine.self) private var vm
	@State private var selection: Set<Selection> = []

	private enum Selection: Hashable {
		case unit(VirtualUnit)
		case function(VirtualFunction)
	}

	public var body: some View {
		HSplitView {
			List(vm.units.sorted(), selection: $selection) { unit in
				Section {
					ForEach(unit.functions.sorted()) { function in
						VirtualFunctionCell(function)
							.tag(Selection.function(function))
							.listRowSeparator(.hidden)
					}
				} header: {
					VirtualUnitCell(unit)
						.tag(Selection.unit(unit))
				}
			}
			if let single = selection.first {
				switch single {
				case let .unit(unit): UnitContent(unit: unit)
				case let .function(function): FunctionContent(function: function)
				}
			} else {
				Spacer()
			}
		}
	}

	private enum Tab: Int {
		case unit
		case function
	}
}

private struct UnitContent: View {
	let unit: VirtualUnit

	var body: some View {
		List {
			Section("Statics") {
				ForEach(0..<unit.statics, id: \.self) { i in
					Text("Static \(i)")
						.listRowSeparator(.hidden)
				}
			}
		}
		.id(unit)
	}
}

private struct FunctionContent: View {
	let function: VirtualFunction

	var body: some View {
		ScrollView(.vertical) {
			LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
				Section("Locals") {
					ForEach(0..<function.locals, id: \.self) { i in
						Text("Local \(i)")
					}
				}
				Section("Commands") {
					ForEach(function.indices, id: \.self) { i in
						VirtualInstructionLabel(function[i])
					}
				}
			}
			.padding([.top, .horizontal])
		}
		.id(function)
	}
}

#Preview {
	VirtualProgramTab()
		.environment(ObservableVirtualMachine.preview)
}
