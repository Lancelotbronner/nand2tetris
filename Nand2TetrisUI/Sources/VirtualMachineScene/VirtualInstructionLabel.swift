//
//  VirtualInstructionLabel.swift
//  Nand2TetrisCompanionKit
//
//  Created by Christophe Bronner on 2025-04-23.
//

import SwiftUI
import Nand2TetrisKit
import Nand2TetrisUI

struct VirtualInstructionLabel: View {
	@Environment(\.pedantic) private var pedantic
	let instruction: VirtualInstruction

	init(_ instruction: VirtualInstruction) {
		self.instruction = instruction
	}

	var body: some View {
		label
			.monospaced()
	}

	private var label: Text {
		switch instruction {
		case .add: keyword("add")
		case .sub: keyword("sub")
		case .neg: keyword("neg")
		case .eq: keyword("eq")
		case .gt: keyword("gt")
		case .lt: keyword("lt")
		case .and: keyword("and")
		case .or: keyword("or")
		case .not: keyword("not")
		case let .push(segment, address): keyword("push") + space + memory(segment) + space + number(address)
		case let .pop(segment, offset): keyword("pop") + space + memory(segment) + space + number(offset)
		case let .goto(address): keyword("goto") + space + number(address)
		case let .gotor(offset): keyword("goto") + space + number(offset)
		case let .if(address): keyword("if") + space + number(address)
		case let .ifr(offset): keyword("if") + space + number(offset)
		case let .call(function, args): keyword("call") + space + symbol(function.name) + space + number(args)
		case .return: keyword("return")
		}
	}

	private var space: Text {
		Text(verbatim: " ")
	}

	private func keyword(_ label: LocalizedStringKey) -> Text {
		Text(label)
			.foregroundStyle(.pink)
	}

	private func memory(_ segment: MemorySegment) -> Text {
		Text(segment.title)
			.foregroundStyle(.purple)
	}

	private func symbol(_ name: String) -> Text {
		Text(name)
			.foregroundStyle(.mint)
	}

	private func number(_ address: UInt16) -> Text {
		Text(address, format: Hack.UnsignedFormat(pedantic: pedantic))
			.foregroundStyle(.yellow)
	}

	private func number(_ offset: Int16) -> Text {
		Text(offset.description)
			.foregroundStyle(.yellow)
	}
}

extension VirtualInstruction {
	var keywordLabel: Text {
		switch self {
		case .add: Text("add")
		case .sub: Text("sub")
		case .neg: Text("neg")
		case .eq: Text("eq")
		case .gt: Text("gt")
		case .lt: Text("lt")
		case .and: Text("and")
		case .or: Text("or")
		case .not: Text("not")
		case .push: Text("push")
		case .pop: Text("pop")
		case .goto, .gotor: Text("goto")
		case .if, .ifr: Text("if")
		case .call: Text("call")
		case .return: Text("return")
		}
	}

	var symbolLabel: Text? {
		if case let .call(function, _) = self {
			Text(function.name)
		} else {
			nil
		}
	}

	var segmentLabel: Text? {
		switch self {
		case let .push(segment, _): Text(segment.title)
		case let .pop(segment, _): Text(segment.title)
		default: nil
		}
	}

	var numberLabel: Text? {
		switch self {
		case
			let .pop(_, n),
			let .push(_, n),
			let .call(_, n),
			let .goto(n),
			let .if(n):
			Text(n, format: .number.grouping(.never))
		case
			let .gotor(n),
			let .ifr(n):
			Text(n, format: .number.grouping(.never).sign(strategy: .always()))
		default: nil
		}
	}
}

extension MemorySegment {
	var title: LocalizedStringKey {
		switch self {
		case .argument: "argument"
		case .local: "local"
		case .static: "static"
		case .constant: "constant"
		case .this: "this"
		case .that: "that"
		case .pointer: "pointer"
		case .temp: "temp"
		}
	}
}

#Preview {
	VStack(alignment: .leading) {
		VirtualInstructionLabel(.push(.constant, offset: 24))
		VirtualInstructionLabel(.goto(12))
		VirtualInstructionLabel(.push(.this, offset: 24))
	}
	.padding()
}
