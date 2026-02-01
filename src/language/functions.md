# Functions & Lambdas

Chemical supports top-level functions, methods, and powerful lambda expressions.

## Function Declarations

Functions are declared with the `func` keyword.

```ch
public func add(a : int, b : int) : int {
    return a + b
}
```

## Function Pointers

A basic function type refers to a pure function pointer. These **cannot capture** variables from their surrounding scope.

```ch
var my_ptr : () => void = () => {
    printf("I am a simple function pointer\n");
}
```

## Capturing with `std::function`

To capture variables from the environment (closures), you must use the `std::function` type. The capture occurs within the `||` block.

**Only `std::function` can have capturing lambdas.**

```ch
import std

func create_counter() : std::function<() => int> {
    var count = 0
    
    // Capturing 'count' via ||
    var f : std::function<() => int> = |count| () => { 
        count = count + 1
        return count
    }
    
    return f
}
```

### Implicit Conversion
You can assign a capturing lambda directly to a `std::function`. The compiler provides an implicit constructor that wraps the lambda into a capturing object.

```ch
var factor = 2
// Implicitly converted to std::function because of variable capture
var multiplier : std::function<(int) => int> = |factor| (n) => {
    return n * factor
}
```

> [!IMPORTANT]
> If you attempt to capture variables `|x|` in a lambda assigned to a raw function pointer `(int) => int`, the compiler will issue an error.

## Lambdas and `auto`

You can use type inference for local lambdas, but be aware of the resulting type:

```ch
// Result is a raw function pointer (no capture allowed)
const simple = () => { printf("hi"); }

// Result is a std::function (captures allowed)
const closure = |x| () => { return x; }
```

## Passing Functions

When designing APIs, use `std::function` if you want to allow users to pass closures. Use raw function pointers only if you want to enforce zero-allocation, non-capturing callbacks (similar to C).

```ch
// API that supports closures
func do_something(callback : std::function<() => void>) {
    callback()
}
```
