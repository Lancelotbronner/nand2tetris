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

	private var x: Int16 {
		var tmp = vm.x
		VirtualMachine.alu(vm.instruction, x: &tmp)
		return tmp
	}

	private var y: Int16 {
		var tmp = vm.y
		VirtualMachine.alu(vm.instruction, y: &tmp)
		return tmp
	}

	public var body: some View {
		HStack {
			field("X", value: x)
			field("Y", value: y)
			field("O", value: vm.o)
		}
		HStack {
			HStack {
				Text("i")
					.foregroundStyle(vm.instruction.i && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Divider()
				Text("zx")
					.foregroundStyle(vm.instruction.zx && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Text("nx")
					.foregroundStyle(vm.instruction.nx && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Text("zy")
					.foregroundStyle(vm.instruction.zy && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Text("ny")
					.foregroundStyle(vm.instruction.ny && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Text("f")
					.foregroundStyle(vm.instruction.f && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Text("no")
					.foregroundStyle(vm.instruction.no && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Divider()
				Text("a")
					.foregroundStyle(vm.instruction.a && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Text("d")
					.foregroundStyle(vm.instruction.d && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Text("m")
					.foregroundStyle(vm.instruction.m && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Divider()
				Text("gt")
					.foregroundStyle(vm.instruction.gt && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Text("eq")
					.foregroundStyle(vm.instruction.eq && vm.instruction.isComputing ? Color.accentColor : .secondary)
				Text("lt")
					.foregroundStyle(vm.instruction.lt && vm.instruction.isComputing ? Color.accentColor : .secondary)
			}
			.monospaced()
			Spacer()
			Text(vm.instruction.description)
				.monospaced()
		}
	}

	private func field(_ title: LocalizedStringKey, value: Int16) -> some View {
		LabeledContent {
			if vm.instruction.f {
				Text(String(value))
			} else {
				Text(UInt16(bitPattern: value), format: VirtualPointer.SignedFormat(pedantic: true))
			}
		} label: {
			Text(title)
		}
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
