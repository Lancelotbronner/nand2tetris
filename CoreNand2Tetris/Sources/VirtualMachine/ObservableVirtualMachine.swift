//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

import Observation

@available(macOS 14.0, *)
@Observable public final class ObservableVirtualMachine: VirtualMachine {

	public init() { }

	public var units: Set<VirtualUnit> = []
	public var functions: Set<VirtualFunction> = []

	public func insert(_ function: VirtualFunction) {
		functions.insert(function)
		units.insert(function.unit)
	}

	public var pc = 0
	public var frames: [RawVirtualFrame] = []

	public var heap: [Int16] = []
	public var stack: [Int16] = []

	public var arg = 0
	public var lcl = 0
	public var this = 0
	public var that = 0
	public var temp0 = 0
	public var temp1 = 0
	public var temp2 = 0
	public var temp3 = 0
	public var temp4 = 0
	public var temp5 = 0
	public var temp6 = 0
	public var temp7 = 0
}
