//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

public struct VirtualFrame {

	/// The function which spawned this frame
	public let caller: VirtualFunction

	/// The function this frame is executing
	public let callee: VirtualFunction

	/// The return address (command offset of ``caller``)
	public let `return`: Int

	/// The stack pointer when the frame began
	public let sp: Int

	/// The argument offset of the frame.
	public let arg: Int

	/// The local offset of the frame.
	public var lcl: Int

	/// The this pointer
	public var this: Int

	/// The that pointer
	public var that: Int

}
