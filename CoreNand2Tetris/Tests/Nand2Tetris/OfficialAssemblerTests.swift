//
//  File.swift
//
//
//  Created by Christophe Bronner on 2023-10-21.
//

import XCTest
import XCTNand2Tetris
import Nand2TetrisKit

final class OfficialAssemblerTests: XCTestCase {

	/// Ensures the official `Add` example program works
	func testOfficialAdd() throws {
		XCTAssert(try TestUtils.assemble(contentsOf: "Add", pedantic: true))
		XCTAssert(try TestUtils.assemble(contentsOf: "Add", pedantic: false))
	}

	func testOfficialMax() throws {
		XCTAssert(try TestUtils.assemble(contentsOf: "Max", pedantic: true))
		XCTAssert(try TestUtils.assemble(contentsOf: "Max", pedantic: false))
	}

	func testOfficialPong() throws {
		XCTAssert(try TestUtils.assemble(contentsOf: "Pong", pedantic: true))
		XCTAssert(try TestUtils.assemble(contentsOf: "Pong", pedantic: false))
	}

	func testOfficialRect() throws {
		XCTAssert(try TestUtils.assemble(contentsOf: "Rect", pedantic: true))
		XCTAssert(try TestUtils.assemble(contentsOf: "Rect", pedantic: false))
	}

}
