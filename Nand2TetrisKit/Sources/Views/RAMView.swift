//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

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
						proxy.scrollTo(goto, anchor: .top)
						self.goto = nil
					}
				}
				.textFieldStyle(.roundedBorder)
			List(0..<32768) { address in
				CellRAM(address)
					.id(address)
			}
			.monospaced()
			.multilineTextAlignment(.trailing)
		}
	}
}

internal struct CellRAM: View {
	@Environment(VirtualMachine.self) private var vm
	let address: Int

	init(_ address: Int) {
		self.address = address
	}

	var body: some View {
		@Bindable var vm = vm
		HStack {
			Text(address.description)
				.frame(width: 50, alignment: .trailing)
			TextField(address.description, value: $vm._ram[address], format: .number)
		}
		.foregroundStyle(address == vm.a ? Color.cyan : Color.primary)
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
