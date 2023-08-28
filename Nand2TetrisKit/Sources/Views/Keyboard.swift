//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-08-28.
//

import SwiftUI

public struct Keyboard: View {
	@Environment(VirtualMachine.self) private var vm

	public var body: some View {
		LabeledContent {
			Text(String(vm.ram.keyboard))
			Text(UnicodeScalar(vm.ram.keyboard)
				.map(Character.init)
				.map(String.init) ?? "")
		} label: {
			Text("KEYBOARD")
				.font(.headline)
				.focusable()
		}
		.onKeyPress { keypress in
			//TODO: Convert to proper code
			vm.ram.keyboard = keypress.key.character.asciiValue.map { UInt16($0) } ?? 0
			return .handled
		}
	}
}
