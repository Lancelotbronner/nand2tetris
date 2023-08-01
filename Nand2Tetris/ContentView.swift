//
//  ContentView.swift
//  Nand2Tetris
//
//  Created by Christophe Bronner on 2023-01-18.
//

import SwiftUI
import Nand2TetrisKit

struct ContentView: View {
	@State private var running: Task<Void, Never>?
	private let vm: VirtualMachine

	init(_ vm: VirtualMachine) {
		self.vm = vm
	}

    var body: some View {
        Machine(vm)
			.toolbar {
				Button(action: vm.cycle) {
					Label("Step", systemImage: "arrow.turn.up.right")
				}
				Spacer()
				Button {
					running = nil
				} label: {
					Label("Stop", systemImage: "stop.fill")
				}
				.disabled(running == nil)
				Button {
					guard running == nil else { return }
					running = Task {
						while true {
							vm.cycle()
						}
					}
				} label: {
					Label("Run", systemImage: "play.fill")
				}
				.disabled(running != nil)
			}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(VirtualMachine())
    }
}
