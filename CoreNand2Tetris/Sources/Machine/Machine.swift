//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-02-28.
//

public protocol Machine: AnyObject {

	//MARK: - CPU

	/// The program counter.
	var pc: UInt16 { get set }

	/// The data register.
	var d: UInt16  { get set }

	/// The address register.
	var a: UInt16 { get set }

	//MARK: - ALU

	//MARK: - Flags

	/// Information about the side effects of the previous cycle.
	var flags: CycleFlags { get set }

	//MARK: - Memory

	/// The read-only memory of the computer
	var rom: [UInt16] { get set }

	/// The read-write memory of the computer
	var ram: [UInt16] { get set }

}

extension Machine {

	//MARK: - CPU

	/// The instruction to be executed.
	@inlinable @inline(__always)
	public var instruction: Instruction {
		Instruction(rawValue: rom[Int(pc)])
	}

	/// The value pointed to by ``a``.
	public var m: UInt16 {
		_read { yield ram[Int(a)] }
		_modify { yield &ram[Int(a)] }
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
			let o = o
			flags.formUnion(o == 0 ? .zr : .none)
			flags.formUnion(o < 0 ? .ng : .none)
			let result = UInt16(bitPattern: o)

			if (instruction.m) {
				m = result;
				flags.formUnion(.m)
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

	/// The first operand of the current instruction, always the ``d`` register.
	@inlinable public var x: Int16 {
		Int16(bitPattern: d)
	}

	/// The first operand of the current ALU operation, with ``Instruction/zx`` and ``Instruction/nx`` applied.
	@inlinable public var lhs: Int16 {
		var x = x
		x = instruction.zx ? 0 : x
		x = instruction.nx ? ~x : x
		return x
	}

	/// The second operand of the current instruction, either the ``a`` or ``m`` register according to ``Instruction/i``.
	@inlinable public var y: Int16 {
		Int16(bitPattern: instruction.i ? m : a)
	}

	/// The second operand of the current ALU operation, with ``Instruction/zy`` and ``Instruction/ny`` applied.
	@inlinable public var rhs: Int16 {
		var y = y
		y = instruction.zy ? 0 : y
		y = instruction.ny ? ~y : y
		return y
	}

	/// The character of the current ALU operation, either `+` or `&` according to ``Instruction/f``.
	@inlinable public var op: Character {
		instruction.f ? "+" : "&"
	}

	/// The result of the current ALU operation **before** applying ``Instruction/no``.
	@inlinable public var result: Int16 {
		instruction.f ? lhs + rhs : lhs & rhs;
	}

	/// The current result of the ALU.
	@inlinable public var o: Int16 {
		instruction.no ? ~result : result
	}

	//MARK: - Flags

	/// Whether the ALU resulted in a zero
	@inlinable @inline(__always)
	public var zr: Bool {
		flags.contains(.zr)
	}

	/// Whether the ALU resulted in a negative value
	@inlinable @inline(__always)
	public var ng: Bool {
		flags.contains(.ng)
	}

	//MARK: - Memory

	/// The keyboard register.
	@inlinable @inline(__always)
	public var screen: ArraySlice<UInt16> {
		_read { yield ram[16384..<24576] }
		_modify { yield &ram[16384..<24576] }
	}

	/// The keyboard register.
	@inlinable @inline(__always)
	public var keyboard: UInt16 {
		_read { yield ram[24576] }
		_modify { yield &ram[24576] }
	}

}

//MARK: - Cycle Flags

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

	/// Whether the ALU computed a 0
	public static let zr = CycleFlags(rawValue: 0x1)

	/// Whether the ALU computed a negative value
	public static let ng = CycleFlags(rawValue: 0x2)

	/// Whether RAM was read from
	public static let i = CycleFlags(rawValue: 0x4)

	/// Whether the address register was written to
	public static let a = CycleFlags(rawValue: 0x8)

	/// Whether RAM was written to
	public static let m = CycleFlags(rawValue: 0x10)

	/// Whether the data register was written to
	public static let d = CycleFlags(rawValue: 0x20)

	/// Whether the instruction jumped
	public static let jmp = CycleFlags(rawValue: 0x40)

}
