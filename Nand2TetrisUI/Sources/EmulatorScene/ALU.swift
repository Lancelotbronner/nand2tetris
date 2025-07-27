//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

import Nand2TetrisKit

#if canImport(SwiftUI)
import SwiftUI

public struct ALUView: View {
	@Environment(ObservableMachine.self) private var vm

	public init() { }

	private var primary: some ShapeStyle {
		vm.instruction.isComputing ? .primary : .tertiary
	}

	private var secondary: some ShapeStyle {
		vm.instruction.isComputing ? .secondary : .quaternary
	}

	public var body: some View {
		//TODO: Add help on each of these fields
		Grid(alignment: .leading) {
			GridRow {
				Text("X")
					.foregroundStyle(secondary)
				Text(signed(vm.x))
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("Y")
					.foregroundStyle(secondary)
				Text(signed(vm.y))
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("O")
					.foregroundStyle(secondary)
				Text(signed(vm.o))
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			GridRow {
				Text("X'")
					.foregroundStyle(secondary)
				Text(signed(vm.lhs))
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("Y'")
					.foregroundStyle(secondary)
				Text(signed(vm.rhs))
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("O'")
					.foregroundStyle(secondary)
				Text(signed(vm.result))
					.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
		.monospaced()
		.foregroundStyle(primary)

		HStack {
			VStack(alignment: .trailing) {
				Text(signed(vm.lhs))
				Text(verbatim: "\(vm.op) \(signed(vm.rhs))")
				Text("= ")
					.foregroundStyle(secondary)
				+ Text(signed(vm.result))
			}
			.frame(maxWidth: .infinity, alignment: .center)
			VStack(alignment: .trailing) {
				Text(binary(vm.lhs))
				Text(verbatim: "\(vm.op) \(binary(vm.rhs))")
				Text("= ")
					.foregroundStyle(secondary)
				+ Text(binary(vm.result))
			}
			.frame(maxWidth: .infinity, alignment: .center)
			Text(vm.instruction.computation.description)
				.frame(maxWidth: .infinity, alignment: .center)
		}
		.monospaced()
		.foregroundStyle(primary)
	}

	private func field(_ title: LocalizedStringKey, value: Int16) -> some View {
		(Text(title)
		 + Text(verbatim: " ")
		 + Text(String(value))
			.foregroundStyle(.secondary))
			.frame(maxWidth: .infinity, alignment: .leading)
	}

	private func signed(_ operand: Int16) -> String {
		let tmp = String(operand)
		let padding = String(repeating: " ", count: 6 - tmp.count)
		return padding + tmp
	}

	private func binary(_ operand: Int16) -> String {
		let number = String(UInt16(bitPattern: operand), radix: 2)
		return number.padding(toLength: 16, withPad: "0", startingAt: 0)
	}

}

#Preview {
	let vm = ObservableMachine()
	vm.rom[0] = Instruction(assign: .notY, to: .d, jump: .jmp).rawValue
	return Form {
		ALUView()
	}
	.environment(vm)
	.formStyle(.grouped)
}
#endif
