//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

public struct Screen: View {
	@Environment(VirtualMachine.self) private var vm

	public init() { }

	public var body: some View {
		Canvas { context, size in
			context.withCGContext { cgcontext in
				let color = Color.primary.resolve(in: context.environment)
				cgcontext.setFillColor(color.cgColor)
				cgcontext.interpolationQuality = .none

				vm.screen.withUnsafeBytes { buffer in
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
	return Screen()
		.environment(vm)
}
#endif
