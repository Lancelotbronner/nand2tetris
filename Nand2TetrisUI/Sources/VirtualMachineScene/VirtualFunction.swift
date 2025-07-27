//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2TetrisKit

public struct VirtualFunctionCell: View {
	private let function: VirtualFunction

	public init(_ function: VirtualFunction) {
		self.function = function
	}

	public var body: some View {
		Label {
			VStack(alignment: .leading) {
				Text(function.name)
				Text("\(function.locals) locals, \(function.count) commands")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
		} icon: {
			Image(systemName: "f.cursive")
		}
	}
}
