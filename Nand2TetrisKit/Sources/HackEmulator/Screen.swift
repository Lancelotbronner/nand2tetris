//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

import Nand2Tetris

#if canImport(SwiftUI)
import SwiftUI

public struct Screen: View {
	@Environment(VirtualMachine.self) private var vm

	public init() { }

	public var body: some View {
		Canvas { context, size in
			context.withCGContext { cgcontext in
				cgcontext.interpolationQuality = .none

				let color = Color.accentColor.resolve(in: context.environment)
				cgcontext.setFillColor(color.cgColor)
				cgcontext.fill([CGRect(x: 0, y: 0, width: 512, height: 256)])

				cgcontext.setFillColor(.white)

				//TODO: Find a way to only observe the screen's region
				vm.ram.screen.withUnsafeBytes { buffer in
					let data = Data(buffer: buffer.bindMemory(to: UInt16.self))
					let mask = CGImage(
						maskWidth: 512,
						height: 256,
						bitsPerComponent: 1,
						bitsPerPixel: 1,
						bytesPerRow: 64,
						provider: CGDataProvider(data: NSData(data: data) as CFData)!,
						decode: nil,
						shouldInterpolate: false)!

					cgcontext.scaleBy(x: 1, y: -1)
					cgcontext.translateBy(x: 0, y: -256)

					cgcontext.setBlendMode(.destinationOut)
					cgcontext.draw(mask, in: CGRect(origin: .zero, size: size), byTiling: false)
				}
			}
		}
		.frame(width: 512, height: 256)
	}
}

#Preview {
	let vm = VirtualMachine()
	vm.ram.randomize()
//	for i in 0..<256 {
//		vm.ram.screen[vm.ram.screen.startIndex + i] = .max
//	}
	return Screen()
		.padding()
		.environment(vm)
}
#endif
