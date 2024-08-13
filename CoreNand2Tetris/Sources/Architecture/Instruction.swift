//
//  Instruction.swift
//  CoreNand2Tetris
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct Instruction: RawRepresentable, Hashable {

	public static let nop = Instruction(assign: .zero)
	public static let zero = Instruction(rawValue: 0)

	public var rawValue: UInt16

	@inlinable
	public init(rawValue: UInt16) {
		self.rawValue = rawValue
	}

	@inlinable @_disfavoredOverload
	public init(rawValue: Int16) {
		self.rawValue = UInt16(bitPattern: rawValue)
	}

	//MARK: - Instruction

	public static let maskA: UInt16 = 0x8000
	public static let maskC: UInt16 = 0xE000

	/// Whether the instruction is a computing or addressing operation.
	@inlinable
	public var mode: Bool {
		get { rawValue & Instruction.maskA != 0 }
		set {
			if newValue {
				rawValue &= ~Instruction.maskA
			} else {
				rawValue |= Instruction.maskC
			}
		}
	}

	//MARK: - Adressing Instruction

	@inlinable
	public init(addressing value: UInt16) {
		self.init(rawValue: value & 0x7FFF)
	}

	/// Whether the instruction is an addressing operation.
	@inlinable
	public var isAddressing: Bool {
		!mode
	}

	/// The value literal of an adressing instruction
	@inlinable
	public var immediate: UInt16 {
		rawValue & 0x7FFF
	}

	//MARK: - Computing Instruction

	@inlinable
	public init(assign computation: Computation, to destination: Destination = .null, jump: Jump = .none) {
		self.init(rawValue: Instruction.maskC | computation.rawValue | destination.rawValue | jump.rawValue)
	}

	/// Whether the instruction is a computing operation.
	@inlinable
	public var isComputing: Bool {
		mode
	}

	/// The computation of this instruction
	@inlinable
	public var computation: Computation {
		get { Computation(mask: rawValue) }
		set { 
			rawValue &= ~Computation.mask
			rawValue |= newValue.rawValue
			rawValue |= Instruction.maskC
		}
	}

	/// Whether the instruction is indirect (`M[A]` rather than `A`)
	@inlinable
	public var i: Bool {
		get { computation.contains(Computation.i) }
		set { computation[Computation.i] = newValue }
	}

	/// Whether to zero the first operand
	@inlinable
	public var zx: Bool {
		get { computation.contains(Computation.zx) }
		set { computation[Computation.zx] = newValue }
	}

	/// Whether to invert the first operand
	@inlinable
	public var nx: Bool {
		get { computation.contains(Computation.nx) }
		set { computation[Computation.nx] = newValue }
	}

	/// Whether to zero the second operand
	@inlinable
	public var zy: Bool {
		get { computation.contains(Computation.zy) }
		set { computation[Computation.zy] = newValue }
	}

	/// Whether to invert the second operand
	@inlinable
	public var ny: Bool {
		get { computation.contains(Computation.ny) }
		set { computation[Computation.ny] = newValue }
	}

	/// Whether to `ADD` or `AND` the operands
	@inlinable
	public var f: Bool  {
		get { computation.contains(Computation.f) }
		set { computation[Computation.f] = newValue }
	}

	/// Whether to invert the output
	@inlinable
	public var no: Bool {
		get { computation.contains(Computation.no) }
		set { computation[Computation.no] = newValue }
	}

	/// The destination of this instruction
	@inlinable
	public var destination: Destination {
		get { Destination(mask: rawValue) }
		set {
			rawValue &= ~Destination.mask
			rawValue |= newValue.rawValue
			rawValue |= Instruction.maskC
		}
	}

	/// Whether to store the result in the address register (`A`)
	@inlinable
	public var a: Bool {
		get { destination.contains(Destination.a) }
		set { destination[Destination.a] = newValue }
	}

	/// Whether to store the result to memory (`M[A]`)
	@inlinable
	public var m: Bool {
		get { destination.contains(Destination.m) }
		set { destination[Destination.m] = newValue }
	}

	/// Whether to store the result to the data register (`D`)
	@inlinable
	public var d: Bool {
		get { destination.contains(Destination.d) }
		set { destination[Destination.d] = newValue }
	}

	/// The jump of this instruction
	@inlinable
	public var jump: Jump {
		get { Jump(mask: rawValue) }
		set {
			rawValue &= ~Jump.mask
			rawValue |= newValue.rawValue
			rawValue |= Instruction.maskC
		}
	}

	/// Jump if the output is greater than 0
	@inlinable
	public var gt: Bool {
		get { jump.contains(Jump.jgt) }
		set { jump[Jump.jgt] = newValue }
	}

	/// Jump if the output is equal to 0
	@inlinable
	public var eq: Bool {
		get { jump.contains(Jump.jeq) }
		set { jump[Jump.jeq] = newValue }
	}

	/// Jump if the output is lower than 0
	@inlinable
	public var lt: Bool {
		get { jump.contains(Jump.jlt) }
		set { jump[Jump.jlt] = newValue }
	}

	//MARK: - Shortcuts

	/// Whether a computation instruction will ADD operands together
	@_transparent public var add: Bool {
		f
	}

	/// Whether a computation instruction will AND operands together
	@_transparent public var and: Bool {
		!f
	}

	/// Whether the instruction is a legal pedantic instruction
	@_transparent public var legal: Bool {
		computation.legal
	}

}

extension Instruction: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {

	@inlinable
	public init(integerLiteral value: UInt16) {
		self.init(rawValue: value)
	}

	@inlinable
	public init(stringLiteral value: String) {
		self.init(value)!
	}

	@inlinable
	public var binary: String {
		let description = String(rawValue, radix: 2)
		let padding = String(repeating: "0", count: 16 - description.count)
		return padding + description
	}

	@inlinable
	public var hex: String {
		let description = String(rawValue, radix: 16)
		let padding = String(repeating: "0", count: 4 - description.count)
		return padding + description
	}

}
