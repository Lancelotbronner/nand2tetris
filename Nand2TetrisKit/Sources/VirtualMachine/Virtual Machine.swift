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
	public var m: UInt16 {
		get {
			self[ram: a]
		}
		set {
			self[ram: a] = newValue
		}
	}

	@inlinable @inline(__always)
	public var instruction: Instruction {
		Instruction(rawValue: self[rom: pc])
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

	//MARK: - ROM

	/// The read-only memory of the computer
	public let rom: VirtualMemory

	//MARK: - RAM

	/// The read-write memory of the computer
	public let ram: VirtualMemory

	//MARK: Initialization

	public init() {
		rom = .init()
		ram = .init()
	}

	//MARK: Subscripts

	public subscript(rom address: UInt16) -> UInt16 {
		_read {
			_$observationRegistrar.access(self, keyPath: \.rom)
			yield rom[Int(address)]
		}
		set {
			_$observationRegistrar.withMutation(of: self, keyPath: \.rom) {
				rom[Int(address)] = newValue
			}
		}
	}

	public func rom(at address: UInt16) -> UInt16 {
		self[rom: address]
	}

	public subscript(ram address: UInt16) -> UInt16 {
		_read {
			_$observationRegistrar.access(self, keyPath: \.ram)
			yield ram[Int(address)]
		}
		set {
			_$observationRegistrar.withMutation(of: self, keyPath: \.ram) {
				ram[Int(address)] = newValue
			}
		}
	}

	public func ram(at address: UInt16) -> UInt16 {
		self[ram: address]
	}

	//MARK: Methods

	public func step() {
		// Fetch cycle information
		let instruction = self.instruction
		let x = self.x;
		let y = self.y;

		// Compute the instruction's output
		let (o, zr, ng) = VirtualMachine.alu(instruction, with: x, y)
		self.zr = zr
		self.ng = ng

		// Jump if necessary
		let lt = { instruction.lt && ng }
		let eq = { instruction.eq && zr }
		let gt = { instruction.gt && !ng }
		if (lt() || eq() || gt()) {
			pc = a
		}

		// Store output to the desired locations
		if (instruction.m) {
			m = o;
		}
		if (instruction.d) {
			d = o;
		}
		if (instruction.a) {
			a = o;
		}
	}

}
