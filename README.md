#  Nand2Tetris

This is a **work in progress** set of programs surrounding the excellent [nand2tetris](https://nand2tetris.org) course.

The goal of this project is to provide mac developers a native feeling and experience.
This will be achieved through both a set of SwiftUI apps mirroring the [official tools](https://www.nand2tetris.org/software)
and a set of Swift command-line programs to offer a more standard development experience. 

## Projects

### Nand2Tetris

This package provides an API for the Hack architecture, assembly and virtual machine.

It also provides standard documents for assembly, ROMs and virtual machine snapshots to
allow easier interop between projects.

The `CoreNand2Tetris` name is reserved for the potential clang module until SPM supports mixed source targets.

### Nand2TetrisCompanionKit

This package provides integration between `Nand2TetrisKit` and other frameworks, such as SwiftUI views.

### nand2tetris

This is the start of a Nand2Tetris toolchain.

Most commands can be in either pedantic (`--pedantic`) or extended mode.
Pedantic mode is strictly conformant to the book, no more no less.
Extended mode is meant to improve quality of life when manually writing files.
Extended mode may add new capabilities (such as the ALU's undocumented instructions) but will remain a superset of the book.

#### Assembler

```
nand2tetris assemble <input> ... [--output <output>] [--pedantic]
```

Extended mode includes some quality of life features when writing assembly files along with undocumented ALU instructions.

- Support lowercase and mixed case (`JGT` vs `jGt`)
- Supports aliases (`AMD=` vs `DMA=`)
- Supports the ALU's undocumented instructions (like `!(D&A)`, emulator only, assembly support to be added)

### Nand2Tetris

The companion app, built with SwiftUI.

#### Hack Emulator

- ROM editing with assembly parsing
- RAM editing using any base
- Jump to any ROM or RAM address
- Working screen & keyboard
- All registers at a glance, even pseudo-register `M`
- View any register or memory address as unsigned, signed, hex or binary
- Current instruction decoded
- Fully deconstructed ALU operations, both in decimal and binary

![Screenshot of the CPU emulator](Assets/HackEmulator.png)

## Roadmap

### Virtual Machine

I'm adding support for the virtual machine (`.vm` files) and its corresponding translator (`.vm` => `.hack`) to `Nand2Tetris`.

I would like, for GUIs, to produce an abstract syntax tree of the VM program

### Test Module

I want to add support for automatically executing test files (`.tst`, `.cmp`, `.out`) within `XCTNand2Tetris`.

### Hack Emulator

- Document format for the emulator's state
- Customizable toolbar
- Global format picker for registers & RAM. Select between signed, unsigned, hexadecimal and binary
- Clear RAM & ROM commands
- `CMD+L` Goto command, either in RAM `ram <number>`, ROM `rom <number>`, both `<number>` or special addresses. `screen`, `keyboard`, etc.

### Assembler

I want to add undocumented and raw instruction support to the assembler.

### Companion App

I've started GUIs for the assembler and virtual machine. 
