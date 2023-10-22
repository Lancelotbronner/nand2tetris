//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

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
						proxy.scrollTo(goto, anchor: .top)
						self.goto = nil
					}
				}
				.textFieldStyle(.roundedBorder)
			MemoryView()
		}
	}

	private struct MemoryView: View {
		var body: some View {
			List(0..<32768) { address in
				CellROM(address)
					.id(address)
			}
			.monospaced()
		}
	}
}

internal struct CellROM: View {
	@Environment(VirtualMachine.self) private var vm
	@Environment(\.pedantic) private var pedantic
	let address: Int

	init(_ address: Int) {
		self.address = address
	}

	var body: some View {
		@Bindable var vm = vm
		HStack {
			Text(address.description)
				.frame(width: 50, alignment: .trailing)
			TextField(address.description, value: $vm._rom[address], format: VirtualPointer.AssemblyFormat(pedantic: pedantic))
		}
		.foregroundStyle(address == vm.pc ? Color.cyan : Color.primary)
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
