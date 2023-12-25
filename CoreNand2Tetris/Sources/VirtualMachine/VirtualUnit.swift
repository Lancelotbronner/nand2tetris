//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

import Observation

public struct VirtualUnit {

	@usableFromInline let storage: ManagedBuffer<Header, UInt16>

	public init(_ name: String, statics: Int) {
		storage = ManagedBuffer.create(minimumCapacity: statics) { _ in
			Header(name: name, statics: statics)
		}
	}

	/// This unit's name
	@_transparent public var name: String {
		storage.header.name
	}

	/// The number of static locations in this unit
	@_transparent public var statics: Int {
		storage.header.statics
	}

	public subscript(static index: Int) -> UInt16 {
		@_transparent get {
			precondition(index < storage.header.statics, "Index out of bounds")
			return storage.withUnsafeMutablePointerToElements {
				$0[index]
			}
		}
		@_transparent nonmutating set {
			precondition(index < storage.header.statics, "Index out of bounds")
			storage.withUnsafeMutablePointerToElements {
				$0[index] = newValue
			}
		}
	}

	@Observable @usableFromInline final class Storage: ManagedBuffer<Header, UInt16> {
		public subscript(_ index: Int) -> UInt16 {
			get {
				access(keyPath: \.[index])
				return withUnsafeMutablePointerToElements {
					$0[index]
				}
			}
			set {
				withMutation(keyPath: \.[index]) {
					withUnsafeMutablePointerToElements {
						$0[index] = newValue
					}
				}
			}
		}
	}

	@usableFromInline struct Header {
		public let name: String
		public let statics: Int
	}

}

//MARK: - Identifiable & Hashable

extension VirtualUnit: Identifiable, Hashable {

	public var id: ObjectIdentifier {
		ObjectIdentifier(storage)
	}

	public static func == (lhs: VirtualUnit, rhs: VirtualUnit) -> Bool {
		lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

}

//MARK: - Sequence

extension VirtualUnit: Sequence {

	@_transparent public func makeIterator() -> Iterator {
		Iterator(storage: storage)
	}

	public struct Iterator: IteratorProtocol {
		@usableFromInline let storage: ManagedBuffer<Header, UInt16>
		@usableFromInline var i = 0

		@usableFromInline init(storage: ManagedBuffer<Header, UInt16>) {
			self.storage = storage
		}

		@_transparent public mutating func next() -> UInt16? {
			storage.withUnsafeMutablePointerToElements {
				defer { i += 1 }
				return $0[i]
			}
		}
	}

}

//MARK: - Collection

extension VirtualUnit: Collection {

	@_transparent public var startIndex: Int {
		0
	}

	@_transparent public var endIndex: Int {
		storage.header.statics
	}

	@_transparent public func index(after i: Int) -> Int {
		i + 1
	}

	public subscript(position: Int) -> UInt16 {
		@_transparent get {
			precondition(position < endIndex, "Index out of bounds")
			return storage.withUnsafeMutablePointerToElements {
				$0[position]
			}
		}
	}

}
