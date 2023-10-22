//
//  File.swift
//
//
//  Created by Christophe Bronner on 2023-10-21.
//

import XCTest
import Nand2TetrisKit

final class AssemblerTests: XCTestCase {

	/// Ensures the official `Add` example program works
	func testOfficialAdd() throws {
		XCTAssert(try TestUtils.assemble("Add", pedantic: true))
		XCTAssert(try TestUtils.assemble("Add", pedantic: false))
	}

	func testOfficialMax() throws {
		XCTAssert(try TestUtils.assemble("Max", pedantic: true))
		XCTAssert(try TestUtils.assemble("Max", pedantic: false))
	}

	func testOfficialPong() throws {
		XCTAssert(try TestUtils.assemble("Pong", pedantic: true))
		XCTAssert(try TestUtils.assemble("Pong", pedantic: false))
	}

	func testOfficialRect() throws {
		XCTAssert(try TestUtils.assemble("Rect", pedantic: true))
		XCTAssert(try TestUtils.assemble("Rect", pedantic: false))
	}

}
