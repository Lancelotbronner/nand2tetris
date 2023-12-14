//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
import SwiftUI
import UniformTypeIdentifiers

public struct ROMDocument: FileDocument {
	public static var readableContentTypes: [UTType] = [.romN2T]

	public var contents: [UInt16]

	public init(_ contents: [UInt16] = []) {
		self.contents = contents
	}

	public init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		contents = data.withUnsafeBytes { buffer in
			Array(buffer.bindMemory(to: UInt16.self))
		}
	}
	
	public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		contents.withUnsafeBytes { buffer in
			FileWrapper(regularFileWithContents: Data(buffer: buffer.bindMemory(to: UInt16.self)))
		}
	}
	

}
#endif
