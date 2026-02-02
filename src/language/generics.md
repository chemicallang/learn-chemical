# Generics

Chemical provides a powerful generics system that allows you to write reusable, type-safe code. Generics can be applied to functions, structs, variants, and interfaces.

## Basic Syntax

Generic parameters are specified within angle brackets `< >` before the function name or after the type name.

```ch
func <T> identity(value : T) : T {
    return value
}

struct Box<T> {
    var item : T
}

var int_box = Box<int> { item : 42 }
```

## Generic Functions

Generic functions can have multiple type parameters and work with any type:

```ch
func <T, K, R> sum(a : T, b : K) : R {
    return (a + b) as R
}

// Usage - types are inferred from arguments
var result = sum(10, 20)  // Returns 30

// Explicit type parameters when needed
var long_result = sum<long, long, long>(20, 30)
```

## Generic Structs

Structs can have multiple generic type parameters:

```ch
struct PairGen<T, U, V> {
    var a : T
    var b : U
    
    func add(&self) : V {
        return (a + b) as V
    }
}

var p = PairGen<int, int, int> { a : 10, b : 12 }
var sum = p.add()  // Returns 22
```

### Generic Methods on Structs

Generic structs can contain methods, and methods themselves can introduce additional generic parameters:

```ch
struct GenericStruct<T, U> {
    var value1 : T
    var value2 : U
    
    func <V> generic_method(param : V) : V {
        return param
    }
}
```

### Storing Generic Structs

Generic structs can be stored in other structs:

```ch
@direct_init
struct Container {
    var pair : PairGen<short, short, short>
    
    @constructor
    func make() {
        init {
            pair(PairGen<short, short, short> { a : 33, b : 10 })
        }
    }
}
```

## Default Type Parameters

You can provide default values for generic type parameters:

```ch
// R defaults to int if not specified
func <T, R = int> convert(value : T) : R {
    return value as R
}

// Struct with default type parameter
struct GenStructDef<T = long> {
    var value : T
    
    func test(&self) : bool {
        return T is long
    }
}

// Using defaults (empty angle brackets)
var s = GenStructDef<> { value : 10 }
// Equivalent to GenStructDef<long> { value : 10 }
```

When a function argument provides enough information, the inferred type takes precedence over the default:

```ch
func <T = short> give_me_size() : T {
    if(T is short) { return 2 }
    else if(T is int) { return 4 }
    else { return 8 }
}

// If result is assigned to an int, T is inferred as int (not default short)
var result : int = give_me_size()  // Returns 4
```

## Generic Dispatch & Constraints

You can constrain a generic type to only those that implement a specific interface.

```ch
interface Printable {
    func print(&self)
}

func <T : Printable> print_item(item : &T) {
    item.print()
}
```

## Conditional Compilation with `is`

The `if (T is Type)` construct allows the compiler to choose different code paths based on the concrete type provided for a generic parameter. This is similar to C++ `if constexpr`.

```ch
func <T> get_type_size() : int {
    if (T is short) {
        return 2
    } else if (T is int) {
        return 4
    } else if (T is long) {
        return 8
    } else {
        return sizeof(T) as int
    }
}
```

### Multi-Type Checks

You can combine multiple type checks:

```ch
func <T> gen_ret_func(value : T) : T {
    if(T is char || T is uchar || T is i8 || T is u8) {
        return value + 1
    } else if(T is short || T is ushort || T is i16 || T is u16) {
        return value + 2
    } else if(T is int || T is uint || T is i32 || T is u32) {
        return value + 4
    } else if(T is longlong || T is ulonglong || T is i64 || T is u64) {
        return value + 8
    } else {
        return value + 0
    }
}
```

### Inside Generic Structs

Type checks work inside generic struct methods:

```ch
struct TypeChecker<T> {
    func get_integer() : T {
        if(T is char || T is uchar) { return 1 }
        else if(T is short || T is ushort) { return 2 }
        else if(T is int || T is uint) { return 4 }
        else if(T is bigint || T is ubigint) { return 8 }
        else { return 0 }
    }
}
```

## Generic Variants

Generics are essential for creating flexible data structures like `Option` or `Result`.

```ch
variant Option<T> {
    Some(value : T)
    None()
}

var opt = Option.Some<int>(10)

// Multi-parameter generic variant
variant Result<T, E> {
    Ok(value : T)
    Err(error : E)
}
```

### Pattern Matching with Generic Variants

```ch
func get_value(opt : Option<int>) : int {
    switch(opt) {
        Some(value) => return value
        None => return -1
    }
}
```

## Generic Interfaces

Interfaces can be generic and use the `Self` keyword:

```ch
interface GenAddInterface<Output, Rhs = Self> {
    func add(&self, rhs : Rhs) : Output
}

struct Point : GenAddInterface<Point, Point> {
    var a : int
    var b : int
    
    @override
    func add(&self, rhs : Point) : Point {
        return Point {
            a : a + rhs.a,
            b : b + rhs.b
        }
    }
}
```

## Extension Functions on Generic Types

You can define extension functions for generic structs:

```ch
func <T, U, V> (pair : &PairGen<T, U, V>) ext_div() : V {
    return pair.a / pair.b
}

// Usage
var p = PairGen<short, short, short> { a : 56, b : 7 }
var result = p.ext_div<short, short, short>()  // Returns 8
```

## Generics in Namespaces

Generic types work within namespaces:

```ch
namespace gen_container {
    struct ContainedGen<T> {
        var x : T
        
        func size(&self) : int {
            if(T is short) { return 2 }
            else if(T is int) { return 4 }
            else if(T is bigint) { return 8 }
            else { return 0 }
        }
    }
}

// Access via namespace
var x = gen_container::ContainedGen<int> { x : 10 }
```

## Comptime Functions in Generic Contexts

Comptime functions called within generic contexts are re-evaluated for each type instantiation:

```ch
comptime func <T> comptime_func() : int {
    if(T is short) { return 2 }
    else if(T is int) { return 4 }
    else if(T is bigint) { return 8 }
    else { return 0 }
}

func <T> gen_wrap_comptime() : int {
    return comptime_func<T>()
}

// Each call produces different results
gen_wrap_comptime<short>()   // Returns 2
gen_wrap_comptime<int>()     // Returns 4
gen_wrap_comptime<bigint>()  // Returns 8
```

## Lambda Functions in Generic Containers

Lambdas can exist inside generic functions and use the generic type:

```ch
func <T> gen_lamb_func() : T {
    var lamb : () => T = () => {
        return 287
    }
    return lamb()
}

func <T> gen_lamb_with_param() : T {
    var lamb : (a : T) => T = (a : T) => {
        return a
    }
    return lamb(93837)
}
```

