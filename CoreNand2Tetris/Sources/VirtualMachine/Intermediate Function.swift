//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

public struct IntermediateFunction {
	/// Commands which compose the function's code
	var code: [Command] = []
	/// Local labels of the function
	var labels: [String : UInt16] = [:]
}
