//
//  File.swift
//
//
//  Created by Christophe Bronner on 2023-08-28.
//

import Nand2TetrisKit

#if canImport(SwiftUI)
import SwiftUI

extension Instruction: View {

	public var body: some View {
		HStack {
			Text("i")
				.foregroundStyle(i && isComputing ? .primary : .tertiary)
			Divider()
			Text("zx")
				.foregroundStyle(zx && isComputing ? .primary : .tertiary)
			Text("nx")
				.foregroundStyle(nx && isComputing ? .primary : .tertiary)
			Text("zy")
				.foregroundStyle(zy && isComputing ? .primary : .tertiary)
			Text("ny")
				.foregroundStyle(ny && isComputing ? .primary : .tertiary)
			Text("f")
				.foregroundStyle(f && isComputing ? .primary : .tertiary)
			Text("no")
				.foregroundStyle(no && isComputing ? .primary : .tertiary)
			Divider()
			Text("a")
				.foregroundStyle(a && isComputing ? .primary : .tertiary)
			Text("d")
				.foregroundStyle(d && isComputing ? .primary : .tertiary)
			Text("m")
				.foregroundStyle(m && isComputing ? .primary : .tertiary)
			Divider()
			Text("gt")
				.foregroundStyle(gt && isComputing ? .primary : .tertiary)
			Text("eq")
				.foregroundStyle(eq && isComputing ? .primary : .tertiary)
			Text("lt")
				.foregroundStyle(lt && isComputing ? .primary : .tertiary)
			Text(description)
				.padding(.leading)
		}
		.monospaced()
	}

}
#endif
