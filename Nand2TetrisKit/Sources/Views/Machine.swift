//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct Machine: View {
	@Environment(\.pedantic) private var pedantic
	@Bindable private var vm: VirtualMachine

	public init(_ vm: VirtualMachine) {
		self.vm = vm
	}

	public var body: some View {
		HStack {
			GroupBox {
				ROM(vm)
			} label: {
				Text("ROM")
					.font(.headline)
			}
			GroupBox {
				RAM(vm)
			} label: {
				Text("RAM")
					.font(.headline)
			}
			VStack {
				Form {
					Section("SCREEN") {
						Screen(vm)
					}
					Section("CPU") {
						Register("D", value: $vm.d)
							.textFieldStyle(.roundedBorder)
						Register("A", value: $vm.a)
							.textFieldStyle(.roundedBorder)
						Register("PC", value: $vm.pc)
							.textFieldStyle(.roundedBorder)
					}
					Section("ALU") {
						ALU(vm)
					}
				}
				.formStyle(.grouped)
			}
		}
	}
}

#Preview {
	let vm = VirtualMachine()
	vm.rom.randomize()
	vm.rom[4] = 0
	return Machine(vm)
}
#endif
