//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-19.
//

extension Bool {

	@_transparent public var not: Bool {
		!self
	}

}

extension Character {

	var isPedanticInteger: Bool {
		("0"..."9").contains(self)
	}

	var isExtendedInteger: Bool {
		isPedanticInteger || self == "_" || self == "'"
	}

	func isInteger(pedantic: Bool) -> Bool {
		pedantic ? isPedanticInteger : isExtendedInteger
	}

}

extension MutableCollection where Element: FixedWidthInteger {

	public mutating func randomize() {
		for i in indices {
			self[i] = Element.random(in: Element.min...Element.max)
		}
	}

}
