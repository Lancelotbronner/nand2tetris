//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct VirtualMachine {

	//MARK: - CPU

	/// The program counter
	public var pc: UInt16 = 0

	/// The data register
	public var d: UInt16 = 0

	/// The address register
	public var a: UInt16 = 0

	/// The value pointed to by ``a``
	@inlinable @inline(__always)
	public var m: UInt16 {
		_read { yield ram[a] }
		_modify { yield &ram[a] }
	}

	@inlinable @inline(__always)
	public var instruction: Instruction {
		Instruction(rawValue: rom[pc])
	}

	@inlinable public mutating func cycle() {
		flags = CycleFlags(instruction)
		let result = UInt16(bitPattern: o)

		if (instruction.lt && ng || instruction.eq && zr || instruction.gt && !ng) {
			pc = a
			flags.formUnion(.jmp)
		} else {
			pc += 1
		}

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
	}

	//MARK: - ALU

	/// Wether the result is zero
	@usableFromInline internal var flags = CycleFlags.none

	@inlinable @inline(__always)
	public var x: Int16 {
		Int16(bitPattern: d)
	}

	@inlinable @inline(__always)
	public var y: Int16 {
		Int16(bitPattern: instruction.isIndirect ? m : a)
	}

	@inlinable @inline(__always)
	public var o: Int16 {
		mutating get {
			VirtualMachine.alu(instruction, with: x, y, flags: &flags)
		}
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

	//MARK: - ROM

	/// The read-only memory of the computer
	public var rom: VirtualMemory

	//MARK: - RAM

	/// The read-write memory of the computer
	public var ram: VirtualMemory

	public init() {
		rom = .init()
		ram = .init()
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
