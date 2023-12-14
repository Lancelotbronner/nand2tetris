//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

import Nand2Tetris

#if canImport(SwiftUI)
import SwiftUI

public struct RAMView: View {
	@Environment(\.defaultRegisterStyle) private var defaultStyle
	@Environment(\.pedantic) private var pedantic
	@State private var goto: UInt16?

	public init() { }

	public var body: some View {
		ScrollViewReader { proxy in
			TextField("GOTO", value: $goto, format: .number)
				.onSubmit {
					if let goto {
						proxy.scrollTo(Int(goto), anchor: .top)
						self.goto = nil
					}
				}
				.textFieldStyle(.roundedBorder)
			MemoryView()
		}
	}

	private struct MemoryView: View {
		@ScaledMetric var height = 20
		@State private var editing: Int?

		var body: some View {
			ScrollView(.vertical) {
				LazyVStack(spacing: 0) {
					ForEach(0..<32768) { address in
						CellRAM(address, edit: $editing)
							.frame(height: height)
							.id(address)
					}
				}
			}
			.monospaced()
			.scrollContentBackground(.hidden)
			.labelsHidden()
		}
	}
}

private struct CellRAM: View {
	@Environment(VirtualMachine.self) private var vm
	@Binding private var editing: Int?
	private let address: Int

	init(_ address: Int, edit: Binding<Int?>) {
		self.address = address
		_editing = edit
	}

	var body: some View {
		@Bindable var vm = vm
		HStack {
			Text(address.description)
				.frame(width: 50, alignment: .trailing)
			if editing == address {
				DynamicCellRAM(address, edit: $editing)
			} else {
				Text(vm._ram[address], format: .number)
			}
		}
		.foregroundStyle(address == vm.a ? Color.cyan : Color.primary)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
		.contentShape(Rectangle())
		.onTapGesture { editing = address }
	}
}

private struct DynamicCellRAM: View {
	@Environment(VirtualMachine.self) private var vm
	@FocusState private var isFocused: Bool
	@Binding private var editing: Int?
	private let address: Int

	init(_ address: Int, edit: Binding<Int?>) {
		self.address = address
		_editing = edit
	}

	var body: some View {
		@Bindable var vm = vm
		TextField("", value: $vm._ram[address], format: .number)
			.focused($isFocused)
			.onSubmit { editing = nil }
			.onAppear { isFocused = true }
	}
}

#Preview {
	let vm = VirtualMachine()
	vm.ram.randomize()
	return Form {
		Section("RAM") {
			RAMView()
		}
	}
	.environment(vm)
	.formStyle(.grouped)
}
#endif
