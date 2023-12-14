//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-18.
//

extension Destination: LosslessStringConvertible {

	private static func parse(pedantic description: Substring) -> Destination? {
		switch description {
		case "": .null
		case "A": .a
		case "M": .m
		case "AM": .am
		case "D": .d
		case "AD": .ad
		case "MD": .md
		case "AMD": .amd
		default: nil
		}
	}

	private static func parse(extended description: Substring) -> Destination? {
		switch description {
		case "DM": .md
		case "AM": .am
		case "DA": .ad
		case "MAD", "DMA", "DAM", "ADM", "MDA": .amd
		default: nil
		}
	}

	public static func parse(_ description: Substring, pedantic: Bool) throws -> Destination {
		let description = pedantic ? description : Substring(description.uppercased())
		let _pedantic = Destination.parse(pedantic: description)
		let _extended = Destination.parse(extended: description)
		if let destination = _pedantic ?? (pedantic ? nil : _extended) {
			return destination
		}
		throw AssemblyError.invalidDestination(description, recognized: _extended != nil)
	}

	public init(_ description: Substring, pedantic: Bool) throws {
		self = try Self.parse(description, pedantic: pedantic)
	}

	public init?(_ description: String) {
		try? self.init(Substring(description), pedantic: true)
	}

	public var description: String {
		switch self {
		case .null: ""
		case .a: "A"
		case .m: "M"
		case .d: "D"
		case .am: "AM"
		case .ad: "AD"
		case .md: "MD"
		case .amd: "AMD"
		default: "?"
		}
	}

}
