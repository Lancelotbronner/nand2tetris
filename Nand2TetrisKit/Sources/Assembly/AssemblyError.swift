//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public enum AssemblyError: Error {
	case expectedInteger(Substring)
	case outOfRange(UInt16, min: UInt16, max: UInt16)
	case invalidDestination(Substring, pedantic: Bool)
	case invalidJump(Substring, pedantic: Bool)
	case invalidComputation(Substring, pedantic: Bool)


}

#if canImport(Foundation)
import Foundation

extension AssemblyError: LocalizedError {

	//TODO: Localizable assembly error

}
#endif
