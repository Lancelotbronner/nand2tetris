//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

public struct VirtualMachineEmulator {

	//MARK: - Program Flow

	public var callstack: [Frame] = []
	public var functions: [String : [Command]] = [:]

	//MARK: - Memory

	public var stack: [UInt16] = []
	public var heap: [UInt16] = []

	public struct Frame {
		/// The return address (command offset of the calling function)
		public var `return`: UInt16
		/// The argument offset of the frame.
		public var argument: UInt16
		/// The local offset of the frame.
		public var lcl: UInt16
		/// The this pointer
		public var this: UInt16
		/// The that pointer
		public var that: UInt16
	}

	public var arg: UInt16 = 0
	public var argument: [UInt16] = []
	public var lcl: UInt16 = 0
	public var local: [UInt16] = []
	public var `static`: [UInt16] = []
	public var this: UInt16 = 0
	public var that: UInt16 = 0
	public var temp0: UInt16 = 0
	public var temp1: UInt16 = 0
	public var temp2: UInt16 = 0
	public var temp3: UInt16 = 0
	public var temp4: UInt16 = 0
	public var temp5: UInt16 = 0
	public var temp6: UInt16 = 0
	public var temp7: UInt16 = 0

	public subscript(argument index: UInt16) -> UInt16 {
		get { MemorySegment.read(from: argument, at: index) }
		set { MemorySegment.write(newValue, to: &argument, at: index) }
	}

	public subscript(local index: UInt16) -> UInt16 {
		get { MemorySegment.read(from: local, at: index) }
		set { MemorySegment.write(newValue, to: &local, at: index) }
	}

	public subscript(static index: UInt16) -> UInt16 {
		get { MemorySegment.read(from: self.static, at: index) }
		set { MemorySegment.write(newValue, to: &self.static, at: index) }
	}

//	public subscript(this index: UInt16) -> UInt16 {
//
//	}
//
//	public subscript(that index: UInt16) -> UInt16 {
//
//	}

	public subscript(pointer index: UInt16) -> UInt16 {
		get {
			assert(index < 2, "pointer[\(index)] out of bounds")
			return switch index {
			case 0: this
			case 1: that
			default: 0
			}
		}
		set {
			assert(index < 2, "pointer[\(index)] out of bounds")
			switch index {
			case 0: this = newValue
			case 1: that = newValue
			default: break
			}
		}
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

}
