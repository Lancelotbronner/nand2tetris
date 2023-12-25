//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2Tetris

public struct VirtualUnitCell: View {
	private let unit: VirtualUnit

	public init(_ unit: VirtualUnit) {
		self.unit = unit
	}

	public var body: some View {
		Label {
			VStack(alignment: .leading) {
				Text(unit.name)
				Text("\(unit.functions.count) functions, \(unit.statics) statics")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
		} icon: {
			Image(systemName: "shippingbox")
		}
	}
}
