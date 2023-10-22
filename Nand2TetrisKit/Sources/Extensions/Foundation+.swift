//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

#if canImport(Foundation)
import Foundation

extension Data {

	internal mutating func append<T>(bytesOf value: T) {
		var tmp = value
		Swift.withUnsafeBytes(of: &tmp) { buffer in
			append(buffer.bindMemory(to: UInt8.self))
		}
	}

	internal func read<T>(_: T.Type = T.self) -> T? {
		withUnsafeBytes { buffer in
			buffer.bindMemory(to: T.self).first
		}
	}

	internal func read<T>(_ count: Int, _: T.Type = T.self) -> [T] {
		withUnsafeBytes { buffer in
			Array(buffer.bindMemory(to: T.self).prefix(count))
		}
	}

	internal func read<T>(as _: T.Type = T.self) -> [T] {
		withUnsafeBytes { buffer in
			Array(buffer.bindMemory(to: T.self))
		}
	}

	internal mutating func consume<T>(_: T.Type = T.self) -> T? {
		guard let payload = read(T.self) else { return nil }
		removeFirst(MemoryLayout<T>.size)
		return payload
	}

	internal mutating func consume<T>(_ count: Int, _: T.Type = T.self) -> [T] {
		let payload = read(count, T.self)
		removeFirst(MemoryLayout<T>.stride * count)
		return payload
	}

}
#endif
