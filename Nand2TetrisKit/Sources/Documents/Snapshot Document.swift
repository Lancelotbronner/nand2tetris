//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

import Nand2TetrisKit

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
import SwiftUI
import UniformTypeIdentifiers

public struct SnapshotDocument: FileDocument {
	public static var readableContentTypes: [UTType] = [.snapshotN2T]

	public let snapshot: EmulatorSnapshot

	public init(_ snapshot: EmulatorSnapshot) {
		self.snapshot = snapshot
	}

	public init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		snapshot = EmulatorSnapshot(data)
	}
	
	public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		FileWrapper(regularFileWithContents: snapshot.data)
	}
	
}
#endif
