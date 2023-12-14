//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

import Nand2Tetris

#if canImport(SwiftUI)
import SwiftUI

public struct ROM: View {
	@Environment(VirtualMachine.self) private var vm
	@Environment(\.pedantic) private var pedantic
	@State private var goto: UInt16?
	@State private var selection: UInt16?

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
			MemoryView()
		}
		.textFieldStyle(.roundedBorder)
	}

	private struct MemoryView: View {
		@ScaledMetric var height = 20
		@State private var editing: Int?

		var body: some View {
			ScrollView(.vertical) {
				LazyVStack(spacing: 0) {
					ForEach(0..<32768) { address in
						CellROM(address, edit: $editing)
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

private struct CellROM: View {
	@Environment(VirtualMachine.self) private var vm
	@Environment(\.pedantic) private var pedantic
	@Binding private var editing: Int?
	private let address: Int

	init(_ address: Int, edit: Binding<Int?>) {
		self.address = address
		_editing = edit
	}

	var body: some View {
		HStack {
			Text(address.description)
				.frame(width: 50, alignment: .trailing)
			if editing == address {
				DynamicCellROM(address, edit: $editing)
			} else {
				Text(vm._rom[address], format: VirtualPointer.AssemblyFormat(pedantic: pedantic))
			}
		}
		.foregroundStyle(address == vm.pc ? Color.cyan : Color.primary)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
		.contentShape(Rectangle())
		.onTapGesture { editing = address }
	}
}

private struct DynamicCellROM: View {
	@Environment(VirtualMachine.self) private var vm
	@Environment(\.pedantic) private var pedantic
	@FocusState private var isFocused: Bool
	@Binding private var editing: Int?
	private let address: Int

	init(_ address: Int, edit: Binding<Int?>) {
		self.address = address
		_editing = edit
	}

	var body: some View {
		@Bindable var vm = vm
		TextField("", value: $vm._rom[address], format: VirtualPointer.AssemblyFormat(pedantic: pedantic))
			.focused($isFocused)
			.onSubmit { editing = nil }
			.onAppear { isFocused = true }
	}
}

#Preview {
	let vm = VirtualMachine()
	vm.rom.randomize()
	vm.rom[4] = 0
	return Form {
		Section("ROM") {
			ROM()
		}
	}
	.environment(vm)
	.formStyle(.grouped)
}
#endif
