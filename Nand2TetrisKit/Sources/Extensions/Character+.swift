//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-19.
//

extension Character {

	public var isPedanticInteger: Bool {
		("0"..."9").contains(self)
	}

	public var isExtendedInteger: Bool {
		isPedanticInteger || self == "_" || self == "'"
	}

	public func isInteger(pedantic: Bool) -> Bool {
		pedantic ? isPedanticInteger : isExtendedInteger
	}

}
