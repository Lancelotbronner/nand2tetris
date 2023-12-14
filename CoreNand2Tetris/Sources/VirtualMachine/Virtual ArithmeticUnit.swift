//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-08-28.
//

@available(macOS 14, *)
public struct VirtualArithmeticUnit {

	@usableFromInline internal let vm: VirtualMachine

	@usableFromInline internal init(of vm: VirtualMachine) {
		self.vm = vm
	}

	@inlinable public var instruction: Instruction {
		_read { yield vm.instruction }
	}

}
