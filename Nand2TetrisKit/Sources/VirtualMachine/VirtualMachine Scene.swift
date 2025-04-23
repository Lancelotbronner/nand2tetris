//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2TetrisKit

public struct VirtualMachineScene: Scene {
	@State private var vm = ObservableVirtualMachine()
	@State private var navigation = VirtualMachineNavigation()

	public init() {
		let unit = VirtualUnit("Fibonacci", statics: 0)
		let function = VirtualFunction("fibonacci", into: unit, locals: 0) {
			VirtualInstruction.push(.argument, offset: 0)
			VirtualInstruction.push(constant: 2)
			VirtualInstruction.lt

			VirtualInstruction.ifr(1)
			VirtualInstruction.gotor(2)
			// then:
			VirtualInstruction.push(argument: 0)
			VirtualInstruction.return

			VirtualInstruction.push(argument: 0)
			VirtualInstruction.push(constant: 2)
			VirtualInstruction.sub
			VirtualInstruction.call($0, 1)
			VirtualInstruction.push(argument: 0)
			VirtualInstruction.push(constant: 1)
			VirtualInstruction.sub
			VirtualInstruction.call($0, 1)
			VirtualInstruction.add
			VirtualInstruction.return
		}
		let main = VirtualFunction("Sys.init", into: unit) {
			VirtualInstruction.push(constant: 4)
			VirtualInstruction.call(function, 1)
		}
		vm.insert(function)
		vm.insert(main)
		// prime the VM
		vm.call(main, 0)
	}

	public var body: some Scene {
		Window("Virtual Machine", id: "vm") {
			VirtualMachineContentView(vm)
				.environment(vm)
				.environment(navigation)
		}
		.keyboardShortcut("3", modifiers: [.shift, .command])
	}
}
