//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

public protocol VirtualMachine: AnyObject {

	//MARK: - Program

	/// The units loaded into the virtual machine
	var units: Set<VirtualUnit> { get }

	/// The functions loaded into the virtual machine
	var functions: Set<VirtualFunction> { get }

	/// Inserts a function into the program
	func insert(_ function: VirtualFunction)

	//MARK: - Simulation

	/// The current function's program counter
	var pc: Int { get set }

	/// The frames which consist the call stack
	var frames: [RawVirtualFrame] { get set }

	//MARK: - Global Memory

	/// The global memory
	var heap: [Int16] { get set }

	/// The global stack
	var stack: [Int16] { get set }

	//MARK: - Memory Segments

	/// Points to the arguments of the current frame
	var arg: Int { get set }

	/// Points to the locals of the current frame
	var lcl: Int { get set }

	/// General purpose pointer 0
	var this: Int { get set }

	/// General purpose pointer 1
	var that: Int { get set }

	/// General purpose temporary register
	var temp0: Int { get set }

	/// General purpose temporary register
	var temp1: Int { get set }

	/// General purpose temporary register
	var temp2: Int { get set }

	/// General purpose temporary register
	var temp3: Int { get set }

	/// General purpose temporary register
	var temp4: Int { get set }

	/// General purpose temporary register
	var temp5: Int { get set }

	/// General purpose temporary register
	var temp6: Int { get set }

	/// General purpose temporary register 0
	var temp7: Int { get set }

}

extension VirtualMachine {

	//MARK: - Program

	/// Resolves a unit via its name
	@inlinable public subscript(unit name: String) -> VirtualUnit? {
		units.first { $0.name == name }
	}

	/// Resolves a function handle via its name
	@inlinable public subscript(_ name: String) -> VirtualFunction? {
		functions.first { $0.name == name }
	}

	/// Finds all functions contained in a unit
	@inlinable public func functions(of unit: VirtualUnit) -> Set<VirtualFunction> {
		functions.filter { $0.unit == unit }
	}

	//MARK: - Simulation

	/// The current frame
	@_transparent public var frame: VirtualFrame<Self>? {
		frames.last.map {
			VirtualFrame($0, on: self)
		}
	}

	/// The currently executing function
	@_transparent public var function: VirtualFunction? {
		frames.last?.callee
	}

	/// The currently executing unit
	@_transparent public var unit: VirtualUnit? {
		frames.last?.callee.unit
	}

	/// Executes a single instruction
	@inlinable public func execute(_ command: Command) {
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
		case let .push(segment, offset): push(segment, offset: Int(offset))
		case let .pop(segment, offset): pop(segment, offset: Int(offset))
		case let .goto(offset): goto(Int(offset))
		case let .gotor(offset): goto(pc + Int(offset))
		case let .if(offset): self.if(goto: Int(offset))
		case let .ifr(offset): self.if(goto: pc + Int(offset))
		case let .call(function, args): call(function, Int(args))
		case .return: self.return()
		}
	}

	/// Executes a single command
	@inlinable public func step() {
		guard let function else { return }

		if pc >= function.count {
			execute(.return)
			return
		}
		
		let command = function[pc]
		execute(command)
		pc += 1
	}

	/// Executes the given number of commands
	@inlinable public func step(_ times: Int) {
		for _ in 0..<times {
			step()
		}
	}

	/// Executes until the current function returns
	@inlinable public func executeToEndOfFunction() {
		guard let function, pc < function.endIndex else { return }
		for i in pc..<function.endIndex {
			execute(function[i])
		}
	}

	//MARK: - Global Memory

	@inlinable public subscript(stack i: Int) -> Int16 {
		get {
			guard stack.indices.contains(i) else { return 0 }
			return stack[i]
		}
		set {
			if i >= stack.count {
				let padding = Array<Int16>(repeating: 0, count: i - stack.count + 1)
				stack.append(contentsOf: padding)
			}
			stack[i] = newValue
		}
	}

	@inlinable public subscript(heap i: Int) -> Int16 {
		get {
			guard heap.indices.contains(i) else { return 0 }
			return heap[i]
		}
		set {
			if i >= heap.count {
				let padding = Array<Int16>(repeating: 0, count: i - heap.count + 1)
				heap.append(contentsOf: padding)
			}
			heap[i] = newValue
		}
	}

	/// Pushes a value to the global stack
	@_transparent public func push(_ value: Int16) {
		stack.append(value)
	}

	/// Pops a value from the global stack
	@inlinable public var pop: Int16 {
		get {
			if let value = stack.last {
				stack.removeLast()
				return value
			}
			return 0
		}
	}

	@_transparent public var popb: Bool {
		pop == Command.true
	}

	@_transparent public func push(_ value: Bool) {
		push(value ? Command.true : Command.false)
	}

	/// Peeks at the top of the global stack
	@_transparent public var peek: Int16 {
		stack.last ?? 0
	}

	/// Peeks at the top of the global stack
	@_transparent public var peekb: Bool {
		peek == Command.true
	}

	/// Peeks further in the global stack, starting from the top
	@_transparent public func peek(_ back: Int) -> Int16 {
		stack.dropLast(back).last ?? 0
	}

	/// Peeks further in the global stack, starting from the top
	@_transparent public func peekb(_ back: Int) -> Bool {
		peek(back) == Command.true
	}

	//MARK: - Memory Segments

	public subscript(argument index: Int) -> Int16 {
		@_transparent get { self[stack: arg + index] }
		@_transparent set { self[stack: arg + index] = newValue }
	}

	public subscript(local index: Int) -> Int16 {
		@_transparent get { self[stack: lcl + index] }
		@_transparent set { self[stack: lcl + index] = newValue }
	}

	public subscript(static index: Int) -> Int16 {
		@_transparent get { unit?[static: index] ?? 0 }
		@_transparent set { unit?[static: index] = newValue }
	}

	public subscript(this index: Int) -> Int16 {
		@_transparent get { self[heap: this + index] }
		@_transparent set { self[heap: this + index] = newValue }
	}

	public subscript(that index: Int) -> Int16 {
		@_transparent get { self[heap: that + index] }
		@_transparent set { self[heap: that + index] = newValue }
	}

	@inlinable public subscript(pointer index: Int) -> Int16 {
		get {
			precondition(index < 2, "pointer[\(index)] out of bounds")
			let value = switch index {
			case 0: this
			case 1: that
			default: 0
			}
			return Int16(truncatingIfNeeded: value)
		}
		set {
			precondition(index < 2, "pointer[\(index)] out of bounds")
			let newValue = Int(newValue)
			switch index {
			case 0: this = newValue
			case 1: that = newValue
			default: break
			}
		}
	}

	@inlinable public subscript(temp index: Int) -> Int16 {
		get {
			assert(index < 8, "temp[\(index)] out of bounds")
			let value = switch index {
			case 0: temp0
			case 1: temp1
			case 2: temp2
			case 3: temp3
			case 4: temp4
			case 5: temp5
			case 6: temp6
			case 7: temp7
			default: 0
			}
			return Int16(truncatingIfNeeded: value)
		}
		set {
			assert(index < 8, "temp[\(index)] out of bounds")
			let newValue = Int(newValue)
			switch index {
			case 0: temp0 = newValue
			case 1: temp1 = newValue
			case 2: temp2 = newValue
			case 3: temp3 = newValue
			case 4: temp4 = newValue
			case 5: temp5 = newValue
			case 6: temp6 = newValue
			case 7: temp7 = newValue
			default: break
			}
		}
	}

	//MARK: - Arithmetic Commands

	@inlinable public func add() {
		push(pop &+ pop)
	}

	@inlinable public func sub() {
		let tmp = pop
		push(pop &- tmp)
	}

	@inlinable public func neg() {
		push(-pop)
	}

	@inlinable public func eq() {
		push(pop == pop)
	}

	@inlinable public func gt() {
		let tmp = pop
		push(pop > tmp)
	}

	@inlinable public func lt() {
		let tmp = pop
		push(pop < tmp)
	}

	@inlinable public func and() {
		push(pop & pop)
	}

	@inlinable public func or() {
		push(pop | pop)
	}

	@inlinable public func not() {
		push(~pop)
	}

	//MARK: - Memory Commands

	@inlinable public func push(_ segment: MemorySegment, offset: Int) {
		let value = switch segment {
		case .argument: self[argument: offset]
		case .local: self[local: offset]
		case .static: self[static: offset]
		case .constant: Int16(truncatingIfNeeded: offset)
		case .this: self[this: offset]
		case .that: self[that: offset]
		case .pointer: self[pointer: offset]
		case .temp: self[temp: offset]
		}
		push(value)
	}

	@inlinable public func pop(_ segment: MemorySegment, offset: Int) {
		let value = pop
		switch segment {
		case .argument: self[argument: offset] = value
		case .local: self[local: offset] = value
		case .static: self[static: offset] = value
		case .constant: break
		case .this: self[this: offset] = value
		case .that: self[that: offset] = value
		case .pointer: self[pointer: offset] = value
		case .temp: self[temp: offset] = value
		}
	}

	//MARK: - Flow Commands

	@inlinable public func goto(_ offset: Int) {
		guard let function else { return }
		precondition(offset < function.endIndex, "Index out of bounds: \(function)[\(offset)]")
		self.pc = offset
	}

	@inlinable public func `if`(goto offset: Int) {
		guard let function, popb else { return }
		precondition(offset < function.endIndex, "Index out of bounds: \(function)[\(offset)]")
		self.pc = offset
	}

	//MARK: - Function Commands

	@inlinable public func call(_ function: VirtualFunction, _ args: Int) {
		let frame = RawVirtualFrame(
			caller: self.function,
			callee: function,
			return: pc,
			fp: stack.count,
			lcl: lcl,
			arg: arg,
			this: this,
			that: that)
		frames.append(frame)
		pc = 0
		arg = stack.count - args
		lcl = stack.count
		for _ in 0..<function.locals {
			push(0)
		}
	}

	@inlinable public func `return`() {
		guard !frames.isEmpty else { return }
		let frame = frames.removeLast()
		pc = frame.return
		lcl = frame.lcl
		arg = frame.arg
		this = frame.this
		that = frame.that
	}

	//MARK: - Utilities

	@_transparent public func stackguard() {
		guard let rawFrame = frames.last else { return }
		precondition(stack.endIndex >= rawFrame.fp, "Pop would have spilled into the previous frame")
	}

}
