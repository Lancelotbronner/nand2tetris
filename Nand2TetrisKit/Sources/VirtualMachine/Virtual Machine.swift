//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

import Observation

@Observable public final class VirtualMachine {

	public init() { }

	//MARK: - CPU

	/// The program counter.
	public var pc: UInt16 = 0

	/// The data register.
	public var d: UInt16 = 0

	/// The address register.
	public var a: UInt16 = 0

	/// The value pointed to by ``a``.
	@ObservationIgnored @inlinable @inline(__always)
	public var m: UInt16 {
		_read { yield ram[a] }
		_modify { yield &ram[a] }
	}

	/// The instruction to be executed.
	@inlinable @inline(__always)
	public var instruction: Instruction {
		Instruction(rawValue: rom[pc])
	}
	
	/// Executes a single CPU cycle.
	public func cycle() {
		flags = CycleFlags(instruction)
		switch instruction.isAddressing {
		case true:
			a = instruction.rawValue
			flags.formUnion(.a)
			pc += 1
		case false:
			VirtualMachine.alu(instruction, with: x, y, into: &o, flags: &flags)
			let result = UInt16(bitPattern: o)

			if (instruction.m) {
				withMutation(keyPath: \.m) {
					m = result;
					flags.formUnion(.m)
				}
			}
			if (instruction.d) {
				d = result;
				flags.formUnion(.d)
			}
			if (instruction.a) {
				a = result;
				flags.formUnion(.a)
			}

			if (instruction.lt && ng || instruction.eq && zr || instruction.gt && !ng) {
				pc = a
				flags.formUnion(.jmp)
			} else {
				pc += 1
			}
		}
	}

	//MARK: - ALU

	/// Information about the side effects of the previous cycle.
	public var flags = CycleFlags.none

	/// The result of the last cycle.
	public var o: Int16 = 0

	/// The first operand of the current instruction.
	@inlinable @inline(__always)
	public var x: Int16 {
		Int16(bitPattern: d)
	}

	/// The second operand of the current instruction.
	@inlinable @inline(__always)
	public var y: Int16 {
		Int16(bitPattern: instruction.isIndirect ? m : a)
	}

	/// Wether the ALU resulted in a zero
	@inlinable @inline(__always)
	public var zr: Bool {
		flags.contains(.zr)
	}

	/// Wether the ALU resulted in a negative value
	@inlinable @inline(__always)
	public var ng: Bool {
		flags.contains(.ng)
	}
	
	/// Simulates an ALU operation, assumes a computation instruction.
	///
	/// - Parameters:
	///   - instruction: The instruction to compute.
	///   - x: The first operand.
	///   - y: The second operand.
	/// - Returns: The result of the operation.
	@inlinable public static func alu(_ instruction: Instruction, with x: Int16, _ y: Int16) -> Int16 {
		var tmp = CycleFlags.none
		var result: Int16 = 0
		alu(instruction, with: x, y, into: &result, flags: &tmp)
		return result
	}

	/// Simulates an ALU operation, assumes a computation instruction.
	///
	/// - Parameters:
	///   - instruction: The instruction to compute.
	///   - x: The first operand.
	///   - y: The second operand.
	///   - flags: The receiver for the ``zr`` and ``ng`` flags.
	/// - Returns: The result of the operation.
	@inlinable public static func alu(_ instruction: Instruction, with x: Int16, _ y: Int16, into output: inout Int16, flags: inout CycleFlags) {
		var x = instruction.zx ? 0 : x
		x = instruction.nx ? ~x : x

		var y = instruction.zy ? 0 : y
		y = instruction.ny ? ~y : y

		var o = instruction.f ? x+y : x&y;
		o = instruction.no ? ~o : o

		flags.formUnion(o == 0 ? .zr : .none)
		flags.formUnion(o < 0 ? .ng : .none)

		output = o
	}

	//MARK: - ROM

	/// The read-only memory of the computer
	public var rom = VirtualMemory()

	//MARK: - RAM

	/// The read-write memory of the computer
	public var ram = VirtualMemory()

	//MARK: - IO

	/// The keyboard register.
	@ObservationIgnored @inlinable @inline(__always)
	public var screen: ArraySlice<UInt16> {
		ram.storage[16384..<24576]
	}

	/// The keyboard register.
	@ObservationIgnored @inlinable @inline(__always)
	public var keyboard: UInt16 {
		_read { yield ram[24576] }
		_modify { yield &ram[24576] }
	}

}

public struct CycleFlags: RawRepresentable, OptionSet {

	public var rawValue: UInt8

	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}

	@inlinable @inline(__always)
	init(_ instruction: Instruction) {
		let i = instruction.rawValue & 0x1000 >> 10
		rawValue = UInt8(i)
	}

	public static let none = CycleFlags([])

	/// Wether the ALU computed a 0
	public static let zr = CycleFlags(rawValue: 0x1)

	/// Wether the ALU computed a negative value
	public static let ng = CycleFlags(rawValue: 0x2)

	/// Wether RAM was read from
	public static let i = CycleFlags(rawValue: 0x4)

	/// Wether the address register was written to
	public static let a = CycleFlags(rawValue: 0x8)

	/// Wether RAM was written to
	public static let m = CycleFlags(rawValue: 0x10)

	/// Wether the data register was written to
	public static let d = CycleFlags(rawValue: 0x20)

	/// Wether the instruction jumped
	public static let jmp = CycleFlags(rawValue: 0x40)

}
