# Conditional Compilation

## Conditional Compilation through chemical.mod

This is the preferred way of conditional compilation as it saves compilation time

in `chemical.mod` file, you can use `source` statements

```chmod
source "src"
```

We can also use a if condition with this source statement like this

```chmod
// include win directory only when compiling for windows
source "win" if windows

// include pos directory only when compiling for posix
source "pos" if posix
```

currently support for conditionals is limited, You should use a `build.lab` file for proper support

## Conditional Compilation inside source files (experimental)

You can also just do conditional compilation in source files like this

```ch
comptime if(def.windows) {
    // code will only run on windows
}
```
## Conditional Compilation inside build.lab

since chemical code is written inside `build.lab`, You should just use `comptime if(def.windows)` to include source files

> *We'll go over this in the future, build.lab features are experimental*