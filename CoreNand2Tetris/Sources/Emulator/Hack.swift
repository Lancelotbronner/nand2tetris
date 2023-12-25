//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

@available(macOS 14, *)
public protocol Hack {
	
	//MARK: - CPU

	/// The program counter.
	var pc: UInt16 { get }

	/// The data register.
	var d: UInt16 { get }

	/// The address register.
	var a: UInt16 { get }

	/// The value pointed to by ``a``.
	var m: UInt16 { get }

	/// Executes a single CPU cycle.
	func cycle()

	//MARK: - ALU

	/// The first operand of the current instruction, always the ``d`` register.
	var x: Int16 { get }

	/// The first operand of the current ALU operation, with ``Instruction/zx`` and ``Instruction/nx`` applied.
	var lhs: Int16 { get }

	/// The second operand of the current instruction, either the ``a`` or ``m`` register according to ``Instruction/i``.
	var y: Int16 { get }

	/// The second operand of the current ALU operation, with ``Instruction/zy`` and ``Instruction/ny`` applied.
	var rhs: Int16 { get }

	/// The character of the current ALU operation, either `+` or `&` according to ``Instruction/f``.
	var op: Character { get }

	/// The result of the current ALU operation **before** applying ``Instruction/no``.
	var result: Int16 { get }

	/// The current result of the ALU.
	var o: Int16 { get }

	//MARK: - Flags

	/// Information about the side effects of the previous cycle.
	var flags: CycleFlags { get }

	/// Whether the ALU resulted in a zero
	var zr: Bool { get }

	/// Whether the ALU resulted in a negative value
	var ng: Bool { get }

	//MARK: - Memory

	/// The read-only memory of the computer
	var rom: ReadOnlyMemoryEmulator { get }

	/// The read-write memory of the computer
	var ram: RandomAccessMemoryEmulator { get }

}

@available(macOS 14, *)
extension Hack {

	/// The instruction to be executed.
	@_transparent public var instruction: Instruction {
		Instruction(rawValue: rom[pc])
	}

}
