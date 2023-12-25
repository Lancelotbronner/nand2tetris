//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2Tetris

public struct EmulatorScene: Scene {
	@State private var emulator = ObservableHackEmulator()

	public init() {
		emulator.rom[0] = 16384
		emulator.rom[1] = Instruction(assign: .y, to: .d).rawValue
		emulator.rom[2] = Instruction(assign: .x, to: .a).rawValue
		emulator.rom[3] = Instruction(assign: .minusOne, to: .m).rawValue
		emulator.rom[4] = Instruction(assign: .incY, to: .ad).rawValue
		emulator.rom[5] = 2
		emulator.rom[6] = Instruction(assign: .zero, jump: .jmp).rawValue
		emulator.rom[7] = 0
		emulator.rom[8] = 0
	}

	public var body: some Scene {
		Window("Hack Emulator", id: "emulator") {
			HackEmulatorView()
				.environment(emulator)
		}
		.keyboardShortcut("2", modifiers: [.shift, .command])
	}
}
