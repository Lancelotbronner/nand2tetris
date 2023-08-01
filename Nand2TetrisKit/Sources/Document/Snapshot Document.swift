//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
import SwiftUI
import UniformTypeIdentifiers

public struct SnapshotDocument: FileDocument {
	public static var readableContentTypes: [UTType] = [.snapshotN2T]

	public let snapshot: VirtualSnapshot

	public init(_ snapshot: VirtualSnapshot) {
		self.snapshot = snapshot
	}

	public init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		snapshot = VirtualSnapshot(data)
	}
	
	public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		FileWrapper(regularFileWithContents: snapshot.data)
	}
	
}
#endif
