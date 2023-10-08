//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct VirtualSnapshot {

	public init() {
		title = ""
		pc = 0
		d = 0
		a = 0
		rom = []
		ram = []
	}

	public init(_ title: String, of vm: VirtualMachine) {
		self.title = title
		pc = vm.pc
		d = vm.d
		a = vm.a
		rom = vm._rom
		ram = vm._ram
	}

	/// Arbitrary title for the snapshot, such as the loaded file or a labeled bugged state.
	public var title: String

	//MARK: - CPU

	/// The program counter.
	public var pc: UInt16

	/// The data register.
	public var d: UInt16

	/// The address register.
	public var a: UInt16

	//MARK: - ROM

	/// The read-only memory of the computer
	public var rom: [UInt16]

	//MARK: - RAM

	/// The read-write memory of the computer
	public var ram: [UInt16]

}

#if canImport(Foundation)
import Foundation

extension VirtualSnapshot {

	public init(_ data: Data) {
		var data = data
		let _title = data
			.firstIndex(of: 0)
			.flatMap(data.prefix(upTo:))
		data = data.dropFirst((_title?.count ?? 0) + 1)
		title = _title.flatMap { String(data: $0, encoding: .utf8) } ?? ""
		pc = data.consume() ?? 0
		d = data.consume() ?? 0
		a = data.consume() ?? 0
		rom = data.consume(VirtualMachine.memory)
		ram = data.consume(VirtualMachine.memory)
	}

	public var data: Data {
		var data = Data()
		data.reserveCapacity(VirtualMachine.memory * 2 + 6 + title.count * 2)
		if let title = title.data(using: .utf8) {
			data.append(title)
		}
		data.append(0)
		data.append(bytesOf: pc)
		data.append(bytesOf: d)
		data.append(bytesOf: a)
		rom.withUnsafeBytes { buffer in
			data.append(buffer.bindMemory(to: UInt8.self))
		}
		ram.withUnsafeBytes { buffer in
			data.append(buffer.bindMemory(to: UInt8.self))
		}
		return data
	}

}
#endif
