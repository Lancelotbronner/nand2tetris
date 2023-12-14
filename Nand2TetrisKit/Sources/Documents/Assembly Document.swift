//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
import SwiftUI
import UniformTypeIdentifiers

public struct AssemblyDocument: FileDocument {
	public static var readableContentTypes: [UTType] = [.assemblyN2T]

	public var text: String

	public init(_ text: String = "") {
		self.text = text
	}

	public init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		text = String(data: data, encoding: .utf8) ?? ""
	}
	
	public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = text.data(using: .utf8) ?? Data()
		return FileWrapper(regularFileWithContents: data)
	}
	

}
#endif
