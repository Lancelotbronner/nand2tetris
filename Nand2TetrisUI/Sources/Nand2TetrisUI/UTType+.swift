//
//  UTType+.swift
//  Nand2TetrisUI
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers

public extension UTType {
	static let assemblyN2T = UTType(exportedAs: "org.nand2tetris.assembly", conformingTo: .assemblyLanguageSource)

	static let romN2T = UTType(exportedAs: "org.nand2tetris.rom", conformingTo: .data)

	static let snapshotN2T = UTType(exportedAs: "org.nand2tetris.snapshot", conformingTo: .data)
}
#endif
