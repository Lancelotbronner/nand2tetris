//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-04-19.
//

extension Sequence {

	@inlinable
	public func sorted<T: Comparable>(by field: KeyPath<Element, T>, using compare: (T, T) -> Bool) -> [Element] {
		sorted { compare($0[keyPath: field], $1[keyPath: field]) }
	}

	@inlinable
	public func sorted(by field: KeyPath<Element, some Comparable>) -> [Element] {
		sorted(by: field, using: <)
	}

}
