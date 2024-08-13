//
//  Translator.swift
//  Nand2TetrisKit
//
//  Created by Christophe Bronner on 2024-08-13.
//

import Observation

@Observable
public final class Translator {

	public init(pedantic: Bool = true) {
		self.pedantic = pedantic
	}

	//MARK: - Commands Management

	//MARK: - Configuration Management

	/// Whether the translator should only accept the standard.
	public var pedantic = true

	//MARK: - Diagnostics Management

	//MARK: - Unit Management

	//MARK: - Function Management

	//MARK: - Program Management

}
