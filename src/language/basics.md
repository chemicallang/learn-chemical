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
- **Floats & Doubles**: 
    - `float` (32-bit, use `f` suffix: `3.14f`)
    - `double` (64-bit, default for literals: `3.14`)
    - `longdouble`, `float128` (extended precision).
    - Integers can be used in expressions with floats/doubles and will be implicitly converted.
- **Other**: `bool`, `void`, `any`.

## Operators

### Increment and Decrement
Chemical supports C++ style increment (`++`) and decrement (`--`) operators.
- **Prefix**: `++i`, `--i` (increments/decrements then returns the new value).
- **Postfix**: `i++`, `i--` (returns the current value then increments/decrements).

```ch
var i = 1
i++      // i is now 2
var j = ++i // i is 3, j is 3
```

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

### Control Flow as Values
In Chemical, `if`, `switch`, and even `loop` can be used as **expressions** that return a value.

- **If value**: `var x = if(cond) a else b`
- **Switch value**: Directly returns the value after `=>`.
- **Loop value**: Use `break value` to return a value from a loop.

```ch
var status = if (age >= 18) "Adult" else "Minor"

var dayName = switch (day) {
    1 => "Monday"
    default => "Unknown"
}

var result = loop {
    if (ready) break 42
}
```

### The `in` Expression
The `in` expression is a concise way to check if a value matches one of several constants, similar to a simplified switch expression.

```ch
var is_vowel = char in 'a', 'e', 'i', 'o', 'u'
if (x !in 1, 2, 3) {
    // x is not 1, 2, or 3
}
```

## Loops

Chemical provides several ways to repeat code:

- **For loop**: Standard `for(init; cond; step)`.
- **While loop**: `while(cond)`.
- **Do-While loop**: `do { ... } while(cond)`.
- **Infinite loop**: Use `loop { ... }` for a loop that runs forever unless a `break` or `return` is encountered.

```ch
loop {
    if (task_done()) break
}
```
