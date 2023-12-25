//
//  ContentView.swift
//  Nand2Tetris
//
//  Created by Christophe Bronner on 2023-01-18.
//

import SwiftUI
import Nand2Tetris
import Nand2TetrisKit

struct ContentView: View {
	@Environment(ObservableHackEmulator.self) private var vm

    var body: some View {
        HackEmulatorView()
    }
}

#Preview {
	ContentView()
		.environment(ObservableHackEmulator())
}
