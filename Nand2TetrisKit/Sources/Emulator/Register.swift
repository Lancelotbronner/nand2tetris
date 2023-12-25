//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

import Nand2TetrisKit

#if canImport(SwiftUI)
import SwiftUI

public struct Register<Label: View>: View {
	@Environment(\.defaultRegisterStyle) private var defaultStyle
	@Environment(\.pedantic) private var pedantic
	@State private var style: RegisterStyle?
	@FocusState private var focused: Bool
	@Binding private var value: UInt16
	private let label: Label

	public init(
		_ value: Binding<UInt16>,
		style: RegisterStyle? = nil,
		@ViewBuilder label: () -> Label
	) {
		_style = State(initialValue: style)
		_value = value
		self.label = label()
	}

	public init(_ value: Binding<UInt16>, at address: UInt16, style: RegisterStyle? = nil) where Label == Text {
		self.init(value, style: style) {
			Text(String(address))
				.monospaced()
		}
	}

	public init(_ title: LocalizedStringKey, value: Binding<UInt16>, style: RegisterStyle? = nil) where Label == Text {
		self.init(value, style: style) { Text(title) }
	}

	public init(_ title: String, value: Binding<UInt16>, style: RegisterStyle? = nil) where Label == Text {
		self.init(value, style: style) { Text(title) }
	}

	public init(_ value: PointerEmulator, style: RegisterStyle? = nil) where Label == Text {
		self.init(value.binding, at: value.address, style: style)
	}

	private func binding(of style: RegisterStyle) -> Binding<Bool> {
		Binding<Bool> {
			self.style == style
		} set: { newValue in
			if newValue {
				self.style = style
			} else {
				self.style = nil
			}
		}
	}

	public var body: some View {
		field
			.monospaced()
			.focused($focused)
			.onSubmit(of: .text) { focused = false }
			.contextMenu {
				Menu("View As") {
					Toggle("Binary", isOn: binding(of: .binary))
					Toggle("Hexadecimal", isOn: binding(of: .hexadecimal))
					Toggle("Unsigned", isOn: binding(of: .unsigned))
					Toggle("Signed", isOn: binding(of: .signed))
					Toggle("Assembly", isOn: binding(of: .assembly))
				}
			}
	}

	@ViewBuilder private var field: some View {
		switch style ?? defaultStyle {
		case .binary:
			TextField(value: $value, format: PointerEmulator.BinaryFormat(pedantic: pedantic)) {
				label
					.fontDesign(.default)
			}
		case .hexadecimal:
			TextField(value: $value, format: PointerEmulator.HexadecimalFormat(pedantic: pedantic)) {
				label
					.fontDesign(.default)
			}
		case .unsigned:
			TextField(value: $value, format: PointerEmulator.UnsignedFormat(pedantic: pedantic)) {
				label
					.fontDesign(.default)
			}
		case .signed:
			TextField(value: $value, format: PointerEmulator.SignedFormat(pedantic: pedantic)) {
				label
					.fontDesign(.default)
			}
		case .assembly:
			TextField(value: $value, format: PointerEmulator.AssemblyFormat(pedantic: pedantic)) {
				label
					.fontDesign(.default)
			}
		}
	}
}

extension PointerEmulator {

	@_transparent var binding: Binding<UInt16> {
		Binding { value } set: { value = $0 }
	}

}

public enum RegisterStyle {
	case binary
	case hexadecimal
	case unsigned
	case signed
	case assembly
}

private struct DefaultRegisterKey: EnvironmentKey {
	static var defaultValue = RegisterStyle.signed
}

extension EnvironmentValues {

	internal var defaultRegisterStyle: RegisterStyle {
		_read { yield self[DefaultRegisterKey.self] }
		_modify { yield &self[DefaultRegisterKey.self] }
	}

}

#Preview {
	Form {
		Section("Binary") {
			Register("Negative", value: .constant(52790), style: .binary)
			Register("Positive", value: .constant(5), style: .binary)
		}
		.textFieldStyle(.squareBorder)
		Section("Hexadecimal") {
			Register("Negative", value: .constant(52790), style: .hexadecimal)
			Register("Positive", value: .constant(5), style: .hexadecimal)
		}
		.textFieldStyle(.squareBorder)
		Section("Unsigned") {
			Register("Negative", value: .constant(52790), style: .unsigned)
			Register("Positive", value: .constant(5), style: .unsigned)
		}
		.textFieldStyle(.plain)
		Section("Signed") {
			Register("Negative", value: .constant(52790), style: .signed)
			Register("Positive", value: .constant(5), style: .signed)
		}
		.textFieldStyle(.plain)
		Section("Assembly") {
			Register("Garbage", value: .constant(52790), style: .assembly)
			Register("Value", value: .constant(5), style: .assembly)
			Register("Computation", value: .constant(Instruction(assign: .notY, to: .md, jump: .jge).rawValue), style: .assembly)
		}
		.textFieldStyle(.roundedBorder)
	}
	.formStyle(.grouped)
}
#endif
