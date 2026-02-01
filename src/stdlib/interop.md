# C Interop & Translation

One of Chemical's greatest strengths is its perfect relationship with the C programming language.

## Calling C from Chemical

You can call any C function by declaring its signature with the `@extern` attribute.

```ch
@extern
public func malloc(size : usize) : *void

@extern
public func free(ptr : *void) : void

public func main() {
    unsafe {
        var p = malloc(1024)
        free(p)
    }
}
```

### C-Compatible Types
When interacting with C, it is recommended to use the types prefixed with `c_` or the direct C type names to ensure binary compatibility:
- `char`, `short`, `int`, `long`, `longlong`
- `uchar`, `ushort`, `uint`, `ulong`, `ulonglong`

## C Structs
To use a C struct, mark it as `@extern`.

```ch
@extern
struct CPoint {
    var x : int
    var y : int
}
```

## How C Translation Works

When you build a Chemical project, the compiler performs the following steps:
1.  **Parsing**: Reads your `.ch` files into an AST.
2.  **Semantic Analysis**: Checks types, visibility, and logic.
3.  **C Generation**: Translates the Chemical AST into highly optimized C99/C11 code.
4.  **C Compilation**: Hand off the generated C code to a back-end like `Clang` or `TCC` to produce the final binary.

### Benefits of this Approach
- **Portability**: Chemical code can run anywhere a C compiler exists.
- **Performance**: You get the optimization benefits of mature C compilers like Clang and GCC.
- **Interoperability**: Linking with existing C/C++ libraries is as simple as adding them to your `build.lab` file.

## Translating C to Chemical

The Chemical compiler can also perform the reverse! You can use `ctx.translate_to_chemical` in a `build.lab` script to automatically generate Chemical signatures from C header files.

```ch
// In build.lab
const lib_mod = ctx.c_file_module("", "my_c_lib", "lib.c", [])
ctx.translate_to_chemical(lib_mod, "src/gen/lib_bindings.ch")
```

---

**Congratulations!** You have reached the end of the Chemical documentation. You are now ready to build world-class systems and web applications.
