//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct VirtualMemory: RandomAccessCollection, MutableCollection {

	public static let size = 32_768
	public static let min: UInt16 = 0
	public static let max: UInt16 = 32_768

	@usableFromInline var storage: [UInt16]

	@inlinable @inline(__always)
	public init() {
		self.storage = Array<UInt16>(unsafeUninitializedCapacity: VirtualMemory.size) { buffer, count in
			buffer.initialize(repeating: 0)
			count = VirtualMemory.size
		}
	}

	@inlinable @inline(__always)
	public init(storage: [UInt16]) {
		self.storage = storage
		self.storage.reserveCapacity(VirtualMemory.size)
	}

	@inlinable @inline(__always)
	public subscript(position: Int) -> UInt16 {
		_read { yield storage[position] }
		_modify { yield &storage[position] }
	}

	@inlinable @inline(__always)
	public subscript(position: UInt16) -> UInt16 {
		_read { yield storage[Int(position)] }
		_modify { yield &storage[Int(position)] }
	}

	@inlinable @inline(__always)
	public var count: Int {
		VirtualMemory.size
	}

	@inlinable @inline(__always)
	public var capacity: Int {
		VirtualMemory.size
	}

	@inlinable @inline(__always)
	public var startIndex: Int {
		0
	}

	@inlinable @inline(__always)
	public var endIndex: Int {
		VirtualMemory.size
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
	public mutating func load(_ data: [UInt16]) {
		for i in 0..<Swift.min(data.endIndex, VirtualMemory.size) {
			storage[i] = data[i]
		}
	}

	@inlinable @inline(__always)
	public mutating func randomize() {
		for i in indices {
			storage[i] = .random(in: 0..<UInt16.max)
		}
	}

	@inlinable @inline(__always)
	public func makeIterator() -> Array<UInt16>.Iterator {
		storage.makeIterator()
	}

}
