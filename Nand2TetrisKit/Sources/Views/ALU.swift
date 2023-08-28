//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct ALU: View {
	@Environment(VirtualMachine.self) private var vm

	public init() { }

	public var body: some View {
		Grid(alignment: .leading) {
			GridRow {
				Text("X")
				Text(signed(vm.x))
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("Y")
				Text(signed(vm.y))
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("O")
				Text(signed(vm.o))
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			GridRow {
				Text("X'")
				Text(signed(vm.lhs))
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("Y'")
				Text(signed(vm.rhs))
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("O'")
				Text(signed(vm.result))
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
		.monospaced()
		HStack {
			VStack(alignment: .trailing) {
				Text(signed(vm.lhs))
				Text(verbatim: "\(vm.op) \(signed(vm.rhs))")
				Text("= \(signed(vm.result))")
			}
			.frame(maxWidth: .infinity, alignment: .center)
			VStack(alignment: .trailing) {
				Text(binary(vm.lhs))
				Text(verbatim: "\(vm.op) \(binary(vm.rhs))")
				Text("= \(binary(vm.result))")
			}
			.frame(maxWidth: .infinity, alignment: .center)
		}
		.monospaced()
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
	let vm = VirtualMachine()
	vm.rom[0] = Instruction(assign: .notY, to: .d, jump: .jmp).rawValue
	return Form {
		ALU()
	}
	.environment(vm)
	.formStyle(.grouped)
}
#endif
