# Conditional Compilation

## Conditional Compilation through chemical.mod

This is the preferred way of conditional compilation as it saves compilation time

in `chemical.mod` file, you can use `source` statements

```
source "src"
```

We can also use a if condition with this source statement like this

```
// include win directory only when compiling for windows
source "win" if windows
```

currently support for conditionals is limited, You should use a `build.lab` file for proper support

## Conditional Compilation inside source files (experimental)

You can also just do conditional compilation in source files like this

```
if(def.windows) {
    // code will only run on windows
}
```

Please note this syntax may change to something like this in future

```
$if(def.windows) {}
```

or

```
if comptime(def.windows) {}
```

## Conditional Compilation inside build.lab

since chemical code is written inside build.lab, You should just use if(def.windows) to include source files

> *We'll go over this in the future, build.lab features are experimental*