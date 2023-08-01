//
//  Nand2TetrisApp.swift
//  Nand2Tetris
//
//  Created by Christophe Bronner on 2023-01-18.
//

import SwiftUI
import Nand2TetrisKit

@main struct Nand2TetrisApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment({ () -> VirtualMachine in
					let vm = VirtualMachine()
					vm.rom[0] = 16384
					vm.rom[1] = Instruction(assign: .y, to: .d).rawValue
					vm.rom[2] = Instruction(assign: .x, to: .a).rawValue
					vm.rom[3] = Instruction(assign: .one, to: .m).rawValue
					vm.rom[4] = Instruction(assign: .incY, to: .ad).rawValue
					vm.rom[5] = 2
					vm.rom[6] = Instruction(assign: .zero, jump: .jmp).rawValue
					vm.rom[7] = 0
					vm.rom[8] = 0
					return vm
				}())
        }
    }
}
