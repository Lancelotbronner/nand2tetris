//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-04-19.
//

import SwiftUI

public struct TextToggleStyle: ToggleStyle {
	public func makeBody(configuration: Configuration) -> some View {
		Button {
			configuration.isOn.toggle()
		} label: {
			configuration.label
				.padding(.horizontal, 2)
				.foregroundStyle(configuration.isOn ? .primary : .secondary)
				.contentShape(Rectangle())
		}
		.buttonStyle(.plain)
	}
}

extension ToggleStyle where Self == TextToggleStyle {
	public static var text: TextToggleStyle {
		TextToggleStyle()
	}
}
