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
		let function = VirtualFunction("fibonacci", into: unit, args: 1, locals: 0) {
			Command.push(.argument, offset: 0)
			Command.push(constant: 2)
			Command.lt

			Command.ifr(1)
			Command.gotor(2)
			// then:
			Command.push(.argument, offset: 0)
			Command.return

			Command.push(.argument, offset: 0)
			Command.push(constant: 2)
			Command.sub
			Command.call($0)
			Command.push(.argument, offset: 0)
			Command.push(constant: 1)
			Command.sub
			Command.call($0)
			Command.add
			Command.return
		}
		let main = VirtualFunction("Sys.init", into: unit) {
			Command.push(constant: 4)
			Command.call(function)
		}
		vm.insert(function)
		vm.insert(main)
		// prime the VM
		vm.call(main)
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
