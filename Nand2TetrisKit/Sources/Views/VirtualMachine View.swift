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
			VStack(alignment: .leading) {
				Text("ROM")
					.font(.headline)
				ROM()
			}
			.frame(width: 280)
			.padding([.leading, .vertical])
			VStack(alignment: .leading) {
				Text("RAM")
					.font(.headline)
				RAMView()
			}
			.frame(width: 200)
			.padding(.vertical)
			Form {
				Section("SCREEN") {
					Screen()
					Keyboard()
				}
				Section("CPU") {
					CPUView()
				}
				Section("ALU") {
					ALUView()
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
		simulating = Task.detached(priority: .background) {
			while !Task.isCancelled {
				vm.cycle()
			}
		}
	}

	private func pause() {
		simulating?.cancel()
		simulating = nil
	}

	private func toggleSimulation() {
		(simulating == nil ? simulate : pause)()
	}

	private func reset() {
		Task {
			pause()
			await simulating?.value
			vm.pc = 0
			vm.a = 0
			vm.d = 0
		}
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
				Button(action: reset) {
					Label("Reset", systemImage: "stop.fill")
				}
				.disabled(vm.pc == 0 && vm.a == 0 && vm.d == 0)
				Button(action: toggleSimulation) {
					if simulating == nil {
						Label("Run", systemImage: "play.fill")
					} else {
						Label("Pause", systemImage: "pause.fill")
					}
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
