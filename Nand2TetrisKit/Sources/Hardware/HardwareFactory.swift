//
//  HardwareFactory.swift
//  Nand2TetrisKit
//
//  Created by Christophe Bronner on 2025-01-12.
//

public protocol HardwareFactory {

	func input(named name: String, bitWidth: Int) -> any Wiring
	func output(named name: String, bitWidth: Int) -> any Wiring
	func gate(named name: String) -> (any Hardware)?

}
