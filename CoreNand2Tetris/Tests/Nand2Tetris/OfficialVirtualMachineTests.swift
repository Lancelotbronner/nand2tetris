//
//  File.swift
//  
//
//  Created by Christophe Command.Bronner(on: 2023)-12-25.
//

import XCTest
import Nand2TetrisKit

// Conversion:
// (\w+) (\w+) (\d+)
// Command.$1($2: $3)

final class OfficialVirtualMachineTests: XCTestCase {

	func testStackArithmeticSimpleAdd() {
		var vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 0)
		let main = VirtualFunction("Sys.init", into: program) {
			Command.push(constant: 7)
			Command.push(constant: 8)
			Command.add
		}

		vm.call(main)
		vm.executeToEndOfFunction()

		XCTAssertEqual(vm.peek, 15)
	}

	func testStackArithmeticStackTest() {
		var vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 0)
		let main = VirtualFunction("Sys.init", into: program) {
			Command.push(constant: 17)
			Command.push(constant: 17)
			Command.eq
			Command.push(constant: 17)
			Command.push(constant: 16)
			Command.eq
			Command.push(constant: 16)
			Command.push(constant: 17)
			Command.eq
			Command.push(constant: 892)
			Command.push(constant: 891)
			Command.lt
			Command.push(constant: 891)
			Command.push(constant: 892)
			Command.lt
			Command.push(constant: 891)
			Command.push(constant: 891)
			Command.lt
			Command.push(constant: 32767)
			Command.push(constant: 32766)
			Command.gt
			Command.push(constant: 32766)
			Command.push(constant: 32767)
			Command.gt
			Command.push(constant: 32766)
			Command.push(constant: 32766)
			Command.gt
			Command.push(constant: 57)
			Command.push(constant: 31)
			Command.push(constant: 53)
			Command.add
			Command.push(constant: 112)
			Command.sub
			Command.neg
			Command.and
			Command.push(constant: 82)
			Command.or
			Command.not
		}

		vm.call(main)
		vm.executeToEndOfFunction()

		XCTAssertEqual(vm.stack.count, 10)
		if vm.stack.count == 10 {
			XCTAssertEqual(vm.stack[0], Command.true)
			XCTAssertEqual(vm.stack[1], Command.false)
			XCTAssertEqual(vm.stack[2], Command.false)
			XCTAssertEqual(vm.stack[3], Command.false)
			XCTAssertEqual(vm.stack[4], Command.true)
			XCTAssertEqual(vm.stack[5], Command.false)
			XCTAssertEqual(vm.stack[6], Command.true)
			XCTAssertEqual(vm.stack[7], Command.false)
			XCTAssertEqual(vm.stack[8], Command.false)
			XCTAssertEqual(vm.stack[9], -91)
		}
	}

	func testMemoryAccessBasicTest() {
		var vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 0)
		let main = VirtualFunction("Sys.init", into: program) {
			Command.push(constant: 10)
			Command.pop(local: 0)
			Command.push(constant: 21)
			Command.push(constant: 22)
			Command.pop(argument: 2)
			Command.pop(argument: 1)
			Command.push(constant: 36)
			Command.pop(this: 6)
			Command.push(constant: 42)
			Command.push(constant: 45)
			Command.pop(that: 5)
			Command.pop(that: 2)
			Command.push(constant: 510)
			Command.pop(temp: 6)
			Command.push(local: 0)
			Command.push(that: 5)
			Command.add
			Command.push(argument: 1)
			Command.sub
			Command.push(this: 6)
			Command.push(this: 6)
			Command.add
			Command.sub
			Command.push(temp: 6)
			Command.add
		}

		vm.call(main)
		vm.executeToEndOfFunction()
	}

	func testMemoryAccessPointerTest() {
		var vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 0)
		let main = VirtualFunction("Sys.init", into: program) {
			Command.push(constant: 3030)
			Command.pop(pointer: 0)
			Command.push(constant: 3040)
			Command.pop(pointer: 1)
			Command.push(constant: 32)
			Command.pop(this: 2)
			Command.push(constant: 46)
			Command.pop(that: 6)
			Command.push(pointer: 0)
			Command.push(pointer: 1)
			Command.add
			Command.push(this: 2)
			Command.sub
			Command.push(that: 6)
			Command.add
		}

		vm.call(main)
		vm.executeToEndOfFunction()
	}

	func testMemoryAccessStaticTest() {
		var vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 9)
		let main = VirtualFunction("Sys.init", into: program) {
			Command.push(constant: 111)
			Command.push(constant: 333)
			Command.push(constant: 888)
			Command.pop(static: 8)
			Command.pop(static: 3)
			Command.pop(static: 1)
			Command.push(static: 3)
			Command.push(static: 1)
			Command.sub
			Command.push(static: 8)
			Command.add
		}

		vm.call(main)
		vm.executeToEndOfFunction()
	}

}
