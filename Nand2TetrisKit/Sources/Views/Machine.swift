//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct Machine: View {
	@Environment(VirtualMachine.self) private var vm

	public init() { }

	public var body: some View {
		HStack {
			GroupBox {
				ROM()
			} label: {
				Text("ROM")
					.font(.headline)
			}
			GroupBox {
				RAM()
			} label: {
				Text("RAM")
					.font(.headline)
			}
			VStack {
				Form {
					Section("SCREEN") {
						Screen()
					}
					Section("CPU") {
						CPU()
					}
					Section("ALU") {
						ALU()
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
	return Machine()
		.environment(vm)
}
#endif
