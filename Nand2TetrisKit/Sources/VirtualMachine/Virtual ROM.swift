//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct VirtualROM: _VirtualMemory {

	public static let size = 32_768
	public static let min: UInt16 = 0
	public static let max: UInt16 = 32_768

	@usableFromInline let vm: VirtualMachine

	@inlinable public init(of vm: VirtualMachine) {
		self.vm = vm
	}

	@usableFromInline var storage: [UInt16] {
		_read { yield vm._rom }
		nonmutating _modify { yield &vm._rom }
	}

}
