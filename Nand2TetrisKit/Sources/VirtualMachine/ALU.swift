//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

extension VirtualMachine {

	@inlinable public static func alu(_ instruction: Instruction, with x: Int16, _ y: Int16) -> Int16 {
		var tmp = CycleFlags.none
		let result = alu(instruction, with: x, y, flags: &tmp)
		return result
	}

	@inlinable public static func alu(_ instruction: Instruction, with x: Int16, _ y: Int16, flags: inout CycleFlags) -> Int16 {
		var x = x
		var y = y

		// Compute X
		if (instruction.zx) {
			x = 0;
		}
		if (instruction.nx) {
			x = ~x;
		}

		// Compute Y
		if (instruction.zy) {
			y = 0;
		}
		if (instruction.ny) {
			y = ~y;
		}

		// Compute Out
		var o = instruction.isAdd ? x+y : x&y;
		if (instruction.no) {
			o = ~o;
		}

		// Update flags
		if o == 0 {
			flags.formUnion(.zr)
		}
		if o < 0 {
			flags.formUnion(.ng)
		}

		return o
	}

}

public struct CycleFlags: RawRepresentable, OptionSet {

	public var rawValue: UInt8

	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}

	public static let none = CycleFlags([])

	/// Wether the ALU computed a 0
	public static let zr = CycleFlags(rawValue: 0x1)

	/// Wether the ALU computed a negative value
	public static let ng = CycleFlags(rawValue: 0x2)

}
