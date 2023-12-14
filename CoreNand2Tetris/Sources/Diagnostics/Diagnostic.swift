//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-21.
//

public struct Diagnostic: Error, CustomStringConvertible, CustomDebugStringConvertible {
	public let file: String?
	public let line: Int
	public let column: Int
	public let source: Substring?
	public let message: AssemblyError

	public init(message: AssemblyError, from source: Substring?, at line: Int, _ column: Int = 0, of file: String?) {
		self.file = file
		self.line = line
		self.column = column
		self.source = source
		self.message = message
	}

	public var description: String {
		"[\(file ?? ""):\(line)] \(message)"
	}

	public var debugDescription: String {
		let marker = String(repeating: " ", count: column) + "^"
		return "\(description)\n\(source ?? "")\n\(marker)"
	}
}
