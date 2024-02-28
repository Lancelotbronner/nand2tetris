//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-01-05.
//

import SwiftUI
import Nand2TetrisKit

public struct VirtualFrameCell: View {
	private let frame: VirtualFrame<ObservableVirtualMachine>

	public init(_ frame: VirtualFrame<ObservableVirtualMachine>) {
		self.frame = frame
	}

	public var body: some View {
		VirtualFunctionCell(frame.callee)
	}
}
