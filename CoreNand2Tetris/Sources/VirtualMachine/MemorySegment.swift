//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

public enum MemorySegment {

	/// Stores the function’s arguments.
	case argument

	/// Stores the function’s local variables.
	case local

	/// Stores static variables shared by all functions in the same unit.
	case `static`

	/// Pseudo-segment that holds all the constants in the range `0...32767`.
	case constant

	/// General-purpose segment. Can be made to correspond to different areas in the heap via ``pointer``.
	case this

	/// General-purpose segment. Can be made to correspond to different areas in the heap via ``pointer``.
	case that

	/// A two-entry segment that holds the base addresses of the ``this`` and ``that`` segments.
	case pointer

	/// Fixed eight-entry segment that holds temporary variables for general use.
	case temp

}

extension MemorySegment {

	@inlinable public static func clear(storage: inout [UInt16]) {
		storage.removeAll(keepingCapacity: true)
	}

	@inlinable public static func read(from storage: [UInt16], at index: UInt16) -> UInt16 {
		let windex = Int(index)
		guard windex < storage.count else { return 0 }
		return storage[windex]
	}

	@inlinable public static func write(_ newValue: UInt16, to storage: inout [UInt16], at index: UInt16) {
		let windex = Int(index)

		guard windex >= storage.count else {
			storage[windex] = newValue
			return
		}

		storage.reserveCapacity(windex + 1)
		while (windex < storage.count) {
			storage.append(0)
		}
		storage.append(newValue)
	}

}
