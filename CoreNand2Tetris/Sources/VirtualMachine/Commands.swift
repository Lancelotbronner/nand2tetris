//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

public enum Command {

	public static let `true` = UInt16.max
	public static let `false` = UInt16.min

	//MARK: - Arithmetic Commands

	case add
	case sub
	case neg

	case eq
	case gt
	case lt

	case and
	case or
	case not

	//MARK: - Memory Commands

	case push(segment: MemorySegment, index: UInt16)
	case pop(segment: MemorySegment, index: UInt16)

	//MARK: - Flow Commands

	case label(label: String)
	case goto(label: String)
	case ifgoto(label: String)

	//MARK: - Function Commands

	case function(name: String, locals: UInt16)
	case call(name: String, args: UInt16)
	case `return`

}

public enum MemorySegment {

	/// Stores the function’s arguments.
	case argument

	/// Stores the function’s local variables.
	case local

	/// Stores static variables shared by all functions in the same unit.
	case `static`

	/// Pseudo-segment that holds all the constants in the range `0...32767`.
	case constant

	/// General-purpose segment. Can be made to correspond to different areas in the heap via ``pointer``.
	case this

	/// General-purpose segment. Can be made to correspond to different areas in the heap via ``pointer``.
	case that

	/// A two-entry segment that holds the base addresses of the ``this`` and ``that`` segments.
	case pointer

	/// Fixed eight-entry segment that holds temporary variables for general use.
	case temp
}
