//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

import SwiftUI
import Nand2TetrisKit

struct VirtualCallstackTab: View {
	@Environment(ObservableVirtualMachine.self) private var vm
	@Environment(VirtualMachineNavigation.self) private var navigation

	var body: some View {
		@Bindable var navigation = navigation
		List(selection: $navigation.selection) {
			ForEach(vm.frames) { frame in
				VirtualFrameCell(VirtualFrame(frame, on: vm))
					.tag(VirtualMachineRoute.frame(frame))
			}
		}
	}
}
