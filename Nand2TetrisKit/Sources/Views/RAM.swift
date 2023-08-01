//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct RAM: View {
	@Environment(\.defaultRegisterStyle) private var defaultStyle
	@Environment(\.pedantic) private var pedantic
	@State private var goto: UInt16?

	public var body: some View {
		ScrollViewReader { proxy in
			TextField("GOTO", value: $goto, format: .number)
				.onSubmit {
					if let goto {
						proxy.scrollTo(goto, anchor: .top)
					}
				}
				.textFieldStyle(.roundedBorder)
//			LazyVStack {
//				ForEach(0..<32768) { address in
//					Text(address.description)
//				}
//			}
			List(0..<32768, rowContent: CellRAM.init)
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

	private var _value: Binding<UInt16> {
		Binding {
			vm.ram[address]
		} set: {
			vm.ram[address] = $0
		}
	}

	var body: some View {
		HStack {
			Text(address.description)
				.frame(width: 50, alignment: .trailing)
			TextField(address.description, value: _value, format: .number)
		}
		.foregroundStyle(address == vm.a ? Color.cyan : Color.primary)
		.id(address)
	}
}

#Preview {
	let vm = VirtualMachine()
	vm.ram.randomize()
	return Form {
		Section("RAM") {
			RAM()
		}
	}
	.environment(vm)
	.formStyle(.grouped)
}
#endif
