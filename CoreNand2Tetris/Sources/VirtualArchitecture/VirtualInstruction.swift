//
//  VirtualInstruction.swift
//  Nand2Tetris
//
//  Created by Christophe Bronner on 2023-12-25.
//

public enum VirtualInstruction: ExpressibleByIntegerLiteral, Hashable {

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
		self = VirtualInstruction.push(.constant, offset: UInt16(bitPattern: value))
	}

	public static func push(argument offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.push(.argument, offset: offset)
	}

	public static func pop(argument offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.pop(.argument, offset: offset)
	}

	public static func push(local offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.push(.local, offset: offset)
	}

	public static func pop(local offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.pop(.local, offset: offset)
	}

	public static func push(static offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.push(.static, offset: offset)
	}

	public static func pop(static offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.pop(.static, offset: offset)
	}

	public static func push(constant offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.push(.constant, offset: offset)
	}

	public static func pop(constant offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.pop(.constant, offset: offset)
	}

	public static func push(this offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.push(.this, offset: offset)
	}

	public static func pop(this offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.pop(.this, offset: offset)
	}

	public static func push(that offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.push(.that, offset: offset)
	}

	public static func pop(that offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.pop(.that, offset: offset)
	}

	public static func push(pointer offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.push(.pointer, offset: offset)
	}

	public static func pop(pointer offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.pop(.pointer, offset: offset)
	}

	public static func push(temp offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.push(.temp, offset: offset)
	}

	public static func pop(temp offset: UInt16) -> VirtualInstruction {
		VirtualInstruction.pop(.temp, offset: offset)
	}

	//MARK: - Control Flow Commands

	/// Jumps to the specified offset within the current function
	case goto(_ offset: UInt16)

	/// Jumps by the specified offset within the current function
	case gotor(_ offset: Int16)

	/// Conditionally jumps to the specified offset within the current function
	case `if`(_ offset: UInt16)

	/// Conditionally jumps by the specified offset within the current function
	case ifr(_ offset: Int16)

	//MARK: - Function Commands

	case call(_ function: VirtualFunction, _ args: UInt16)

	case `return`

	public static func call(_ function: VirtualFunction, arguments firstArgument: Int16, _ arguments: Int16...) -> [VirtualInstruction] {
		var commands: [VirtualInstruction] = []
		commands.reserveCapacity((arguments.count + 1) * 2 + 1)
		let firstArgument = UInt16(bitPattern: firstArgument)
		commands.append(VirtualInstruction.pop(.constant, offset: firstArgument))
		commands.append(VirtualInstruction.push(.argument, offset: 0))
		for i in arguments.indices {
			let argument = UInt16(bitPattern: arguments[i])
			commands.append(VirtualInstruction.pop(.constant, offset: argument))
			commands.append(VirtualInstruction.push(.argument, offset: UInt16(truncatingIfNeeded: i + 1)))
		}
		commands.append(VirtualInstruction.call(function, UInt16(truncatingIfNeeded: arguments.count + 1)))
		return commands
	}

}

//MARK: - Debugging

extension VirtualInstruction: CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {
		case .add: "add"
		case .sub: "sub"
		case .neg: "neg"
		case .eq: "eq"
		case .gt: "gt"
		case .lt: "lt"
		case .and: "and"
		case .or: "or"
		case .not: "not"
		case let .push(segment, address): "push \(segment) \(address)"
		case let .pop(segment, offset): "pop \(segment) \(offset)"
		case let .goto(address): "goto \(address)"
		case let .gotor(offset): "goto \(offset > 0 ? "+" : "")\(offset)"
		case let .if(address): "if \(address)"
		case let .ifr(offset): "if \(offset > 0 ? "+" : "")\(offset)"
		case let .call(function, args): "call \(function.name) \(args)"
		case .return: "return"
		}
	}
}
