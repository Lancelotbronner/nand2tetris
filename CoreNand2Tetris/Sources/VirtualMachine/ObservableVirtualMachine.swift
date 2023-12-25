//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

import Observation

@available(macOS 14.0, *)
@Observable public final class ObservableVirtualMachine: VirtualMachine {

	public init() { }

	//MARK: - Program

	var units: [VirtualUnit] = []
	var functions: [VirtualFunction] = []

	public subscript(unit name: String) -> VirtualUnit? {
		units.first { $0.name == name }
	}

	public subscript(_ name: String) -> VirtualFunction? {
		functions.first { $0.name == name }
	}

	public func insert(_ function: VirtualFunction) {
		functions.append(function)
		if !units.contains(function.unit) {
			units.append(function.unit)
		}
	}

	public func functions(of unit: VirtualUnit) -> [VirtualFunction] {
		functions.filter { $0.unit == unit }
	}

	//MARK: - Simulation

	var _offset = 0

	public var offset: UInt16 {
		get { UInt16(truncatingIfNeeded: _offset) }
		set { _offset = Int(newValue) }
	}

	public var frames: [VirtualFrame] = []

	@inlinable public var frame: VirtualFrame {
		precondition(!frames.isEmpty, "Callstack is empty")
		return frames.first!
	}

	public func main(_ function: VirtualFunction) {
		insert(function)
		frames.append(frame(caller: function, callee: function))
	}

	public func cycle() {
		execute(function[_offset])
		_offset += 1
	}

	//MARK: - Memory

	public var heap: [UInt16] = []

	var _stack: [UInt16] = []

	public var stack: Slice<[UInt16]> {
		get { Slice(base: _stack, bounds: frame.sp..<_stack.endIndex) }
		_modify {
			var tmp = stack
			yield &tmp
		}
	}

	var arguments: [UInt16] = []

	public var argument: Slice<[UInt16]> {
		get { Slice(base: arguments, bounds: frame.arg..<arguments.endIndex) }
		_modify {
			var tmp = argument
			yield &tmp
		}
	}

	public subscript(argument index: UInt16) -> UInt16 {
		get { arguments[frame.arg + Int(index)] }
		set { arguments[frame.arg + Int(index)] = newValue }
	}

	var locals: [UInt16] = []

	public var local: Slice<[UInt16]> {
		get { Slice(base: locals, bounds: frame.lcl..<locals.endIndex) }
		_modify {
			var tmp = local
			yield &tmp
		}
	}

	public subscript(local index: UInt16) -> UInt16 {
		get { locals[frame.lcl + Int(index)] }
		set { locals[frame.lcl + Int(index)] = newValue }
	}

	public subscript(this index: UInt16) -> UInt16 {
		get { heap[_this + Int(index)] }
		set { heap[_this + Int(index)] = newValue }
	}

	public subscript(that index: UInt16) -> UInt16 {
		get { heap[_that + Int(index)] }
		set { heap[_that + Int(index)] = newValue }
	}

	public subscript(pointer index: UInt16) -> UInt16 {
		get {
			precondition(index < 2, "pointer[\(index)] out of bounds")
			return switch index {
			case 0: this
			case 1: that
			default: 0
			}
		}
		set {
			precondition(index < 2, "pointer[\(index)] out of bounds")
			switch index {
			case 0: this = newValue
			case 1: that = newValue
			default: break
			}
		}
	}

	var _this = 0

	public var this: UInt16 {
		get { UInt16(truncatingIfNeeded: _this) }
		set { _this = Int(newValue) }
	}

	var _that = 0

	public var that: UInt16 {
		get { UInt16(truncatingIfNeeded: _that) }
		set { _that = Int(newValue) }
	}

	public subscript(temp index: UInt16) -> UInt16 {
		get {
			assert(index < 8, "temp[\(index)] out of bounds")
			return switch index {
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
		}
		set {
			assert(index < 8, "temp[\(index)] out of bounds")
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

	var _temp0 = 0

	public var temp0: UInt16 {
		get { UInt16(truncatingIfNeeded: _temp0) }
		set { _temp0 = Int(newValue) }
	}

	var _temp1 = 0

	public var temp1: UInt16 {
		get { UInt16(truncatingIfNeeded: _temp1) }
		set { _temp1 = Int(newValue) }
	}

	var _temp2 = 0

	public var temp2: UInt16 {
		get { UInt16(truncatingIfNeeded: _temp2) }
		set { _temp2 = Int(newValue) }
	}

	var _temp3 = 0

	public var temp3: UInt16 {
		get { UInt16(truncatingIfNeeded: _temp3) }
		set { _temp3 = Int(newValue) }
	}

	var _temp4 = 0

	public var temp4: UInt16 {
		get { UInt16(truncatingIfNeeded: _temp4) }
		set { _temp4 = Int(newValue) }
	}

	var _temp5 = 0

	public var temp5: UInt16 {
		get { UInt16(truncatingIfNeeded: _temp5) }
		set { _temp5 = Int(newValue) }
	}

	var _temp6 = 0

	public var temp6: UInt16 {
		get { UInt16(truncatingIfNeeded: _temp6) }
		set { _temp6 = Int(newValue) }
	}

	var _temp7 = 0

	public var temp7: UInt16 {
		get { UInt16(truncatingIfNeeded: _temp7) }
		set { _temp7 = Int(newValue) }
	}

	//MARK: - Arithmetic Commands

	public func add() {
		stackguard()
		push(pop &+ pop)
	}

	public func sub() {
		stackguard()
		let tmp = pop
		push(pop &- tmp)
	}

	public func neg() {
		stackguard()
		push(-pop)
	}

	public func eq() {
		stackguard()
		push(pop == pop)
	}

	public func gt() {
		stackguard()
		let tmp = pop
		push(pop > tmp)
	}

	public func lt() {
		stackguard()
		let tmp = pop
		push(pop < tmp)
	}

	public func and() {
		stackguard()
		push(pop & pop)
	}

	public func or() {
		stackguard()
		push(pop | pop)
	}

	public func not() {
		stackguard()
		push(~pop)
	}

	//MARK: - Memory Commands

	public func push(_ segment: MemorySegment, offset: UInt16) {
		let value = switch segment {
		case .argument: self[argument: offset]
		case .local: self[local: offset]
		case .static: self[static: offset]
		case .constant: offset
		case .this: self[this: offset]
		case .that: self[that: offset]
		case .pointer: self[pointer: offset]
		case .temp: self[temp: offset]
		}
		push(Int16(bitPattern: value))
	}

	public func pop(_ segment: MemorySegment, offset: UInt16) {
		let value = UInt16(bitPattern: pop)
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

	public func goto(offset: UInt16) {
		precondition(Int(offset) < function.endIndex, "Index out of bounds")
		self.offset = offset
	}

	public func ifgoto(offset: UInt16) {
		guard pop == Command.true else { return }
		precondition(Int(offset) < function.endIndex, "Index out of bounds")
		self.offset = offset
	}

	//MARK: - Function Commands

	public func call(_ function: VirtualFunction) {
		frames.append(frame(caller: self.function, callee: function))
	}

	public func `return`() {
		preconditionFailure("Unimplemented")
	}

	//MARK: - Utilities

	@inlinable func stackguard() {
		precondition(stack.endIndex >= frame.sp, "Pop would have spilled into the previous frame")
	}

	public var pop: Int16 {
		Int16(bitPattern: _stack.removeLast())
	}

	public func push(_ value: Int16) {
		_stack.append(UInt16(bitPattern: value))
	}

	func frame(caller: VirtualFunction, callee: VirtualFunction) -> VirtualFrame {
		VirtualFrame(
			caller: caller,
			callee: callee,
			return: _offset,
			sp: _stack.count,
			arg: arguments.count,
			lcl: locals.count,
			this: _this,
			that: _that)
	}

}
