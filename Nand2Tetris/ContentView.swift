//
//  ContentView.swift
//  Nand2Tetris
//
//  Created by Christophe Bronner on 2023-01-18.
//

import SwiftUI
import Nand2TetrisKit

struct ContentView: View {
	@Environment(VirtualMachine.self) private var vm

    var body: some View {
        Machine()
			.toolbar {
				Button(action: vm.cycle) {
					Label("Step", systemImage: "arrow.turn.up.right")
				}
			}
    }
}

#Preview {
	ContentView()
		.environment(VirtualMachine())
}
