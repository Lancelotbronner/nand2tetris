//
//  VirtualAssembly.swift
//  Nand2TetrisCompanionKit
//
//  Created by Christophe Bronner on 2024-08-13.
//

import SwiftUI

@Observable
public final class VirtualAssemblyModel {

	public init() { }

	/// Source code of the VM code.
	public var source = "" {
		didSet { lines = source.split(separator: "\n", omittingEmptySubsequences: false) }
	}

	public var lines: [Substring] = []

}

extension EnvironmentValues {
	@Entry var virtualAssembly = VirtualAssemblyModel()
}
