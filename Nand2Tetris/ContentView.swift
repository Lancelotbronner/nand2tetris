//
//  ContentView.swift
//  Nand2Tetris
//
//  Created by Christophe Bronner on 2023-01-18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HackEmulator(VirtualMachine())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
