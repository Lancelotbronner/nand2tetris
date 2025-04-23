//
//  Translator.swift
//  Nand2TetrisKit
//
//  Created by Christophe Bronner on 2024-08-13.
//

import Observation

@Observable
public final class Translator {

	public init(pedantic: Bool = true) {
		self.pedantic = pedantic
	}

	// Note:
	// 0-15 registers
	// 16-255 static variables
	// 256-2047 stack
	// 2048-16483 heap
	// 16484-24575 memory-mapped IO
	//
	// R0 SP stack pointer
	// R1 LCL local segment
	// R2 ARG argument segment
	// R3 THIS this segment
	// R4 THAT that segment
	// R5-R12 temp segment
	// R13-R15 registers

	//MARK: - Assembly Management

	//MARK: - Configuration Management

	/// Whether the translator should only accept the standard.
	public var pedantic = true

	//MARK: - Diagnostics Management

	//MARK: - Unit Management

	//MARK: - Function Management

	//MARK: - Program Management

	public var program: [VirtualInstruction] = []

	public func append(_ instruction: VirtualInstruction) {
		program.append(instruction)
	}

	public func append(_ instructions: some Sequence<VirtualInstruction>) {
		program.append(contentsOf: instructions)
	}

	public func process(_ assembly: VirtualAssembly) {
		switch assembly {
		case .add: append(.add)
		case .sub: append(.sub)
		case .neg: append(.neg)
		case .eq: append(.eq)
		case .gt: append(.gt)
		case .lt: append(.lt)
		case .and: append(.and)
		case .or: append(.or)
		case .not: append(.not)
		case let .push(segment, offset): append(.push(segment, offset: offset))
		case let .pop(segment, offset): append(.push(segment, offset: offset))
			//TODO: Label and function management/lookup
		case let .label(label): break
		case let .goto(label): break
		case let .ifgoto(label): break
		case let .function(name, locals): break
		case let .call(name, args): break
		case .return: append(.return)
		}
	}

}
