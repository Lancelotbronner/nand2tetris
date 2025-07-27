//
//  Hardware.swift
//  Nand2TetrisKit
//
//  Created by Christophe Bronner on 2025-01-12.
//

public protocol Wiring {
	var bitWidth: Int { get }
	var value: Int { get nonmutating set }
}

public extension Wiring {
	var booleanValue: Bool {
		get { value != 0 }
		nonmutating set { value = newValue ? 1 : 0 }
	}
}

public protocol SimulatedHardware {

	/// Executes a tick (rising) cycle.
	func tick()

	/// Executes a tock (falling) cycle.
	func tock()

}

public protocol InputHardware {
	var outputs: [any Wiring] { get set }

	func send(to output: any OutputHardware)
}

public protocol OutputHardware {
	var inputs: [any Wiring] { get }

	func receive(from input: any InputHardware)
}

public protocol Hardware {
	var inputs: [any Wiring] { get }
	var outputs: [any Wiring] { get }
}
