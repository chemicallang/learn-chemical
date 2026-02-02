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
- **Other**: `bool`, `void`, `any`.

### Floating Point Numbers

Chemical supports several floating-point types:
- `float`: 32-bit floating point. Use the `f` suffix for literals: `3.14f`
- `double`: 64-bit floating point. This is the default for decimal literals: `3.14`
- `longdouble`, `float128`: Extended precision types for specialized use.

```ch
var f1 : float = 3.14f      // 32-bit float
var f2 : double = 3.14159   // 64-bit double (default)
var f3 = 2.5                // inferred as double
```

Integers are implicitly converted when used in expressions with floats or doubles:

```ch
var x : float = 10.5f
var y = x + 5     // 5 is converted to float, result is 15.5f
```

### Default Member Values

You can provide default values for struct and variant members directly in their definition. This is useful for providing sensible defaults and is automatically picked up by constructors.

```ch
struct Player {
    var health : int = 100
    var score  : int = 0
    var name   : *char = "Unnamed"
}

var p = Player {}
// p.health is 100
// p.score is 0
// p.name is "Unnamed"
```

Default values are also supported in variants, which is particularly useful when variants inherit from structs to share common state:

```ch
struct Base {
    var id : int = -1
}

variant Entity : Base {
    Active(name : *char)
    Inactive()
}

var e = Entity.Active("Alice")
e.id == -1 // true
```


## Operators

### Increment and Decrement
Chemical supports C++ style increment (`++`) and decrement (`--`) operators.
- **Prefix**: `++i`, `--i` (increments/decrements then returns the new value).
- **Postfix**: `i++`, `i--` (returns the current value then increments/decrements).

```ch
var i = 1
i++      // i is now 2
var j = ++i // i is 3, j is 3
var k = i-- // k is 3, i is now 2

// Works with pointers too
var arr = [10, 20, 30]
var ptr = &arr[0]
ptr++    // ptr now points to arr[1]
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

Chemical provides several ways to repeat code:

- **For loop**: Standard `for(init; cond; step)`.
- **While loop**: `while(cond)`.
- **Do-While loop**: `do { ... } while(cond)`.
- **Infinite loop**: Use `loop { ... }` for a loop that runs forever unless a `break` or `return` is encountered.

```ch
// Standard for loop
for (var i = 0; i < 10; i++) {
    printf("%d ", i)
}

// While loop
while (condition) {
    // ...
}

// Do-while loop
do {
    attempt_connection()
} while (!connected)

// Infinite loop
loop {
    if (task_done()) break
    process_next_item()
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

## Control Flow as Values

In Chemical, `if`, `switch`, and even `loop` can be used as **expressions** that return a value. This is one of the most powerful features of the language.

### If as a Value

The simplest form returns a value from each branch:

```ch
var status = if (age >= 18) "Adult" else "Minor"
```

You can use braces for multi-statement blocks. The last expression in the block is the value:

```ch
var result = if (x > 0) {
    var temp = x * 2
    temp + 1   // This is the return value
} else {
    0
}
```

### Nested If Values

If expressions can be nested for complex logic:

```ch
var i = 2
var j = if(i > 0) if(i < 2) 10 else 20 else 30
// When i=2: i>0 is true, i<2 is false, so j=20
// When i=1: i>0 is true, i<2 is true, so j=10
// When i=0: i>0 is false, so j=30
```

### Switch as a Value

Switch expressions directly return the value after `=>`:

```ch
var dayName = switch (day) {
    1 => "Monday"
    2 => "Tuesday"
    3 => "Wednesday"
    default => "Unknown"
}
```

With braced cases for additional logic:

```ch
var multiplier = switch (mode) {
    1 => {
        printf("Fast mode\n")
        10
    }
    2 => {
        printf("Slow mode\n")
        1
    }
    default => 5
}
```

### Nested If in Switch

You can nest if expressions inside switch cases:

```ch
var i = 2
var use_tens = true
var j = switch(i) {
    1 => if(use_tens) 10 else 100
    2 => if(use_tens) 20 else 200
    default => 0
}
// Result: 20
```

### Nested Switch in If

Similarly, switch expressions can be nested inside if:

```ch
var i = 2
var j = if(i > 0) switch(i) {
    1 => 10
    2 => 20
    default => 40
} else 0
// Result: 20
```

### Loop as a Value

Use `break value` to return a value from a loop:

```ch
var i = 0
var result = loop {
    if (i == 5) break i    // Returns 5
    i++
}
// result is 5
```

This is particularly useful for search patterns:

```ch
var found_index = loop {
    if (current >= array_size) break -1
    if (array[current] == target) break current
    current++
}
```

### Struct Values in Control Flow

Control flow expressions work with struct types too:

```ch
struct Container { var data : int }

var first = Container { data : 10 }
var second = Container { data : 20 }
var condition = true

var selected = if(condition) first else second
// selected.data is 10
```

## The `in` Expression

The `in` expression provides a concise way to check if a value matches one of several constants. It works like a simplified switch expression that returns a boolean.

### Basic Usage

```ch
// Check if a character is a vowel
var is_vowel = char in 'a', 'e', 'i', 'o', 'u'

// Store result in a const
const x = 'a'
const result = x in 'a', 'b', 'c'  // true
```

### Negation with `!in`

Use `!in` to check if a value does NOT match any of the options:

```ch
if (x !in 1, 2, 3) {
    // x is not 1, 2, or 3
    printf("x is something else\n")
}
```

### In Control Flow

The `in` expression integrates naturally with if statements:

```ch
var char = 'e'
if (char in 'a', 'e', 'i', 'o', 'u') {
    printf("It's a vowel!\n")
}

if (status_code !in 200, 201, 204) {
    printf("Request failed\n")
}
```

### Double Negation

For complex conditions:

```ch
// This is true when x IS in the list
return !('a' !in 'a', 'b', 'c')
```

> [!NOTE]
> The `in` expression only works with **constant values**. The values after `in` must be compile-time constants, similar to switch case values.

