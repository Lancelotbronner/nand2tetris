//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct ROM: View {
	@Environment(\.pedantic) private var pedantic
	private let vm: VirtualMachine

	public init(_ vm: VirtualMachine) {
		self.vm = vm
	}

	private var values: AnyRandomAccessCollection<VirtualPointer> {
		AnyRandomAccessCollection(vm.rom.indices.lazy.map { i in
			VirtualPointer(i, in: vm.rom)
		})
	}

	public var body: some View {
		Table(values) {
			TableColumn("Address") { pointer in
				Text(pointer.address.description)
					.monospaced()
					.foregroundStyle(pointer.address == vm.pc ? Color.cyan : Color.primary)
			}
			.width(50)
			.alignment(.trailing)
			TableColumn("Instruction") { pointer in
				TextField("", value: pointer.binding, format: VirtualPointer.AssemblyFormat(pedantic: pedantic))
					.monospaced()
					.labelsHidden()
			}
		}
		.tableColumnHeaders(.hidden)
		.alternatingRowBackgrounds(.disabled)
	}
}

#Preview {
	let vm = VirtualMachine()
	vm.rom.randomize()
	vm.rom[4] = 0
	return Form {
		Section("ROM") {
			ROM(vm)
		}
	}
	.formStyle(.grouped)
}
#endif
