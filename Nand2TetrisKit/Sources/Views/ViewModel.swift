//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

internal final class ViewModel: ObservableObject {

	let vm: VirtualMachine

	init(_ vm: VirtualMachine) {
		self.vm = vm
	}

}

extension View {

	public func virtualMachine(_ vm: VirtualMachine) -> some View {
		environmentObject(ViewModel(vm))
	}

}

#endif
