//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct ROM: View {
	@Environment(\.pedantic) private var pedantic
	@State private var goto: UInt16?

	public init() { }

	public var body: some View {
		ScrollViewReader { proxy in
			TextField("GOTO", value: $goto, format: .number)
				.onSubmit {
					if let goto {
						proxy.scrollTo(goto, anchor: .top)
					}
				}
				.textFieldStyle(.roundedBorder)
			//					LazyVStack {
			//						ForEach(0..<32768, content: CellRAM.init)
			//					}
			List(0..<32768, rowContent: CellROM.init)
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

	private var _value: Binding<UInt16> {
		Binding {
			vm.rom[address]
		} set: {
			vm.rom[address] = $0
		}
	}

	var body: some View {
		HStack {
			Text(address.description)
				.frame(width: 50, alignment: .trailing)
			TextField(address.description, value: _value, format: VirtualPointer.AssemblyFormat(pedantic: pedantic))
		}
		.foregroundStyle(address == vm.pc ? Color.cyan : Color.primary)
		.id(address)
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
