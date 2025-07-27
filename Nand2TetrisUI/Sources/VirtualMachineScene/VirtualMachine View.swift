//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-01-05.
//

import SwiftUI
import Nand2TetrisKit

struct VirtualMachineView: View {
	@Environment(ObservableVirtualMachine.self) private var vm

	var body: some View {
		HStack {
			VirtualAssemblyEditor()
			Spacer()
		}
		.toolbar {
			Button("Advance") {
				vm.step()
			}
		}
	}
}
