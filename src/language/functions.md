# Functions & Lambdas

Chemical supports top-level functions, methods, and powerful lambda expressions.

## Function Declarations

Functions are declared with the `func` keyword.

```ch
public func add(a : int, b : int) : int {
    return a + b
}
```

## Default Parameters

Functions can have default values for parameters. When a parameter has a default value, it becomes optional when calling the function.

```ch
func greet(name : *char = "World") {
    printf("Hello, %s!\n", name)
}

greet()         // Prints: Hello, World!
greet("Alice")  // Prints: Hello, Alice!
```

### Default Parameters in Functions

```ch
func give_me_the_default_value(value : int = 832) : int {
    return value
}

give_me_the_default_value()     // Returns 832
give_me_the_default_value(100)  // Returns 100
```

### Default Parameters in Struct Methods

Methods can also have default parameters:

```ch
struct Calculator {
    func add(&self, a : int, b : int = 10) : int {
        return a + b
    }
}

var calc = Calculator {}
calc.add(5)      // Returns 15 (5 + default 10)
calc.add(5, 20)  // Returns 25 (5 + 20)
```

> [!NOTE]
> Default parameters must be placed at the **end** of the parameter list. You cannot have a non-default parameter after a default one.

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

### Capture Types

#### Value Capture (`|var|`)

Copies the variable's value at the time of lambda creation:

```ch
var temp = 11
var fn : std::function<() => int> = |temp|() => {
    return temp  // Uses the copied value
}
```

#### Reference Capture (`|&var|`)

Captures a read-only reference to the original variable:

```ch
var temp = 434
var result = take_cap_func(|&temp|() => {
    return *temp  // Must dereference to access value
})
```

#### Mutable Reference Capture (`|&mut var|`)

Captures a mutable reference, allowing modification:

```ch
var temp = 0
take_cap_func(|&mut temp|() => {
    *temp = 121  // Modifies the original variable
    return 0
})
// temp is now 121
```

### Multiple Captures

Capture multiple variables in a single lambda:

```ch
func wrap_cap_lamb(ptr : *mut int, fn : std::function<() => int>) : std::function<() => void> {
    return |ptr, fn|() => {
        var result = fn()
        *ptr = result
    }
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

## Capturing Lambdas with Parameters

Capturing lambdas can take parameters just like regular functions:

```ch
func take_cap_func(fun : std::function<(a : int) => int>) : int {
    return fun(256)
}

// No capture
const arg = take_cap_func(||(a : int) => {
    return a * 2
})

// With capture
var x = 100
const arg2 = take_cap_func(|x|(a : int) => {
    return a + x
})
```

### Automatic Dereference in Indexing

When a captured reference is used in an index operation, it's automatically dereferenced:

```ch
var index = 0
const arg = take_cap_func(|&mut index|(a : int) => {
    var arr = [ 8323, 23485 ]
    return arr[index]  // index is automatically dereferenced
})
```

## Capturing Structs

### By Reference

Capture a struct by reference to call methods on it:

```ch
struct MyStruct {
    var value : int
    func double(&self) : int { return value * 2 }
}

var s = MyStruct { value : 92 }
var result = take_cap_func(|&mut s|() => {
    return s.double()  // Methods work on captured structs
})
```

### By Pointer

Capture a struct pointer to access methods:

```ch
var s = new MyStruct { value : 32 }
var result = take_cap_func(|s|() => { 
    return s.double() 
})
dealloc s
```

### Nested Member Access

Access nested struct members through captured pointers:

```ch
struct Container { var value : MyStruct }

var container = new Container { value : MyStruct { value : 33 } }
var result = take_cap_func(|container|() => { 
    return container.value.double() 
})
```

## Lambdas Returning Structs

Capturing lambdas can return struct values:

```ch
var f : std::function<() => MyStruct> = () => {
    return MyStruct { value : 992 }
}
var x = f()  // x.value is 992
```

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

## Extension Functions

Extension functions allow you to add new functionality to existing structs, variants, or interfaces without modifying their original definition. They are defined by specifying the receiver type in parentheses before the function name.

**Extension functions can only be called through references.**

```ch
struct Point {
    var x : int
    var y : int
}

// Extension function for Point
func (p : &Point) distance_to_origin() : float {
    return sqrt((p.x * p.x + p.y * p.y) as float)
}

var pt = Point { x : 3, y : 4 }
var d = pt.distance_to_origin()  // Calls extension function
```

### Extension Functions on Inherited Structs

Extension functions defined on a base struct work on all derived structs:

```ch
struct BasePoint {
    var a : int
    var b : int
}

func (point : &BasePoint) sum() : int {
    return point.a + point.b
}

struct Vertex : BasePoint {
    var c : int
}

var v = Vertex {
    BasePoint : BasePoint { a : 23, b : 8 },
    c : 2
}
v.sum()  // Works! Returns 31
```

### Generic Extension Functions on Structs

Extension functions can be generic:

```ch
struct MyStruct : SomeInterface {
    // ...
}

func <T> (thing : &mut MyStruct) ext_func_gen() : int {
    if(T is short) {
        return 2 + thing.some_method()
    } else if(T is int) {
        return 4 + thing.some_method()
    } else {
        return 8 + thing.some_method()
    }
}

var s = MyStruct {}
s.ext_func_gen<short>()  // Returns 2 + ...
s.ext_func_gen<int>()    // Returns 4 + ...
s.ext_func_gen<long>()   // Returns 8 + ...
```

### Generic Extension Functions on Interfaces

Extension functions are also useful for adding generic logic to interfaces:

```ch
interface Printable {
    func print(&self)
}

// Extension for any type that implements Printable
func <T : Printable> (item : &T) print_twice() {
    item.print()
    item.print()
}

// Extension function that calls interface methods
interface Summer {
    func sum(&self) : int
}

func <T : Summer> (item : &mut T) sum_twice() : int {
    return item.sum() * 2
}
```

### Extension Functions on Variants

Extension functions work on variants too:

```ch
variant Option<T> {
    Some(value : T)
    None()
}

func <T> (opt : &Option<T>) is_some() : bool {
    return opt is Option.Some
}
```

