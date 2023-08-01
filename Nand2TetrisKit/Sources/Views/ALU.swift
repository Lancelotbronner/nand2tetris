//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct ALU: View {
	@Bindable private var vm: VirtualMachine

	public init(_ vm: VirtualMachine) {
		self.vm = vm
	}

	public var body: some View {
		field("X", value: vm.x)
		field("Y", value: vm.y)
		Text(vm.instruction.description)
			.monospaced()
			.foregroundStyle(.secondary)
		field("O", value: vm.o)
	}

	private func field(_ title: LocalizedStringKey, value: Int16) -> some View {
		LabeledContent {
			if vm.instruction.f {
				Text(String(vm.x))
			} else {
				Text(UInt16(vm.x), format: VirtualPointer.SignedFormat(pedantic: true))
			}
		} label: {
			Text(title)
		}
	}
}

#Preview {
	let vm = VirtualMachine()
	vm.rom[0] = Instruction(assign: .notY, to: .d, jump: .jmp).rawValue
	return Form {
		ALU(vm)
	}
	.formStyle(.grouped)
}
#endif
