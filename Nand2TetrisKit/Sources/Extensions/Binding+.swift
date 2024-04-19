//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2024-04-19.
//

import SwiftUI

extension Binding where Value: Equatable {

	@inlinable
	public static func == (lhs: Binding, rhs: Value) -> Binding<Bool> {
		Binding<Bool> {
			lhs.wrappedValue == rhs
		} set: {
			if $0 { lhs.wrappedValue = rhs }
		}
	}

	@inlinable
	public static func != (lhs: Binding, rhs: Value) -> Binding<Bool> {
		Binding<Bool> {
			lhs.wrappedValue != rhs
		} set: {
			if !$0 { lhs.wrappedValue = rhs }
		}
	}

}
