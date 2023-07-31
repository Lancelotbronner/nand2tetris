//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct Jump: RawRepresentable, OptionSet, CaseIterable {

	public var rawValue: UInt16

	public init(rawValue: UInt16) {
		self.rawValue = rawValue
	}

	public init(mask rawValue: UInt16) {
		self.init(rawValue: rawValue & 0x7)
	}

	public init(bitPattern rawValue: UInt16) {
		self.init(mask: rawValue)
	}

	public static let allCases: [Jump] = [
		.none,
		.jgt, .jeq, .jge, .jlt, .jne, .jle, .jmp
	]

	//MARK: - Flags

	public static let none = Jump([])

	public static let jgt = Jump(rawValue: 0x1)
	public static let jeq = Jump(rawValue: 0x2)
	public static let jge = Jump([.jgt, .jeq])
	public static let jlt = Jump(rawValue: 0x4)
	public static let jne = Jump([.jlt, .jgt])
	public static let jle = Jump([.jlt, .jeq])
	public static let jmp = Jump([.jlt, .jeq, .jgt])

}
