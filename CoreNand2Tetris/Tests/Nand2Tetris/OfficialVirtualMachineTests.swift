//
//  File.swift
//  
//
//  Created by Christophe Command.Bronner(on: 2023)-12-25.
//

import XCTest
import Nand2TetrisKit

final class OfficialVirtualMachineTests: XCTestCase {

	func testStackArithmeticSimpleAdd() {
		let vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 0)
		let main = VirtualFunction("Sys.init", into: program) {
			VirtualInstruction.push(constant: 7)
			VirtualInstruction.push(constant: 8)
			VirtualInstruction.add
		}

		vm.call(main, 0)
		vm.executeToEndOfFunction()

		XCTAssertEqual(vm.peek, 15)
	}

	func testStackArithmeticStackTest() {
		let vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 0)
		let main = VirtualFunction("Sys.init", into: program) {
			VirtualInstruction.push(constant: 17)
			VirtualInstruction.push(constant: 17)
			VirtualInstruction.eq
			VirtualInstruction.push(constant: 17)
			VirtualInstruction.push(constant: 16)
			VirtualInstruction.eq
			VirtualInstruction.push(constant: 16)
			VirtualInstruction.push(constant: 17)
			VirtualInstruction.eq
			VirtualInstruction.push(constant: 892)
			VirtualInstruction.push(constant: 891)
			VirtualInstruction.lt
			VirtualInstruction.push(constant: 891)
			VirtualInstruction.push(constant: 892)
			VirtualInstruction.lt
			VirtualInstruction.push(constant: 891)
			VirtualInstruction.push(constant: 891)
			VirtualInstruction.lt
			VirtualInstruction.push(constant: 32767)
			VirtualInstruction.push(constant: 32766)
			VirtualInstruction.gt
			VirtualInstruction.push(constant: 32766)
			VirtualInstruction.push(constant: 32767)
			VirtualInstruction.gt
			VirtualInstruction.push(constant: 32766)
			VirtualInstruction.push(constant: 32766)
			VirtualInstruction.gt
			VirtualInstruction.push(constant: 57)
			VirtualInstruction.push(constant: 31)
			VirtualInstruction.push(constant: 53)
			VirtualInstruction.add
			VirtualInstruction.push(constant: 112)
			VirtualInstruction.sub
			VirtualInstruction.neg
			VirtualInstruction.and
			VirtualInstruction.push(constant: 82)
			VirtualInstruction.or
			VirtualInstruction.not
		}

		vm.call(main, 0)
		vm.executeToEndOfFunction()

		XCTAssertEqual(vm.stack.count, 10)
		if vm.stack.count == 10 {
			XCTAssertEqual(vm.stack[0], VirtualInstruction.true)
			XCTAssertEqual(vm.stack[1], VirtualInstruction.false)
			XCTAssertEqual(vm.stack[2], VirtualInstruction.false)
			XCTAssertEqual(vm.stack[3], VirtualInstruction.false)
			XCTAssertEqual(vm.stack[4], VirtualInstruction.true)
			XCTAssertEqual(vm.stack[5], VirtualInstruction.false)
			XCTAssertEqual(vm.stack[6], VirtualInstruction.true)
			XCTAssertEqual(vm.stack[7], VirtualInstruction.false)
			XCTAssertEqual(vm.stack[8], VirtualInstruction.false)
			XCTAssertEqual(vm.stack[9], -91)
		}
	}

	func testMemoryAccessBasicTest() {
		let vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 0)
		let main = VirtualFunction("Sys.init", into: program) {
			VirtualInstruction.push(constant: 10)
			VirtualInstruction.pop(local: 0)
			VirtualInstruction.push(constant: 21)
			VirtualInstruction.push(constant: 22)
			VirtualInstruction.pop(argument: 2)
			VirtualInstruction.pop(argument: 1)
			VirtualInstruction.push(constant: 36)
			VirtualInstruction.pop(this: 6)
			VirtualInstruction.push(constant: 42)
			VirtualInstruction.push(constant: 45)
			VirtualInstruction.pop(that: 5)
			VirtualInstruction.pop(that: 2)
			VirtualInstruction.push(constant: 510)
			VirtualInstruction.pop(temp: 6)
			VirtualInstruction.push(local: 0)
			VirtualInstruction.push(that: 5)
			VirtualInstruction.add
			VirtualInstruction.push(argument: 1)
			VirtualInstruction.sub
			VirtualInstruction.push(this: 6)
			VirtualInstruction.push(this: 6)
			VirtualInstruction.add
			VirtualInstruction.sub
			VirtualInstruction.push(temp: 6)
			VirtualInstruction.add
		}

		vm.push(8)
		vm.call(main, 1)
		vm.executeToEndOfFunction()
	}

	func testMemoryAccessPointerTest() {
		let vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 0)
		let main = VirtualFunction("Sys.init", into: program) {
			VirtualInstruction.push(constant: 3030)
			VirtualInstruction.pop(pointer: 0)
			VirtualInstruction.push(constant: 3040)
			VirtualInstruction.pop(pointer: 1)
			VirtualInstruction.push(constant: 32)
			VirtualInstruction.pop(this: 2)
			VirtualInstruction.push(constant: 46)
			VirtualInstruction.pop(that: 6)
			VirtualInstruction.push(pointer: 0)
			VirtualInstruction.push(pointer: 1)
			VirtualInstruction.add
			VirtualInstruction.push(this: 2)
			VirtualInstruction.sub
			VirtualInstruction.push(that: 6)
			VirtualInstruction.add
		}

		vm.call(main, 0)
		vm.executeToEndOfFunction()
	}

	func testMemoryAccessStaticTest() {
		let vm = ObservableVirtualMachine()

		let program = VirtualUnit("program", statics: 9)
		let main = VirtualFunction("Sys.init", into: program) {
			VirtualInstruction.push(constant: 111)
			VirtualInstruction.push(constant: 333)
			VirtualInstruction.push(constant: 888)
			VirtualInstruction.pop(static: 8)
			VirtualInstruction.pop(static: 3)
			VirtualInstruction.pop(static: 1)
			VirtualInstruction.push(static: 3)
			VirtualInstruction.push(static: 1)
			VirtualInstruction.sub
			VirtualInstruction.push(static: 8)
			VirtualInstruction.add
		}

		vm.call(main, 0)
		vm.executeToEndOfFunction()
	}

}
