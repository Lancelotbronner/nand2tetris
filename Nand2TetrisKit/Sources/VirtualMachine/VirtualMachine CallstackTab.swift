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
	@State private var selection: Set<RawVirtualFrame> = []

	var body: some View {
		List(selection: $selection) {
			ForEach(vm.frames) { frame in
				VirtualFrameCell(frame)
			}
		}
		.inspector(isPresented: .constant(true)) {
			CallframeInspector(selection: selection)
		}
	}
}

private struct CallframeInspector: View {
	let selection: Set<RawVirtualFrame>

	var body: some View {
		if selection.count == 1, let single = selection.first {
			CallframeForm(frame: single)
		}
	}
}

private struct CallframeForm: View {
	let frame: RawVirtualFrame

	var body: some View {
		Form {
			LabeledContent("Caller") {
				if let caller = frame.caller {
					VirtualFunctionCell(caller)
				}
			}
			LabeledContent("Callee") {
				VirtualFunctionCell(frame.callee)
			}
			Section("Pointers") {
				LabeledContent("Return", value: frame.return, format: .number)
				LabeledContent("Frame", value: frame.fp, format: .number)
				LabeledContent("Local", value: frame.lcl, format: .number)
				LabeledContent("Argument", value: frame.arg, format: .number)
				LabeledContent("This", value: frame.this, format: .number)
				LabeledContent("That", value: frame.that, format: .number)
			}
		}
	}
}

#Preview {
	VirtualCallstackTab()
		.environment(ObservableVirtualMachine.preview)
}
