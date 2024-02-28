//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-12-15.
//

public struct VirtualFunction {

	static let null = VirtualFunction(nil)

	private init(_ storage: ManagedBuffer<Header, Command>?) {
		self.storage = storage
	}

	@usableFromInline var storage: ManagedBuffer<Header, Command>!

	public init(
		_ name: String,
		into unit: VirtualUnit,
		locals: Int = 0,
		@ArrayBuilder<Command> commands: (VirtualFunction) -> [Command]
	) {
		let commands = commands(VirtualFunction.null)
		storage = ManagedBuffer.create(minimumCapacity: commands.count) { _ in
			Header(name: name, unit: unit, locals: locals, body: commands.count)
		}
		commands.withContiguousStorageIfAvailable { commands in
			storage.withUnsafeMutablePointerToElements { storage in
				for i in commands.indices {
					storage[i] = switch commands[i] {
					case let .call(function, args) where function.storage == nil: Command.call(self, args)
					default: commands[i]
					}
				}
			}
		}
		unit.functions.insert(self)
	}

	public init(
		_ name: String,
		into unit: VirtualUnit,
		locals: Int = 0,
		@ArrayBuilder<Command> commands: () -> [Command]
	) {
		self.init(name, into: unit, locals: locals) { _ in
			commands()
		}
	}

	public init(
		_ name: String,
		into unit: VirtualUnit,
		locals: Int = 0,
		commands: [Command]
	) {
		self.init(name, into: unit, locals: locals) { _ in
			commands
		}
	}

	/// The function's name
	@_transparent public var name: String {
		storage.header.name
	}

	/// The unit in which this function is located
	@_transparent public var unit: VirtualUnit {
		storage.header.unit
	}

	/// The number of locals this function requires
	@_transparent public var locals: Int {
		storage.header.locals
	}

	@usableFromInline struct Header {
		public let name: String
		public let unit: VirtualUnit
		public let locals: Int
		public let body: Int
	}

}

//MARK: - Identifiable & Hashable

extension VirtualFunction: Identifiable, Hashable {

	public var id: ObjectIdentifier {
		ObjectIdentifier(storage)
	}

	public static func == (lhs: VirtualFunction, rhs: VirtualFunction) -> Bool {
		lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

}

//MARK: - Sequence

extension VirtualFunction: Sequence {

	@_transparent public func makeIterator() -> Iterator {
		Iterator(storage: storage)
	}

	public struct Iterator: IteratorProtocol {
		@usableFromInline let storage: ManagedBuffer<Header, Command>
		@usableFromInline var i = 0

		@usableFromInline init(storage: ManagedBuffer<Header, Command>) {
			self.storage = storage
		}

		@_transparent public mutating func next() -> Command? {
			guard i < storage.header.body else { return nil }
			return storage.withUnsafeMutablePointerToElements {
				defer { i += 1 }
				return $0[i]
			}
		}
	}

}

//MARK: - Collection

extension VirtualFunction: Collection {

	@_transparent public var startIndex: Int {
		0
	}

	@_transparent public var endIndex: Int {
		storage.header.body
	}

	@_transparent public func index(after i: Int) -> Int {
		i + 1
	}

	public subscript(position: Int) -> Command {
		@_transparent get {
			precondition(position < endIndex, "Index out of bounds")
			return storage.withUnsafeMutablePointerToElements {
				$0[position]
			}
		}
	}

}
