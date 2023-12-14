//
//  Register.swift
//  
//
//  Created by Christophe Bronner on 2023-07-31.
//

#if canImport(SwiftUI)
import SwiftUI

private struct PedanticKey: EnvironmentKey {
	static var defaultValue = true
}

extension EnvironmentValues {

	public var pedantic: Bool {
		_read { yield self[PedanticKey.self] }
		_modify { yield &self[PedanticKey.self] }
	}

}
#endif
