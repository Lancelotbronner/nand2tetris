//
//  File.swift
//
//
//  Created by Christophe Bronner on 2022-08-28.
//

public struct Computation: RawRepresentable, OptionSet {

	public var rawValue: UInt16

	public init(rawValue: UInt16) {
		self.rawValue = rawValue
	}

	public init(mask rawValue: UInt16) {
		self.init(rawValue: rawValue & 0x1FC0)
	}

	public init(bitPattern rawValue: UInt16) {
		self.init(rawValue: (rawValue & 0x7F) << 6)
	}

	public static let allCases: [Computation] = {
		var tmp: [Computation] = [Computation(rawValue: 0)]
		tmp.append(contentsOf: (UInt16(0x40)..<0x1000).map(Computation.init(rawValue:)))
		return tmp
	}()

	@_transparent public var indirect: Computation {
		union(.i)
	}

	//MARK: - Flags

	/// Wether to use the second operand as is or to replace it with the memory value at itself
	public static let i = Computation(rawValue: 0x1000)

	/// Wether to zero the value of the first operand.
	public static let zx = Computation(rawValue: 0x800)

	/// Wether to negate the value of the first operand.
	public static let nx = Computation(rawValue: 0x400)

	/// Wether to zero the value of the second operand.
	public static let zy = Computation(rawValue: 0x200)

	/// Wether to negate the value of the second operand.
	public static let ny = Computation(rawValue: 0x100)

	/// Wether to ADD or AND the operands together.
	public static let f = Computation(rawValue: 0x80)

	/// Wether to negate the output value.
	public static let no = Computation(rawValue: 0x40)

	//MARK: - Legal Instructions

	/// `0`
	///
	/// Mnemonics:
	/// - `0`
	/// - `X&0`
	/// - `!X&0`
	/// - `0&Y`
	/// - `0&!Y`
	/// - `0&0`
	/// - `0+0`
	/// - `0&-1`
	/// - `!0+-1`
	/// - `-1&0`
	/// - `!(-1+0)`
	/// - `!(-1&-1)`
	public static let zero = Computation(bitPattern: 0b101010)

	/// `1`
	///
	/// Mnemonics:
	/// - `1`
	/// - `!(-1+-1)`
	public static let one = Computation(bitPattern: 0b111111)

	/// `-1`
	///
	/// Mnemonics:
	/// - `-1`
	/// - `!(X&0)`
	/// - `!(!X&0)`
	/// - `!(0&Y)`
	/// - `!(0&!Y)`
	/// - `!(0&0)`
	/// - `!(0+0)`
	/// - `!(0&-1)`
	/// - `0+-1`
	/// - `!(-1&0)`
	/// - `-1+0`
	/// - `-1&-1`
	public static let minusOne = Computation(bitPattern: 0b111010)

	/// `X&-1`
	public static let x = Computation(bitPattern: 0b001100)

	/// `-1&Y`
	public static let y = Computation(bitPattern: 0b110000)

	/// `!(X&-1)`
	public static let notX = Computation(bitPattern: 0b001101)

	/// `!Y`
	public static let notY = Computation(bitPattern: 0b110001)

	/// `-X`
	public static let negX = Computation(bitPattern: 0b001111)

	/// `-Y`
	public static let negY = Computation(bitPattern: 0b110011)

	/// `X+1`, `X++`
	public static let incX = Computation(bitPattern: 0b011111)

	/// `Y+1`, `Y++`
	public static let incY = Computation(bitPattern: 0b110111)

	/// `X-1`, `X--`
	public static let decX = Computation(bitPattern: 0b110010)

	/// `Y-1`, `Y--`
	public static let decY = Computation(bitPattern: 0b110111)

	/// `X+Y`, `add`
	public static let add = Computation(bitPattern: 0b000010)

	/// `X-Y`
	public static let subY = Computation(bitPattern: 0b010011)

	/// `Y-X`
	public static let subX = Computation(bitPattern: 0b000111)

	/// `X&Y`, `!(!X|!Y)`, `and`
	public static let and = Computation(bitPattern: 0b000000)

	/// `X|Y`, `!(!X&!Y)`, `or`
	public static let or = Computation(bitPattern: 0b010101)

	/*
	 TODO: Add legal instruction mnemonics
	 000000* X&Y      => D&A
	 000001  !(X&Y)   => !D|!A
	 000010* X+Y      => D+A
	 000011  !(X+Y)   => !(D+A)
	 000100  X&!Y     => D&!A
	 000101  !(X&!Y)  => !D|A
	 000110  X+!Y     => D+!A
	 000111* !(X+!Y)  => A-D
	 001000  X&0      => 0
	 001001  !(X&0)   => -1
	 001010  X+0      => D
	 001011  !(X+0)   => !D
	 001100* X&-1     => D
	 001101* !(X&-1)  => !D
	 001110* X+-1     => D-1
	 001111* !(X+-1)  => -D
	 010000  !X&Y     => !D&A
	 010001  !(!X&Y)  => D|!A
	 010010  !X+Y     => !D+A
	 010011* !(!X+Y)  => D-A
	 010100  !X&!Y    => !D&!A
	 010101* !(!X&!Y) => D|A
	 010110  !X+!Y    => !D+!A
	 010111  !(!X+!Y) => !(!D+!A)
	 011000  !X&0     => 0
	 011001  !(!X&0)  => -1
	 011010  !X+0     => !D
	 011011  !(!X+0)  => D
	 011100  !X&-1    => !D
	 011101  !(!X&-1) => D
	 011110  !X+-1    => D-1
	 011111* !(!X+-1) => D+1
	 100000  0&Y      => 0
	 100001  !(0&Y)   => -1
	 100010  0+Y      => A
	 100011  !(0+Y)   => !A
	 100100  0&!Y     => 0
	 100101  !(0&!Y)  => -1
	 100110  0+!Y     => !A
	 100111  !(0+!Y)  => A
	 101000  0&0      => 0
	 101001  !(0&0)   => -1
	 101010* 0+0      => 0
	 101011  !(0+0)   => -1
	 101100  0&-1     => 0
	 101101  !(0&-1)  => -1
	 101110  0+-1     => -1
	 101111  !(0+-1)  => 0
	 110000* -1&Y     => A
	 110001* !(-1&Y)  => !A
	 110010* -1+Y     => A-1
	 110011* !(-1+Y)  => -A
	 110100  -1&!Y    => !A
	 110101  !(-1&!Y) => A
	 110110  -1+!Y    => !A-1
	 110111* !(-1+!Y) => A+1
	 111000  -1&0     => 0
	 111001  !(-1&0)  => -1
	 111010* -1+0     => -1
	 111011  !(-1+0)  => 0
	 111100  -1&-1    => -1
	 111101  !(-1&-1) => 0
	 111110  -1+-1    => -2
	 111111* !(-1+-1) => 1
	 */

	//MARK: - Illegal Instructions

	/// **Illegal** `!(X&Y)`
	///
	/// Mnemonics:
	/// - `nand`
	/// - `X nand Y`
	/// - `!(X&Y)`
	public static let nand = Computation(bitPattern: 0b000001)

	/// **Illegal** `!(X+Y)`, `!add`
	public static let nadd = Computation(bitPattern: 0b000011)

	/// **Illegal** `X&!Y`, `!(!X|Y)`
	public static let notYandX = Computation(bitPattern: 0b000100)

	/// **Illegal** `Y->X`, `!X|Y`, `!(X&!Y)`
	public static let ifYthenX = Computation(bitPattern: 0b000101)

	/// **Illegal** `X+!Y`
	public static let addXnotY = Computation(bitPattern: 0b000110)

	/// **Illegal** `!X&Y`, `!(X|!Y)`
	public static let notXandY = Computation(bitPattern: 0b010000)

	/// **Illegal** `X->Y`, `X|!Y` `!(!X&Y)`
	public static let ifXthenY = Computation(bitPattern: 0b010001)

	/// **Illegal** `!(!X+Y)`, `nand !X Y`
	public static let nandYnotX = Computation(bitPattern: 0b010010)

	/// **Illegal** `!X&!Y`. `nor`
	public static let nor = Computation(bitPattern: 0b010100)

	/// **Illegal** `!X+!Y`
	public static let addNotXnotY = Computation(bitPattern: 0b010110)

	/// **Illegal** `!X+!Y`
	public static let addNotXnotYnot = Computation(bitPattern: 0b010110)

	// TODO: Finish illegal instructions
	// https://www.wolframalpha.com/input
	// https://en.wikipedia.org/wiki/Truth_table
	/*
		010111  !(!X+!Y) => !(!D+!A)
		011000  !X&0     => 0
		011001  !(!X&0)  => -1
		011010  !X+0     => !D
		011011  !(!X+0)  => D
		011100  !X&-1    => !D
		011101  !(!X&-1) => D
		011110  !X+-1    => D-1
		011111* !(!X+-1) => D+1
		100000  0&Y      => 0
		100001  !(0&Y)   => -1
		100010  0+Y      => A
		100011  !(0+Y)   => !A
		100100  0&!Y     => 0
		100101  !(0&!Y)  => -1
		100110  0+!Y     => !A
		100111  !(0+!Y)  => A
		101000  0&0      => 0
		101001  !(0&0)   => -1
		101010* 0+0      => 0
		101011  !(0+0)   => -1
		101100  0&-1     => 0
		101101  !(0&-1)  => -1
		101110  0+-1     => -1
		101111  !(0+-1)  => 0
		110000* -1&Y     => A
		110001* !(-1&Y)  => !A
		110010* -1+Y     => A-1
		110011* !(-1+Y)  => -A
		110100  -1&!Y    => !A
		110101  !(-1&!Y) => A
		110110  -1+!Y    => !A-1
		110111* !(-1+!Y) => A+1
		111000  -1&0     => 0
		111001  !(-1&0)  => -1
		111010* -1+0     => -1
		111011  !(-1+0)  => 0
		111100  -1&-1    => -1
		111101  !(-1&-1) => 0
		111110  -1+-1    => -2
		111111* !(-1+-1) => 1
	 */
}
