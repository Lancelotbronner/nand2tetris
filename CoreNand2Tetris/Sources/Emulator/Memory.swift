//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

@available(macOS 14, *)
@usableFromInline protocol _MemoryEmulator: RandomAccessCollection, MutableCollection where Index == Int {

	var vm: ObservableHackEmulator { get }
	var storage: [UInt16] { get nonmutating set }

}

@available(macOS 14, *)
extension _MemoryEmulator {

	@inlinable
	public subscript(position: Int) -> UInt16 {
		_read { yield storage[position] }
		nonmutating _modify { yield &storage[position] }
	}

	@inlinable
	public subscript(position: UInt16) -> UInt16 {
		_read { yield storage[Int(position)] }
		nonmutating _modify { yield &storage[Int(position)] }
	}

	@inlinable
	public var count: Int {
		ObservableHackEmulator.memory
	}

	@inlinable @inline(__always)
	public var capacity: Int {
		ObservableHackEmulator.memory
	}

	@inlinable @inline(__always)
	public var startIndex: Int {
		0
	}

	@inlinable @inline(__always)
	public var endIndex: Int {
		ObservableHackEmulator.memory - 1
	}

	@inlinable @inline(__always)
	public func index(before i: Int) -> Int {
		i - 1
	}

	@inlinable @inline(__always)
	public func index(after i: Int) -> Int {
		i + 1
	}

	@inlinable @inline(__always)
	public func load(_ data: [UInt16]) {
		for i in 0..<Swift.min(data.endIndex, ObservableHackEmulator.memory) {
			storage[i] = data[i]
		}
	}

	@inlinable @inline(__always)
	public func randomize() {
		for i in indices {
			storage[i] = .random(in: 0..<UInt16.max)
		}
	}

	@inlinable @inline(__always)
	public func makeIterator() -> Array<UInt16>.Iterator {
		storage.makeIterator()
	}

}
