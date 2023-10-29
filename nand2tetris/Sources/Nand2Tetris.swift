//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-10-08.
//

import ArgumentParser

@main struct Nand2Tetris: ParsableCommand {

	static let configuration = CommandConfiguration(
		commandName: "nand2tetris",
		abstract: "Development toolchain for Nand2Tetris",
		version: "0.1",
		subcommands: [AssembleCommand.self])

}
