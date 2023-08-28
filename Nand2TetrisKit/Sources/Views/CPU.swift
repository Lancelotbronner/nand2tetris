//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct CPU: View {
	@Environment(VirtualMachine.self) private var vm

	public init() { }

	public var body: some View {
		@Bindable var vm = vm
		HStack {
			Register("PC", value: $vm.pc)
			Register("A", value: $vm.a)
		}
		.textFieldStyle(.roundedBorder)
		HStack {
			Register("M", value: $vm.m)
			Register("D", value: $vm.d)
		}
		.textFieldStyle(.roundedBorder)
	}
}

#Preview {
	let vm = VirtualMachine()
	vm.rom[0] = Instruction(assign: .notY, to: .d, jump: .jmp).rawValue
	return Form {
		CPU()
	}
	.environment(vm)
	.formStyle(.grouped)
}
#endif
