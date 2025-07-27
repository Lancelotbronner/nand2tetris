//
//  Nand2TetrisApp.swift
//  Nand2Tetris
//
//  Created by Christophe Bronner on 2023-01-18.
//

import SwiftUI

import EmulatorScene
import VirtualMachineScene
import AssemblerScene

@main struct Nand2TetrisApp: App {
	var body: some Scene {
		// Special windows
		EmulatorScene()
		VirtualMachineScene()

		// Document windows
		AssemblyScene()
	}
}
