//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

public enum CommandSyntax {

	//MARK: - Arithmetic Commands

	case add
	case sub
	case neg

	case eq
	case gt
	case lt

	case and
	case or
	case not

	//MARK: - Memory Commands

	case push(segment: MemorySegment, offset: UInt16)
	case pop(segment: MemorySegment, offset: UInt16)

	//MARK: - Flow Commands

	case label(label: String)
	case goto(label: String)
	case ifgoto(label: String)

	//MARK: - Function Commands

	case function(name: String, locals: UInt16)
	case call(name: String, args: UInt16)
	case `return`

}
