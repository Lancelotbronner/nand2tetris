//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers

extension UTType {

	public static let assemblyN2T = UTType(exportedAs: "org.nand2tetris.assembly", conformingTo: .assemblyLanguageSource)

	public static let romN2T = UTType(exportedAs: "org.nand2tetris.rom", conformingTo: .data)

	public static let snapshotN2T = UTType(exportedAs: "org.nand2tetris.snapshot", conformingTo: .data)

}
#endif
