//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-04-19.
//

import SwiftUI
import Nand2TetrisKit

private struct AssemblerKey: EnvironmentKey {
	static let defaultValue = Assembler()
}

extension EnvironmentValues {
	public var assembler: Assembler {
		get { self[AssemblerKey.self] }
		set { self[AssemblerKey.self] = newValue }
	}
}
