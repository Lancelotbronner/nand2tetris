//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-04-19.
//

import SwiftUI

public extension Binding {
	@inlinable init<Root: Sendable>(of root: Root, at field: ReferenceWritableKeyPath<Root, Value>) {
		self.init { root[keyPath: field] } set: { root[keyPath: field] = $0 }
	}
}

extension Binding where Value: Equatable & Sendable {

	@inlinable public static func == (lhs: Binding, rhs: Value) -> Binding<Bool> {
		Binding<Bool> { lhs.wrappedValue == rhs }
		set: { if $0 { lhs.wrappedValue = rhs } }
	}

	@inlinable public static func != (lhs: Binding, rhs: Value) -> Binding<Bool> {
		Binding<Bool> { lhs.wrappedValue != rhs }
		set: { if !$0 { lhs.wrappedValue = rhs } }
	}

}
