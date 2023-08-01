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
	private let vm: VirtualMachine

	public init(_ vm: VirtualMachine) {
		self.vm = vm
	}

	private var values: AnyRandomAccessCollection<VirtualPointer> {
		AnyRandomAccessCollection(vm.ram.indices.lazy.map { i in
			VirtualPointer(i, in: vm.ram)
		})
	}

	public var body: some View {
		ScrollViewReader { proxy in
			TextField("GOTO", value: $goto, format: .number)
				.onSubmit {
					if let goto {
						proxy.scrollTo(goto, anchor: .top)
					}
				}
				.textFieldStyle(.roundedBorder)
				.onAppear {
					proxy.scrollTo(vm.a)
				}
			Table(values) {
				TableColumn("Address") { pointer in
					Text(pointer.address.description)
						.monospaced()
						.foregroundStyle(pointer.address == vm.a ? Color.cyan : Color.primary)
						.id(pointer.address)
				}
				.width(50)
				.alignment(.trailing)
				TableColumn("Value") { pointer in
					TextField("", value: pointer.binding, format: VirtualPointer.SignedFormat(pedantic: pedantic))
						.monospaced()
						.multilineTextAlignment(.trailing)
						.labelsHidden()
				}
				.alignment(.numeric)
			}
			.tableColumnHeaders(.hidden)
			.alternatingRowBackgrounds(.disabled)
		}
	}
}

#Preview {
	let vm = VirtualMachine()
	vm.ram.randomize()
	return Form {
		Section("RAM") {
			RAM(vm)
		}
	}
	.formStyle(.grouped)
}
#endif
