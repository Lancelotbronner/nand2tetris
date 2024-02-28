//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

import Observation

@available(macOS 14, *)
@Observable public final class ObservableMachine: Machine {

	public init(rom: Int = Hack.memory, ram: Int = Hack.memory) {
		self.rom = Array(repeating: 0, count: rom)
		self.ram = Array(repeating: 0, count: ram)
	}

	public var pc: UInt16 = 0
	public var d: UInt16 = 0
	public var a: UInt16 = 0

	public var flags = CycleFlags.none

	public var rom: [UInt16]
	public var ram: [UInt16]

}
