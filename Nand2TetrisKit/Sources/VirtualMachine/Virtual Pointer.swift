//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct VirtualPointer: Identifiable {

	public let vm: VirtualMachine
	public let id: Int

	@usableFromInline init(_ offset: Int, in vm: VirtualMachine) {
		self.vm = vm
		self.id = offset
	}

	public var address: UInt16 {
		UInt16(id)
	}

	public var value: UInt16 {
		_read { yield vm._ram[id] }
		nonmutating _modify { yield &vm._ram[id] }
	}

}

#if canImport(Foundation)
import Foundation

extension VirtualPointer {

	public struct ParseStrategy: Foundation.ParseStrategy {
		public var pedantic: Bool
		
		public init(pedantic: Bool) {
			self.pedantic = pedantic
		}
		
		public func parse(_ value: String) throws -> UInt16 {
			var number: UInt16?
			switch value.prefix(2) {
			case "0b": number = UInt16(value.dropFirst(2), radix: 2)
			case "0d": number = UInt16(value.dropFirst(2), radix: 10)
			case "0x": number = UInt16(value.dropFirst(2), radix: 16)
			default:
				guard let tmp = Int(value) else { break }
				if tmp < 0 {
					return UInt16(bitPattern: Int16(tmp))
				} else {
					return UInt16(tmp)
				}
			}
			if let number {
				return number
			}
			
			if let instruction = try Instruction(Substring(value), pedantic: pedantic) {
				return instruction.rawValue
			}
			
			throw AssemblyError.expectedInteger(Substring(value))
		}
	}
	
	public struct BinaryFormat: ParseableFormatStyle {
		public var parseStrategy: ParseStrategy
		
		public init(pedantic: Bool) {
			parseStrategy = ParseStrategy(pedantic: pedantic)
		}
		
		public func format(_ value: UInt16) -> String {
			let formatted = String(value, radix: 2)
			return "0b\(String(repeating: "0", count: 16-formatted.count))\(formatted)"
		}
	}

	public struct HexadecimalFormat: ParseableFormatStyle {
		public var parseStrategy: ParseStrategy

		public init(pedantic: Bool) {
			parseStrategy = ParseStrategy(pedantic: pedantic)
		}

		public func format(_ value: UInt16) -> String {
			"0x" + String(value, radix: 16, uppercase: true)
		}
	}

	public struct UnsignedFormat: ParseableFormatStyle {
		public var parseStrategy: ParseStrategy

		public init(pedantic: Bool) {
			parseStrategy = ParseStrategy(pedantic: pedantic)
		}

		public func format(_ value: UInt16) -> String {
			String(value)
		}
	}

	public struct SignedFormat: ParseableFormatStyle {
		public var parseStrategy: ParseStrategy

		public init(pedantic: Bool) {
			parseStrategy = ParseStrategy(pedantic: pedantic)
		}

		public func format(_ value: UInt16) -> String {
			String(Int16(bitPattern: value))
		}
	}

	public struct AssemblyFormat: ParseableFormatStyle {
		public var parseStrategy: ParseStrategy

		public init(pedantic: Bool) {
			parseStrategy = ParseStrategy(pedantic: pedantic)
		}

		public var pedantic: AssemblyFormat {
			AssemblyFormat(pedantic: true)
		}

		public func format(_ value: UInt16) -> String {
			Instruction(rawValue: value).description
		}
	}

}

extension FormatStyle where FormatInput == UInt16, FormatOutput == String {

	public static var assembly: VirtualPointer.AssemblyFormat { .init(pedantic: false) }

}

#endif
