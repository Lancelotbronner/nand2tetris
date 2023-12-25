//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

public struct IntermediateUnit {
	/// Shared symbols across the unit
	public var `static`: [String] = []

	/// Functions declared within the unit
	public var functions: [String : IntermediateFunction] = [:]
}
