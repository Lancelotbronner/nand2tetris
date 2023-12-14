//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-19.
//

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
