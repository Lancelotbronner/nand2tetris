//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct Destination: RawRepresentable, OptionSet, Hashable, CaseIterable {

	public static let mask: UInt16 = 0x38

	public var rawValue: UInt16

	@inlinable
	public init(rawValue: UInt16) {
		self.rawValue = rawValue
	}

	@inlinable
	public init(mask rawValue: UInt16) {
		self.init(rawValue: rawValue & Destination.mask)
	}

	public init(bitPattern rawValue: UInt16) {
		self.init(rawValue: (rawValue & 0x7) << 3)
	}

	public static let allCases: [Destination] = [
		.null,
		.m, .d, .a,
		.md, .am, .ad, .amd
	]

	//MARK: - Flags

	public static let null = Destination([])

	public static let a = Destination(rawValue: 0x20)
	public static let d = Destination(rawValue: 0x10)
	public static let m = Destination(rawValue: 0x8)

	public static let md = Destination([.m, .d])
	public static let am = Destination([.m, .a])
	public static let ad = Destination([.d, .a])
	public static let amd = Destination([.m, .d, .a])
}
