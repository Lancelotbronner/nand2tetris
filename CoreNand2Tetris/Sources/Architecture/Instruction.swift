//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct Instruction: RawRepresentable, Hashable {

	public static let nop = Instruction(assign: .zero)

	public let rawValue: UInt16

	public init(rawValue: UInt16) {
		self.rawValue = rawValue
	}

	public init(rawValue: Int16) {
		self.rawValue = UInt16(bitPattern: rawValue)
	}

	//MARK: - Adressing Instruction

	public init(addressing value: UInt16) {
		self.init(rawValue: value & 0x7FFF)
	}

	/// Whether the instruction is an addressing
	public var isAddressing: Bool {
		rawValue & 0x8000 == 0
	}

	/// The value literal of an adressing instruction
	public var immediate: UInt16 {
		rawValue & 0x7FFF
	}

	//MARK: - Computing Instruction

	@inlinable @inline(__always)
	public init(assign computation: Computation, to destination: Destination = .null, jump: Jump = .none) {
		self.init(rawValue: 0xE000 | computation.rawValue | destination.rawValue | jump.rawValue)
	}

	/// Whether the instruction is a computation
	public var isComputing: Bool {
		!isAddressing
	}

	/// The computation of this instruction
	public var computation: Computation {
		Computation(mask: rawValue)
	}

	/// Whether the instruction is indirect (`M[A]` rather than `A`)
	public var i: Bool {
		computation.contains(.i)
	}

	/// Whether to zero the first operand
	public var zx: Bool {
		computation.contains(.zx)
	}

	/// Whether to invert the first operand
	public var nx: Bool {
		rawValue & 0x400 != 0
	}

	/// Whether to zero the second operand
	public var zy: Bool {
		rawValue & 0x200 != 0
	}

	/// Whether to invert the second operand
	public var ny: Bool {
		rawValue & 0x100 != 0
	}

	/// Whether to `ADD` or `AND` the operands
	public var f: Bool {
		rawValue & 0x80 != 0
	}

	/// Whether to invert the output
	public var no: Bool {
		rawValue & 0x40 != 0
	}

	/// The destination of this instruction
	public var destination: Destination {
		Destination(mask: rawValue)
	}

	/// Whether to store the result in the address register (A)
	public var a: Bool {
		destination.contains(.a)
	}

	/// Whether to store the result to memory (M[A])
	public var m: Bool {
		destination.contains(.m)
	}

	/// Whether to store the result to the data register (D)
	public var d: Bool {
		destination.contains(.d)
	}

	/// The jump of this instruction
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

	/// Whether the instruction is indirect (`M[A]` rather than `A`)
	@_transparent public var isIndirect: Bool {
		i
	}

	/// Whether a computation instruction will ADD operands together
	@_transparent public var isAdd: Bool {
		f
	}

	/// Whether a computation instruction will AND operands together
	@_transparent public var isAnd: Bool {
		!f
	}

}

extension Instruction: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {

	public init(integerLiteral value: UInt16) {
		self.init(rawValue: value)
	}

	public init(stringLiteral value: String) {
		self.init(value)!
	}

	public var binary: String {
		let description = String(rawValue, radix: 2)
		let padding = String(repeating: "0", count: 16 - description.count)
		return padding + description
	}

	public var hex: String {
		let description = String(rawValue, radix: 16)
		let padding = String(repeating: "0", count: 4 - description.count)
		return padding + description
	}

}
