//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

import Nand2Tetris

#if canImport(SwiftUI)
import SwiftUI

public struct CPUView: View {
	@Environment(ObservableHackEmulator.self) private var vm

	public init() { }

	public var body: some View {
		@Bindable var vm = vm
		HStack {
			Register("PC", value: $vm.pc)
			Register("D", value: $vm.d)
		}
		.textFieldStyle(.roundedBorder)
		HStack {
			Register("A", value: $vm.a)
			Register("M", value: $vm.m)
		}
		.textFieldStyle(.roundedBorder)
		vm.instruction
			.fixedSize(horizontal: false, vertical: true)
	}
}

#Preview {
	let vm = ObservableHackEmulator()
	vm.rom[0] = Instruction(assign: .notY, to: .d, jump: .jmp).rawValue
	return Form {
		CPUView()
	}
	.environment(vm)
	.formStyle(.grouped)
}
#endif
