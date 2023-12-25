//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import XCTest
import Nand2Tetris

final class OfficialVirtualMachineTests: XCTestCase {

	@available(macOS 14.0, *)
	func testSimpleAdd() {
		let vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 0)
		let main = VirtualFunction("Sys.init", into: program) {
			Command.push(constant: 7)
			Command.push(constant: 8)
			Command.add
		}

		vm.main(main)
		vm.cycle(3)

		XCTAssertEqual(vm.pop, 15)
	}

}
