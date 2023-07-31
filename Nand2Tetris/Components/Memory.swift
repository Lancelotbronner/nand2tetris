//
//  ROM.swift
//  Nand2Tetris
//
//  Created by Christophe Bronner on 2023-01-18.
//

import SwiftUI

struct VirtualROM: View {

	@Environment(VirtualMachine.self) private var vm

	var body: some View {
		List(0 ..< 32_768) { i in
			LabeledContent(i.description) {
				Register(vm[rom: UInt16(i)])
			}
		}
	}

}

#Preview("ROM") {
	VirtualROM()
		.environment(VirtualMachine())
		.monospaced()
}

struct VirtualRAM: View {

	@Environment(VirtualMachine.self) private var vm

	var body: some View {
		List(0 ..< 32_768) { i in
			LabeledContent(i.description) {
				Register(vm[ram: UInt16(i)])
			}
		}
	}

}

#Preview("RAM") {
	VirtualRAM()
		.environment(VirtualMachine())
}
