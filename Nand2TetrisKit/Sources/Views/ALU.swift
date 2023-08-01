//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct ALU: View {
	@Environment(VirtualMachine.self) private var vm

	public var body: some View {
		HStack {
			field("X", value: vm.x)
			field("Y", value: vm.y)
		}
		HStack {
			Text(vm.instruction.description)
				.monospaced()
				.frame(maxWidth: .infinity, alignment: .center)
			field("O", value: vm.o)
		}
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
		ALU()
	}
	.environment(vm)
	.formStyle(.grouped)
}
#endif
