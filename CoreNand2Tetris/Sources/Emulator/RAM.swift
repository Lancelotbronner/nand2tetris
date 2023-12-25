//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

@available(macOS 14, *)
public struct RandomAccessMemoryEmulator: _MemoryEmulator {

	public static let size = 32_768
	public static let min: UInt16 = 0
	public static let max: UInt16 = 32_768

	@usableFromInline let vm: ObservableHackEmulator

	@inlinable public init(of vm: ObservableHackEmulator) {
		self.vm = vm
	}

	@usableFromInline var storage: [UInt16] {
		_read { yield vm._ram }
		nonmutating _modify { yield &vm._ram }
	}

	//MARK: - IO Management

	/// The keyboard register.
	@inlinable @inline(__always)
	public var screen: ArraySlice<UInt16> {
		_read { yield storage[16384..<24576] }
		nonmutating _modify { yield &storage[16384..<24576] }
	}

	/// The keyboard register.
	@inlinable @inline(__always)
	public var keyboard: UInt16 {
		_read { yield storage[24576] }
		nonmutating _modify { yield &storage[24576] }
	}

}
