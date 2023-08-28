//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct Machine: View {
	@Environment(VirtualMachine.self) private var vm

	public init() { }

	public var body: some View {
		HStack {
			Form {
				Section("ROM") {
					ROM()
				}
			}
			Form {
				Section("RAM") {
					RAM()
				}
			}
			VStack {
				Form {
					Section("SCREEN") {
						Screen()
						Keyboard()
					}
					Section("CPU") {
						CPU()
					}
					Section("ALU") {
						ALU()
					}
				}
			}
		}
		.formStyle(.grouped)
		.toolbar {
			MachineToolbar()
		}
	}
}

internal struct MachineToolbar: ToolbarContent {
	@Environment(VirtualMachine.self) private var vm
	@State private var simulating: Task<Void, Never>?

	private func simulate() {
		guard simulating == nil else { return }
		simulating = Task {
			while !Task.isCancelled {
				vm.cycle()
				await Task.yield()
			}
		}
	}

	private func pause() {
		simulating?.cancel()
		simulating = nil
	}

	var body: some ToolbarContent {
		ToolbarItem(placement: .primaryAction) {
			//TODO: Add Import buttons for ROM/Assembly/Snapshot
			//TODO: Add Export buttons for ROM/Assembly/Snapshot
			ControlGroup("Debugging") {
				Button(action: vm.cycle) {
					Label("Step", systemImage: "arrow.turn.up.right")
				}
			}
		}
		ToolbarItem(placement: .primaryAction) {
			ControlGroup("Simulation") {
				Button(action: pause) {
					Label("Stop", systemImage: "stop.fill")
				}
				.disabled(simulating == nil)
				Button(action: simulate) {
					Label("Run", systemImage: "play.fill")
				}
			}
		}
	}
}

#Preview {
	let vm = VirtualMachine()
	vm.rom.randomize()
	vm.rom[4] = 0
	return Machine()
		.environment(vm)
}
#endif
