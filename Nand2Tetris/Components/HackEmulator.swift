//
//  HackEmulator.swift
//  Nand2Tetris
//
//  Created by Christophe Bronner on 2023-01-18.
//

import SwiftUI

struct HackEmulator: View {

	private var vm: VirtualMachine

	init(_ vm: VirtualMachine) {
		self.vm = vm
	}

	var body: some View {
		HStack {
			VStack {
				GroupBox("ROM") {
					VirtualROM()
				}
				GroupBox("PC") {
					Register(vm.pc)
				}
			}
			VStack {
				GroupBox("RAM") {
					VirtualRAM()
				}
				GroupBox("A") {
					Register(vm.a)
				}
				GroupBox("D") {
					Register(vm.d)
				}
			}
			VStack {
				GroupBox("Screen") {
					Text("TODO")
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
				VStack {
					GroupBox("X") {
						Register(vm.x)
					}
					GroupBox("Y") {
						Register(vm.y)
					}
					GroupBox("O") {
						Register(vm.o)
					}
				}
			}
		}
		.fontDesign(.monospaced)
		.environment(vm)
	}

}

#Preview {
	HackEmulator(VirtualMachine())
}
