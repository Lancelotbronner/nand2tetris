//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
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

	case push(_ segment: MemorySegment, offset: UInt16)
	case pop(_ segment: MemorySegment, offset: UInt16)

	public static func push(constant offset: UInt16) -> Command {
		Command.push(.constant, offset: offset)
	}

	//MARK: - Flow Commands

	/// Jumps to the specified offset within the current function
	case goto(offset: UInt16)

	/// Conditionally jumps to the specified offset within the current function
	case ifgoto(offset: UInt16)

	//MARK: - Function Commands

	case call(_ function: VirtualFunction)

	case `return`

	public static func call(_ function: VirtualFunction, arguments: Int16...) -> [Command] {
		var commands: [Command] = []
		commands.reserveCapacity(arguments.count * 2 + 1)
		for i in arguments.indices {
			let argument = UInt16(bitPattern: arguments[i])
			commands.append(Command.pop(.constant, offset: argument))
			commands.append(Command.push(.argument, offset: UInt16(truncatingIfNeeded: i)))
		}
		commands.append(Command.call(function))
		return commands
	}

}
