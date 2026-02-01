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

Next: **[Web Development Overview](../web/overview.md)**
