//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-01-05.
//

import SwiftUI
import Nand2TetrisKit

public struct VirtualFrameCell: View {
	private let frame: RawVirtualFrame

	public init(_ frame: RawVirtualFrame) {
		self.frame = frame
	}

	public var body: some View {
		VirtualFunctionCell(frame.callee)
	}
}
