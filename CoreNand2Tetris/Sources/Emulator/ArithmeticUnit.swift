//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-08-28.
//

@available(macOS 14, *)
public struct ArithmeticUnitEmulator {

	@usableFromInline internal let vm: ObservableHackEmulator

	@usableFromInline internal init(of vm: ObservableHackEmulator) {
		self.vm = vm
	}

	@inlinable public var instruction: Instruction {
		_read { yield vm.instruction }
	}

}
