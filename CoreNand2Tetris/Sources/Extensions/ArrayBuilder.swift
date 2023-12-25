//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-25.
//

@resultBuilder
public struct ArrayBuilder<Element> {

	public enum Component {
		case zero
		case one(Element)
		case many([Element])

		var count: Int {
			switch self {
			case .zero: 0
			case .one: 1
			case let .many(collection): collection.count
			}
		}
	}

	public static func buildExpression(_ expression: Element) -> Component {
		Component.one(expression)
	}

	public static func buildExpression(_ expression: [Element]) -> Component {
		Component.many(expression)
	}

	@_disfavoredOverload
	public static func buildExpression(_ expression: some Sequence<Element>) -> Component {
		Component.many(Array(expression))
	}

	public static func buildExpression(_ expression: some Collection<Element>) -> Component {
		var contents: [Element] = []
		contents.reserveCapacity(expression.count)
		contents.append(contentsOf: expression)
		return Component.many(contents)
	}

	public static func buildBlock() -> Component {
		Component.zero
	}

	public static func buildBlock(_ components: Component...) -> Component {
		let count = components.lazy
			.map(\.count)
			.reduce(0, +)
		var result: [Element] = []
		result.reserveCapacity(count)
		for component in components {
			switch component {
			case .zero: continue
			case let .one(element): result.append(element)
			case let .many(collection): result.append(contentsOf: collection)
			}
		}
		return Component.many(result)
	}

	public static func buildOptional(_ component: Component?) -> Component {
		component ?? .zero
	}

	public static func buildEither(first component: Component) -> Component {
		component
	}

	public static func buildEither(second component: Component) -> Component {
		component
	}

	public static func buildFinalResult(_ component: Component) -> [Element] {
		switch component {
		case .zero: []
		case let .one(element): [element]
		case let .many(collection): collection
		}
	}

}
