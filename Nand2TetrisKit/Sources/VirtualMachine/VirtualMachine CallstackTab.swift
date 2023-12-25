//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2TetrisKit

struct VirtualCallstackTab: View {
	@Environment(ObservableVirtualMachine.self) private var vm

	var body: some View {
		Text("Callstack")
	}
}
