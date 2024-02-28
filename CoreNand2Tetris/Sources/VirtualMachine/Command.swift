//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

public enum Command: ExpressibleByIntegerLiteral, Hashable {

	public static let `true` = Int16.max
	public static let `false` = Int16.min

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

	public init(integerLiteral value: Int16) {
		self = Command.push(.constant, offset: UInt16(bitPattern: value))
	}

	public static func push(argument offset: UInt16) -> Command {
		Command.push(.argument, offset: offset)
	}

	public static func pop(argument offset: UInt16) -> Command {
		Command.pop(.argument, offset: offset)
	}

	public static func push(local offset: UInt16) -> Command {
		Command.push(.local, offset: offset)
	}

	public static func pop(local offset: UInt16) -> Command {
		Command.pop(.local, offset: offset)
	}

	public static func push(static offset: UInt16) -> Command {
		Command.push(.static, offset: offset)
	}

	public static func pop(static offset: UInt16) -> Command {
		Command.pop(.static, offset: offset)
	}

	public static func push(constant offset: UInt16) -> Command {
		Command.push(.constant, offset: offset)
	}

	public static func pop(constant offset: UInt16) -> Command {
		Command.pop(.constant, offset: offset)
	}

	public static func push(this offset: UInt16) -> Command {
		Command.push(.this, offset: offset)
	}

	public static func pop(this offset: UInt16) -> Command {
		Command.pop(.this, offset: offset)
	}

	public static func push(that offset: UInt16) -> Command {
		Command.push(.that, offset: offset)
	}

	public static func pop(that offset: UInt16) -> Command {
		Command.pop(.that, offset: offset)
	}

	public static func push(pointer offset: UInt16) -> Command {
		Command.push(.pointer, offset: offset)
	}

	public static func pop(pointer offset: UInt16) -> Command {
		Command.pop(.pointer, offset: offset)
	}

	public static func push(temp offset: UInt16) -> Command {
		Command.push(.temp, offset: offset)
	}

	public static func pop(temp offset: UInt16) -> Command {
		Command.pop(.temp, offset: offset)
	}

	//MARK: - Flow Commands

	/// Jumps to the specified offset within the current function
	case goto(_ offset: UInt16)

	/// Jumps by the specified offset within the current function
	case gotor(_ offset: Int16)

	/// Conditionally jumps to the specified offset within the current function
	case `if`(_ offset: UInt16)

	/// Conditionally jumps by the specified offset within the current function
	case ifr(_ offset: Int16)

	//MARK: - Function Commands

	case call(_ function: VirtualFunction)

	case `return`

	public static func call(_ function: VirtualFunction, arguments firstArgument: Int16, _ arguments: Int16...) -> [Command] {
		var commands: [Command] = []
		commands.reserveCapacity((arguments.count + 1) * 2 + 1)
		let firstArgument = UInt16(bitPattern: firstArgument)
		commands.append(Command.pop(.constant, offset: firstArgument))
		commands.append(Command.push(.argument, offset: 0))
		for i in arguments.indices {
			let argument = UInt16(bitPattern: arguments[i])
			commands.append(Command.pop(.constant, offset: argument))
			commands.append(Command.push(.argument, offset: UInt16(truncatingIfNeeded: i + 1)))
		}
		commands.append(Command.call(function))
		return commands
	}

}
