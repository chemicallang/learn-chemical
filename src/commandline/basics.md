# Command Line

## Basics

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

```
module main

// this file must be present relative to this file
source "main.ch"

// this imports the cstd module
import cstd
```

Here the `main.ch` file is sibling to the `chemical.mod` file, The directory structure is following

> *my_module*
> - `main.ch`
> - `chemical.mod`

When you invoke the compiler you must use the build file `chemical.mod` or `build.lab` file as the argument, for example


> chemical chemical.mod -o main.exe && ./main.exe

#### Release Modes

There are present these four release modes (more to be added)

- *debug*
  - Default debug mode
  - No Optimizations are performed
  - Embeds debug information in executable
- *debug_quick* 
  - No Optimizations are performed
  - Does NOT embed debug information
  - Tries to output and run the executable as fast as possible
- *debug_complete*
  - No Optimizations are performed
  - Embeds debug information
  - Generates slower code for better debugging
  - Takes more time to compile
  - Debugs every aspect of compilation, for example compiler binding
    libraries are also compiled in debug mode
- *release_small*
  - Optimizations are performed
  - generate code to prefer size over performance
- *release_fast*
  - Optimizations are performed
  - Release mode, generate code to prefer performance over size

The release modes act as base configuration for your exeuctable. For example, you can use `-g` with any of the modes to embed debug information

To use a mode you must use `--mode` parameter in command line

> chemical chemical.mod -o main.exe --mode debug_complete