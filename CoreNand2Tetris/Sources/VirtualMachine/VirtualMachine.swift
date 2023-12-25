//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

public protocol VirtualMachine {

	//MARK: - Program

	/// Resolves a unit via its name
	subscript(unit name: String) -> VirtualUnit? { get }

	/// Resolves a function handle via its name
	subscript(_ name: String) -> VirtualFunction? { get }

	/// Inserts a function into the program
	func insert(_ function: VirtualFunction)

	/// Finds all functions contained in a unit
	func functions(of unit: VirtualUnit) -> [VirtualFunction]

	//MARK: - Simulation

	/// The current frame
	var frame: VirtualFrame { get }

	/// The current command offset into the current function's body
	var offset: UInt16 { get }

	/// The frames which consist the call stack
	var frames: [VirtualFrame] { get }

	func main(_ function: VirtualFunction)

	/// Executes a single command
	func cycle()

	//MARK: - Memory

	var heap: [UInt16] { get }
	var stack: Slice<[UInt16]> { get }

	var pop: Int16 { get }

	func push(_ value: Int16)

	subscript(argument index: UInt16) -> UInt16 { get set }

	var argument: Slice<[UInt16]> { get }

	subscript(local index: UInt16) -> UInt16 { get set }

	var local: Slice<[UInt16]> { get }

	subscript(static index: UInt16) -> UInt16 { get set }

	var `static`: Slice<VirtualUnit> { get }

	subscript(this index: UInt16) -> UInt16 { get set }

	subscript(that index: UInt16) -> UInt16 { get set }

	subscript(pointer index: UInt16) -> UInt16 { get set }

	var this: UInt16 { get set }

	var that: UInt16 { get set }

	subscript(temp index: UInt16) -> UInt16 { get set }

	var temp0: UInt16 { get set }
	var temp1: UInt16 { get set }
	var temp2: UInt16 { get set }
	var temp3: UInt16 { get set }
	var temp4: UInt16 { get set }
	var temp5: UInt16 { get set }
	var temp6: UInt16 { get set }
	var temp7: UInt16 { get set }

	//MARK: - Arithmetic Commands

	func add()
	func sub()
	func neg()

	func eq()
	func gt()
	func lt()

	func and()
	func or()
	func not()

	//MARK: - Memory Commands

	func push(_ segment: MemorySegment, offset: UInt16)
	func pop(_ segment: MemorySegment, offset: UInt16)

	//MARK: - Flow Commands

	func goto(offset: UInt16)
	func ifgoto(offset: UInt16)

	//MARK: - Function Commands

	func call(_ function: VirtualFunction)
	func `return`()

}

extension VirtualMachine {

	@_transparent public func execute(_ command: Command) {
		switch command {
		case .add: add()
		case .sub: sub()
		case .neg: neg()
		case .eq: eq()
		case .gt: gt()
		case .lt: lt()
		case .and: and()
		case .or: or()
		case .not: not()
		case let .push(segment, offset): push(segment, offset: offset)
		case let .pop(segment, offset): pop(segment, offset: offset)
		case let .goto(offset): goto(offset: offset)
		case let .ifgoto(offset): ifgoto(offset: offset)
		case let .call(function): call(function)
		case .return: self.return()
		}
	}

	@_transparent public func cycle(_ times: Int) {
		for _ in 0..<times {
			cycle()
		}
	}

	@_transparent public var `static`: Slice<VirtualUnit> {
		unit[frame.sp...]
	}

	public subscript(static index: UInt16) -> UInt16 {
		@_transparent get { unit[static: Int(index)] }
		@_transparent nonmutating set { unit[static: Int(index)] = newValue }
	}

	@_transparent public var this: UInt16 {
		get { self[pointer: 0] }
		set { self[pointer: 0] = newValue }
	}

	@_transparent public var that: UInt16 {
		get { self[pointer: 1] }
		set { self[pointer: 1] = newValue }
	}

	@_transparent public var temp0: UInt16 {
		get { self[temp: 0] }
		set { self[temp: 0] = newValue }
	}

	@_transparent public var temp1: UInt16 {
		get { self[temp: 1] }
		set { self[temp: 1] = newValue }
	}

	@_transparent public var temp2: UInt16 {
		get { self[temp: 2] }
		set { self[temp: 2] = newValue }
	}

	@_transparent public var temp3: UInt16 {
		get { self[temp: 3] }
		set { self[temp: 3] = newValue }
	}

	@_transparent public var temp4: UInt16 {
		get { self[temp: 4] }
		set { self[temp: 4] = newValue }
	}

	@_transparent public var temp5: UInt16 {
		get { self[temp: 5] }
		set { self[temp: 5] = newValue }
	}

	@_transparent public var temp6: UInt16 {
		get { self[temp: 6] }
		set { self[temp: 6] = newValue }
	}

	@_transparent public var temp7: UInt16 {
		get { self[temp: 7] }
		set { self[temp: 7] = newValue }
	}
	
	//MARK: - Shortcuts

	/// The currently executing function
	@_transparent public var function: VirtualFunction {
		frame.callee
	}

	/// The currently executing unit
	@_transparent public var unit: VirtualUnit {
		frame.callee.unit
	}

	@_transparent public func push(_ value: Bool) {
		push(Int16(bitPattern: value ? Command.true : Command.false))
	}

}
