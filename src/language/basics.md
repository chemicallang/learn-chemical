# Basic Syntax

Chemical syntax is designed to be familiar if you have used C, C++, or Rust, but with significant cleanups to make it more expressive.

## Variables and Constants

Chemical distinguishes between mutable variables, immutable constants, and compile-time values.

### Mutability
- `var`: Declares a **mutable** variable (can be changed).
- `const`: Declares an **immutable** constant (cannot be changed).

```ch
var age : int = 25
age = 26  // Logical

const PI = 3.14159
// PI = 3.14  // Error!
```

### Type Inference
If you provide an initial value, Chemical can often guess the type for you.

```ch
var name = "Alice"  // inferred as *char
var count = 10      // inferred as int
```

### Compile-time Variables
Use `comptime` to indicate that a value must be known at compile time.

```ch
comptime const VERSION = "1.0.0"
```

## Data Types

### Primitive Types
- **Integers**: `i8`, `i16`, `i32`, `i64`, `int128` (and `u` prefixes for unsigned).
- **C-Compatible**: `char`, `short`, `int`, `long`, `longlong`.
- **Floats**: `float`, `double`, `longdouble`.
- **Other**: `bool`, `void`, `any`.

### Collections
- **Arrays**: Fixed size. `var arr : [5]int`.
- **Slices**: Dynamic view. `var list : []int`.

## Control Flow

### If Statements
If statements can be used as traditional blocks or as expressions.

```ch
if (age >= 18) {
    printf("Adult\n")
} else {
    printf("Minor\n")
}

// As an expression
var status = if (age >= 18) { "Adult" } else { "Minor" }
```

### Loops
Chemical uses `for`, `while`, and `do-while`.

```ch
// Standard for loop
for (var i = 0; i < 10; i++) {
    printf("%d ", i)
}

// While loop
while (condition) {
    // ...
}
```

### Switch
Switch statements are powerful and do not require `break` (no fallthrough by default).

```ch
switch (day) {
    1 => printf("Monday")
    2 => printf("Tuesday")
    default => printf("Other day")
}

// As an expression
var dayName = switch (day) {
    1 => "Monday"
    default => "Unknown"
}
```

---

Next: **[Functions & Lambdas](functions.md)**
