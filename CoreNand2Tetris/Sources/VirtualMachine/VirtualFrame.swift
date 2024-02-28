//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

public struct RawVirtualFrame: Hashable, Identifiable {

	/// The function which spawned this frame
	public let caller: VirtualFunction?

	/// The function this frame is executing
	public let callee: VirtualFunction

	/// Command offset of the caller
	public let `return`: Int

	/// Points to the beginning of this frame
	public let fp: Int

	/// Points to the caller's locals
	public let lcl: Int

	/// Points to the caller's arguments
	public let arg: Int

	/// Remembers the `this` pointer of the caller
	public let this: Int

	/// Remembers the `that` pointer of the caller
	public let that: Int

	@usableFromInline init(caller: VirtualFunction?, callee: VirtualFunction, return pc: Int, fp: Int, lcl: Int, arg: Int, this: Int, that: Int) {
		self.caller = caller
		self.callee = callee
		self.return = pc
		self.fp = fp
		self.lcl = lcl
		self.arg = arg
		self.this = this
		self.that = that
	}

	public var id: RawVirtualFrame { self }

}

public struct VirtualFrame<Machine: VirtualMachine> {
	public let vm: Machine
	public let frame: RawVirtualFrame

	@_transparent public init(_ frame: RawVirtualFrame, on vm: Machine) {
		self.vm = vm
		self.frame = frame
	}

	/// The function which spawned this frame
	@_transparent public var caller: VirtualFunction? {
		frame.caller
	}

	/// The function this frame is executing
	@_transparent public var callee: VirtualFunction {
		frame.callee
	}

	/// Command offset of the ``caller``
	@_transparent public var `return`: Int {
		frame.return
	}

	/// Points to the beginning of the frame
	@_transparent public var fp: Int {
		frame.fp
	}

	/// Points to the caller's locals
	@_transparent public var lcl: Int {
		frame.lcl
	}

	/// Points to the caller's arguments
	@_transparent public var arg: Int {
		frame.arg
	}

	/// Remembers the `this` pointer of the caller
	@_transparent public var this: Int {
		frame.this
	}

	/// Remembers the `that` pointer of the caller
	@_transparent public var that: Int {
		frame.that
	}

}
