//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2Tetris

public struct VirtualFunctionCell: View {
	private let function: VirtualFunction

	public init(_ function: VirtualFunction) {
		self.function = function
	}

	public var body: some View {
		Label {
			VStack(alignment: .leading) {
				Text(function.name)
				Text("\(function.count) commands, \(function.args) arguments, \(function.locals) locals")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
		} icon: {
			Image(systemName: "f.cursive")
		}
	}
}
