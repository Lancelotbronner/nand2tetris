//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-28.
//

import XCTest
import XCTNand2Tetris
import Nand2Tetris

final class AssemblerTests: XCTestCase {

	func testInitialVariableAllocation() {
		XCTAssertEqual(TestUtils.assemble("@test", pedantic: true).program, [
			16,
		])
	}

}
