//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

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
