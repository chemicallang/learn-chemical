# Command Line Basics

You can absolutely build a chemical source file without a `chemical.mod` or `build.lab` file

Create a file `main.ch` with contents

```chemical
@extern
public func printf(format : *char, _ : any...) : int

public func main() : int {
    printf("Hello World");
    return 0;
}
```

You can use the following command to convert it into an executable

> chemical main.ch -o main.exe && ./main.exe

This should print `Hello World` in command line

However this doesn't allow us multiple modules, You also cannot import
other modules in this single source file (this may change)

### How Modules work in Chemical

Chemical has a very minimal module system, A module in `chemical` contains source files and a build file

There are two kinds of build files

- `chemical.mod` (Used in most projects)
- `build.lab` (Used in mostly advanced projects)

#### chemical.mod

Lets look at contents of a simple `chemical.mod` file, which prints
`Hello World` however using imported declaration from `cstd` module

_chemical.mod_

```
module main

// this file must be present relative to this file
// you can also mention a path to directory to include all nested .ch files
source "main.ch"

// this imports the cstd module
import cstd
```

_main.ch_

```
public func main() : int {
    printf("Hello World");
    return 0;
}
```

Here the `main.ch` file is sibling to the `chemical.mod` file, The directory structure is following

> _my_module_
>
> - `main.ch`
> - `chemical.mod`

When you invoke the compiler you must use the build file `chemical.mod` or `build.lab` file as the argument, for example

> chemical chemical.mod -o main.exe && ./main.exe

#### Adding a relative module

We created a `chemical.mod` file above, we can make these changes to add another
module named `mylib`


_chemical.mod_

```
module main

// this file must be present relative to this file
source "main.ch"

// this imports the cstd module
import cstd
import "./mylib"
```

You should add a directory `mylib` sibling of `main.ch` which should contain a `chemical.mod` file

#### Important Command Line Options

| Command Option |                     Description                      |
| -------------- | :--------------------------------------------------: |
| -c             |             only generate an object file             |
| -v             |                turn on verbose output                |
| -bm            |        measure the time taken by compilation         |
| --build-dir    |           this configures build directory            |
| --lto          |            enable link time optimization             |
| --no-cache     |                 disable using cache                  |
| -target <t>    | specify the target for which code is being generated |
| --assertions   |     turn on assertions to verify generated code      |

#### Release Modes

There are present these five release modes (more to be added)

- _debug_
  - Default debug mode
  - No Optimizations are performed
  - Embeds debug information in executable
- _debug_quick_
  - No Optimizations are performed
  - Does NOT embed debug information
  - Tries to output and run the executable as fast as possible
- _debug_complete_
  - No Optimizations are performed
  - Embeds debug information
  - Generates slower code for better debugging
  - Takes more time to compile
  - Debugs every aspect of compilation, for example compiler binding
    libraries are also compiled in debug mode
- _release_small_
  - Optimizations are performed
  - generate code to prefer size over performance
- _release_fast_
  - Optimizations are performed
  - Release mode, generate code to prefer performance over size

The release modes act as base configuration for your exeuctable. For example, you can use `-g` with any of the modes to embed debug information

To use a mode you must use `--mode` parameter in command line

> chemical chemical.mod -o main.exe --mode debug_complete

### Translating Chemical To C

You can translate chemical to C, Chemical compiler outputs clean, readable C code that is performant, we are constantly improving the C translation

Use the following command to translate just one file to C

> chemical main.ch -o main.c

### Translating C To Chemical (experimental)

You can translate C to chemical, Chemical compiler parses C code using Clang and outputs chemical code

However currently only headers are emitted (no function bodies), Also avoid complex code

> chemical main.c -o main.ch

### Translating chemical.mod To build.lab

You can also translate `chemical.mod` file to `build.lab` like this

> chemical chemical.mod -o build.lab

The chemical compiler behind the scenes converts all `.mod` files to
lab files, This is improves performance and allows to import `.mod` files
in lab files easily

### Translating build.lab To C

Similarly a build.lab can also be translated to C using

> chemical build.lab -o build.c

### Emitting LLVM IR And Assembly

You can emit llvm ir for a chemical source file as well, Which you
can use to analyze generated code

Here are the following command line options available for this

| Command Option   |                      Description                       |
| ---------------- | :----------------------------------------------------: |
| --out-ll <path>  |           specify a output path for llvm ir            |
| --out-asm <path> |           specify a output path for assembly           |
| --out-ll-all     | auto generate llvm ir for every module being compiled  |
| --out-asm-all    | auto generate assembly for every module being compiled |

Apart from these, there are these options which further help

| Command Option |                               Description                                |
| -------------- | :----------------------------------------------------------------------: |
| --debug-ir     |        the ir is debug, this allows for generation of invalid ir         |
| --build-dir    | although this configures build directory, but that's where out-ll-all go |

Here's some examples using this options

> chemical main.ch -o main.exe --out-ll main.ll

> chemical chemical.mod -o main.exe --out-ll-all

> chemical chemical.mod -o main.exe --build-dir build --debug-ir --out-ll-all

`out-bc` also exists for emitting bitcode
