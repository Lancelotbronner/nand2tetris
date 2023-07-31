//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct Instruction: RawRepresentable {

	public let rawValue: UInt16

	public init(rawValue: UInt16) {
		self.rawValue = rawValue
	}

	//MARK: - Adressing Instruction

	public init(adressing value: UInt16) {
		self.init(rawValue: value & 0x7FFF)
	}

	/// Wether the instruction is an addressing
	public var isAdressing: Bool {
		rawValue & 0x8000 == 0
	}

	/// The value literal of an adressing instruction
	public var value: UInt16 {
		rawValue & 0x7FFF
	}

	//MARK: - Computing Instruction

	@_transparent public init(assign computation: Computation, to destination: Destination = .none, jump: Jump = .none) {
		self.init(rawValue: computation.rawValue | destination.rawValue | jump.rawValue)
	}

	/// Wether the instruction is a computation
	public var isComputing: Bool {
		!isAdressing
	}

	public var computation: Computation {
		Computation(mask: rawValue)
	}

	/// Wether the instruction is indirect (M[A] rather than A)
	public var i: Bool {
		computation.contains(.i)
	}

	/// Wether to zero the first operand
	public var zx: Bool {
		computation.contains(.zx)
	}

	/// Wether to invert the first operand
	public var nx: Bool {
		rawValue & 0x400 != 0
	}

	/// Wether to zero the second operand
	public var zy: Bool {
		rawValue & 0x200 != 0
	}

	/// Wether to invert the second operand
	public var ny: Bool {
		rawValue & 0x100 != 0
	}

	/// Wether to ADD or AND the operands
	public var f: Bool {
		rawValue & 0x80 != 0
	}

	/// Wether to invert the output
	public var no: Bool {
		rawValue & 0x40 != 0
	}

	public var destination: Destination {
		Destination(mask: rawValue)
	}

	/// Wether to store the result to memory (M[A])
	public var m: Bool {
		rawValue & 0x20 != 0
	}

	/// Wether to store the result to the data register (D)
	public var d: Bool {
		rawValue & 0x10 != 0
	}

	/// Wether to store the result in the address register (A)
	public var a: Bool {
		rawValue & 0x8 != 0
	}

	public var jump: Jump {
		Jump(mask: rawValue)
	}

	/// Jump if the output is greater than 0
	public var gt: Bool {
		rawValue & 0x4 != 0
	}

	/// Jump if the output is equal to 0
	public var eq: Bool {
		rawValue & 0x2 != 0
	}

	/// Jump if the output is lower than 0
	public var lt: Bool {
		rawValue & 0x1 != 0
	}

	//MARK: - Shortcuts

	/// Wether the instruction is indirect (M[A] rather than A)
	@_transparent public var isIndirect: Bool {
		i
	}

	/// Wether a computation instruction will ADD operands together
	@_transparent public var isAdd: Bool {
		f
	}

	/// Wether a computation instruction will AND operands together
	@_transparent public var isAnd: Bool {
		!f
	}

}

//MARK: - Integrations

extension Instruction: ExpressibleByIntegerLiteral {

	public init(integerLiteral value: UInt16) {
		self.init(rawValue: value)
	}

}
