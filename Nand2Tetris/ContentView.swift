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
    }
}

#Preview {
	ContentView()
		.environment(VirtualMachine())
}
