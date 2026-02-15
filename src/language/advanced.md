# Advanced Features

Chemical includes powerful features for library authors and performance-critical applications.

## Operator Overloading

You can define how symbols like `+`, `-`, `*`, etc., work for your custom structs by implementing interfaces in the `core::ops` namespace.

### Example: Vector Addition
```ch
using namespace core::ops

struct Vec2 {
    var x : float
    var y : float
    
    // Implement the Add interface
    func add(&self, rhs : Vec2) : Vec2 {
        return Vec2 { x : self.x + rhs.x, y : self.y + rhs.y }
    }
}

var v1 = Vec2 { x : 1.0, y : 2.0 }
var v2 = Vec2 { x : 3.0, y : 4.0 }
var v3 = v1 + v2 // Automatically calls .add()!
```

Available interfaces include `Add`, `Sub`, `Mul`, `Div`, `PartialEq` (`==`), and more.

## Comptime (Compile-time Execution)

Chemical allows you to run code during compilation. This is perfect for generating data or choosing logic based on the target OS.

### Comptime If
```ch
comptime if (def.windows) {
    // This code only exists if compiling for Windows
} else {
    // This code only exists for other platforms
}
```

### Comptime Functions
Functions marked `comptime` can be executed by the compiler.

```ch
comptime func get_build_date() : *char {
    return "2026-02-01"
}
```

### Comptime Constructors

You can define constructors that run during compilation. These can return struct instances directly or delegate to other constructors using `intrinsics::wrap()`.

```ch
struct Pair {
    var a : int
    var b : int

    @make
    comptime func from_sum(sum : %literal<int>) {
        return Pair {
            a : sum / 2,
            b : sum / 2
        }
    }

    @make
    comptime func delegated(use_first : bool) {
        if (use_first) {
            return intrinsics::wrap(first())
        } else {
            return intrinsics::wrap(second())
        }
    }

    @make func first() { return { a : 15, b : 15 } }
    @make func second() { return { a : 20, b :20 } }
}
```

### Comptime Types: `%literal` and `%runtime`

- `%literal<T>`: Represents a compile-time constant of type `T`.
- `%runtime<T>`: Represents a value that will only be available at runtime, but can be passed through comptime logic.

```ch
@make
comptime func logger(thing : %runtime<*mut int>) {
    // Delegate to an actual runtime constructor
    return intrinsics::wrap(actual_constructor(thing));
}
```

## Intrinsics API

Chemical provides a set of low-level compiler intrinsics via the `intrinsics` namespace. These are mostly used inside `comptime` blocks.

| Intrinsic                           | Description                                                              |
|-------------------------------------|--------------------------------------------------------------------------|
| `intrinsics::size(str)`             | Returns the length of a string literal at compile-time.                  |
| `intrinsics::get_line_no()`         | Returns the current source line number.                                  |
| `intrinsics::get_caller_line_no()`  | Returns the line number of the caller.                                   |
| `intrinsics::get_module_name()`     | Returns the name of the current module.                                  |
| `intrinsics::get_module_scope()`    | Returns the current module's scope path.                                 |
| `intrinsics::get_target()`          | Returns information about the compilation target.                        |
| `intrinsics::get_child_fn<T>(name)` | Retrieves a function pointer for a member function by its name (string). |
| `intrinsics::wrap(call)`            | Wraps a runtime call to be returned from a comptime context.             |

### Example: Reflection-like Function Access

```ch
struct MyAPI {
    func execute() { printf("Executed!\n") }
}

comptime func get_exec_fn() : () => void {
    return intrinsics::get_child_fn<MyAPI>("execute") as () => void
}

var fn = get_exec_fn()
fn() // Calls MyAPI.execute
```

## Attributes (Annotations)

Attributes provide metadata to the compiler.

- `@extern`: Marks a function defined in another language (usually C).
- `@test`: Marks a function for the test runner.
- `@deprecated`: Issues a warning when the function is used.
- `@inline`: Hints that the compiler should inline this function.
- `@no_mangle`: Tells the compiler to keep the function name exactly as written in the resulting C/binary code.

```ch
@deprecated("Use new_system instead")
func old_system() { ... }
```


---
