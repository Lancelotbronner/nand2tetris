//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

import Observation

@Observable public final class VirtualMachine {

	/// The size of the virtual machine's ROM and RAM.
	public static let memory = 32_768

	public init() {
		_rom = .init(repeating: 0, count: VirtualMachine.memory)
		_ram = .init(repeating: 0, count: VirtualMachine.memory)
	}

	public init(
		rom: [UInt16] = Array(repeating: 0, count: VirtualMachine.memory),
		ram: [UInt16] = Array(repeating: 0, count: VirtualMachine.memory)
	) {
		_rom = rom
		_ram = ram
		_rom.reserveCapacity(VirtualMachine.memory)
		_ram.reserveCapacity(VirtualMachine.memory)
	}

	//MARK: - CPU

	/// The program counter.
	public var pc: UInt16 = 0

	/// The data register.
	public var d: UInt16 = 0

	/// The address register.
	public var a: UInt16 = 0

	/// The value pointed to by ``a``.
	public var m: UInt16 {
		//FIXME: Coroutine accessors and @ObservationIgnored: crashes the compiler without, errors with
//		_read { yield _ram[Int(a)] }
//		_modify { yield &_ram[Int(a)] }
		get { _ram[Int(a)] }
		set { _ram[Int(a)] = newValue }
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
			let o = VirtualMachine.alu(instruction, with: x, y)
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

	/// Information about the side effects of the previous cycle.
	public var flags = CycleFlags.none

	/// The current result of the ALU.
	@inlinable @inline(__always)
	public var o: Int16 {
		VirtualMachine.alu(instruction, with: x, y)
	}

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
	
	/// Calculates the X operand of the ALU operation.
	///
	/// - Parameters:
	///   - instruction: The instruction to compute.
	///   - x: The operand to calculate.
	@inlinable public static func alu(_ instruction: Instruction, x: inout Int16) {
		x = instruction.zx ? 0 : x
		x = instruction.nx ? ~x : x
	}

	/// Calculates the Y operand of the ALU operation.
	///
	/// - Parameters:
	///   - instruction: The instruction to compute.
	///   - x: The operand to calculate.
	@inlinable public static func alu(_ instruction: Instruction, y: inout Int16) {
		y = instruction.zy ? 0 : y
		y = instruction.ny ? ~y : y
	}

	/// Simulates an ALU operation, assumes a computation instruction.
	///
	/// - Parameters:
	///   - instruction: The instruction to compute.
	///   - x: The first operand.
	///   - y: The second operand.
	/// - Returns: The result of the operation.
	@inlinable public static func alu(_ instruction: Instruction, with x: Int16, _ y: Int16) -> Int16 {
		var x = instruction.zx ? 0 : x
		x = instruction.nx ? ~x : x

		var y = instruction.zy ? 0 : y
		y = instruction.ny ? ~y : y

		var o = instruction.f ? x+y : x&y;
		o = instruction.no ? ~o : o

		return o
	}

	//MARK: - Memory

	internal var _rom: [UInt16]

	/// The read-only memory of the computer
	@inlinable public var rom : VirtualROM {
		VirtualROM(of: self)
	}

	internal var _ram: [UInt16]

	/// The read-write memory of the computer
	@inlinable public var ram: VirtualRAM {
		VirtualRAM(of: self)
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
