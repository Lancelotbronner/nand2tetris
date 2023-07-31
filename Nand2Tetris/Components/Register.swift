//
//  Register.swift
//  Nand2Tetris
//
//  Created by Christophe Bronner on 2023-01-18.
//

import SwiftUI

struct Register: View {

	@Environment(\.registerStyle) private var style: RegisterStyle

	private let rawValue: UInt16

	init(_ rawValue: UInt16) {
		self.rawValue = rawValue
	}

	var body: some View {
		Text(verbatim: style.format(rawValue))
			.frame(maxWidth: .infinity, alignment: .trailing)
	}

}

//MARK: - Register Styles

public enum RegisterStyle {
	case binary
	case decimal
	case hexadecimal
	case assembly

	func format(_ rawValue: UInt16) -> String {
		switch self {
		case .binary:
			return String(format: "0b%016b", rawValue)
		case .hexadecimal:
			return String(format: "0b%04X", rawValue)
		case .decimal:
			return rawValue.description
		case .assembly:
			return "TODO: Assembly"
		}
	}

	@ViewBuilder var label: some View {
		switch self {
		case .binary: Label("Binary", systemImage: "memorychip")
		case .decimal: Label("Decimal", systemImage: "number")
		case .hexadecimal: Label("Hexadecimal", systemImage: "hexagon")
		case .assembly: Label("Assembly", systemImage: "cpu")
		}
	}

}

//MARK: - Register Environment

private struct RegisterStyleKey: EnvironmentKey {
	static var defaultValue = RegisterStyle.decimal
}

extension EnvironmentValues {

	fileprivate var registerStyle: RegisterStyle {
		get { self[RegisterStyleKey.self] }
		set { self[RegisterStyleKey.self] = newValue }
	}

}

extension View {

	public func registerStyle(_ style: RegisterStyle) -> some View {
		environment(\.registerStyle, style)
	}

}
