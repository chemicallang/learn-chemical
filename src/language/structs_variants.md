# Structs & Variants

Chemical provides powerful tools for data modeling: **Structs** for grouping related data, and **Variants** (Enums with data) for representing alternative types of information and state.

## Structs

Structs are the primary way to organize data in Chemical. They are contiguous blocks of memory.

### Definition and Initialization

```ch
struct Point {
    var x : float
    var y : float
}

func main() {
    // Explicit initialization
    var p = Point { x : 10.0, y : 20.0 }
}
```

### Methods and Initialization
You can add behavior to your structs using functions. For initialization, Chemical provides a powerful pattern using `@make` and `init` blocks.

#### The `init` Block
The `init` block is a special constructor syntax that ensures all members of a struct are initialized before the function proceeds. This is the safest way to initialize structs with non-default-constructible members.

```ch
struct Player {
    var name : std::string
    var health : int

    @make
    func make(n : *char) {
        init {
            name = std::string(n)
            health = 100
        }
        // After init, you can perform additional logic
        printf("Player %s created!\n", name.c_str())
    }
}
```

#### Member Initialization Syntax

Within an `init` block, you can use two equivalent syntaxes:

```ch
@make
func make() {
    init {
        // Direct assignment
        member_name = value
        
        // Or constructor call syntax
        member_name(value)
    }
}
```

#### Nested Struct Initialization

When a struct contains members with their own constructors, they're automatically called:

```ch
struct Container {
    var inner : InnerStruct  // Has @make constructor
    
    @make
    func make() {
        init {
            inner = InnerStruct()  // Explicit call
        }
    }
}

// Or let the compiler call it automatically
struct AutoContainer {
    var inner : InnerStruct  // Calls InnerStruct() automatically
}
```

### Struct Inheritance
Chemical supports **single struct inheritance**. A derived struct inherits all members and functions of its base.

```ch
struct Animal {
    var a : int
    var b : int
}

struct WalkingAnimal : Animal {
    var speed : int
}

struct Dog : WalkingAnimal {
    var c : int
    var d : int
}
```

#### Inheritance Initialization Syntax

When creating an instance of a derived struct, you must explicitly initialize all levels:

```ch
var d = Dog {
    WalkingAnimal : WalkingAnimal {
        Animal : Animal { a : 30, b : 40 },
        speed : 90
    },
    c : 40,
    d : 40
}
```

#### Accessing Inherited Members

Access base struct members directly:

```ch
d.a      // From Animal: 30
d.b      // From Animal: 40
d.speed  // From WalkingAnimal: 90
d.c      // From Dog: 40
```

#### Methods on Inherited Structs

Methods defined on base structs work on derived structs:

```ch
struct Animal {
    var a : int
    var b : int
    
    func sum(&self) : int {
        return a + b
    }
}

struct Dog : Animal {
    var c : int
}

var dog = Dog { Animal : Animal { a : 5, b : 10 }, c : 20 }
dog.sum()  // Returns 15 (calls Animal.sum)
```

#### Passing Derived as Base

Derived structs can be passed to functions expecting base pointers:

```ch
func get_animal(animal : *Animal) : int {
    return animal.a + animal.b
}

var dog = Dog { ... }
get_animal(&dog)  // Works!
```

#### Constructor Inheritance

When a derived struct has a constructor, base constructors are called automatically:

```ch
struct Base {
    var value : int
    
    @make
    func make() {
        init { value = 100 }
    }
}

struct Derived : Base {
    var extra : int
    
    @make
    func make() {
        init {
            Base = Base()  // Explicit base initialization
            extra = 50
        }
    }
}
```

## Enums

Enums represent a set of named constants. They can have an underlying type (default is `int`) and even support inheritance.

### Basic Enums

```ch
enum Thing {
    Fruit,
    Veg
}

var t = Thing.Fruit
if (t == Thing.Fruit) {
    printf("It's a fruit!\n")
}
```

### Underlying Types

Specify a different underlying type for memory efficiency:

```ch
enum Color : u8 {
    Red,    // 0
    Green,  // 1
    Blue    // 2
}

enum LargeEnum : ushort {
    Value1,
    Value2,
    Value3
}
```

### Custom Values

Set explicit values for enum members:

```ch
enum StartingValue {
    First = 50,   // 50
    Second,       // 51
    Third,        // 52
    Fourth = 10,  // 10
    Fifth,        // 11
    Sixth         // 12
}
```

### Negative Values

Enums can have negative values:

```ch
enum SignedValues {
    NegFirst = -10,  // -10
    NegSecond,       // -9
    NegThird         // -8
}
```

### Member Aliasing

Reference other enum members:

```ch
enum MultiNum {
    First,
    Second,
    AnotherFirst = First,   // Same value as First
    AnotherSecond = Second  // Same value as Second
}
```

### Enum Inheritance

Extend an existing enum with new values:

```ch
enum Thing {
    Fruit,  // 0
    Veg     // 1
}

// Extends Thing, continues numbering
enum Anything : Thing {
    Space,     // 2
    Universe,  // 3
    Garbage    // 4
}

// Anything has all values from Thing plus its own
Anything.Fruit     // 0
Anything.Universe  // 3
```

### Enums in Namespaces

```ch
namespace colors {
    enum favorite {
        red,
        green,
        blue
    }
}

var c = colors::favorite.red
```

## Unions

Unions are low-level memory structures where all members share the same memory location. They are primarily used for C interoperability or extreme memory optimization and are generally **unsafe**.

### Basic Unions

```ch
union IntFloat {
    var i : int
    var f : float
}

var u = IntFloat { i : 42 }
// u.f will reinterpret the same bytes as float
```

> [!CAUTION]
> Accessing a different union member than the one that was set is **undefined behavior**. The compiler does not track which member is active.

### Unions with Nested Structs

Unions can contain anonymous structs for complex layouts:

```ch
union Storage {
    struct {
        var data : *char
        var length : size_t
    } heap;
    struct {
        var buffer : [16]char
        var length : uchar
    } sso;
}

var s : Storage
s.sso.buffer[0] = 'H'
s.sso.length = 1
```

### Methods on Unions

Unions can have methods just like structs:

```ch
union IntFloatUnion {
    var a : int
    var b : float
    
    func give_int(&self) : int {
        return a
    }
    
    func give_float(&self) : float {
        return b
    }
}

var u = IntFloatUnion { a : 12 }
u.give_int()  // Returns 12
```

### Extension Functions on Unions

```ch
func (u : &IntFloatUnion) doubled_int() : int {
    return u.a * 2
}
```

## Type Aliases

Use the `type` keyword to create a new name for an existing type.

### Basic Aliases

```ch
type ID = bigint
type Callback = (int) => void

var user_id : ID = 1000
```

### Function Type Aliases

Simplify complex function types:

```ch
type SimpleFunc = () => int
type HandlerFunc = (event : *Event) => void

func take_simple_func(simple : SimpleFunc) : int {
    return simple()
}

take_simple_func(() => 674)  // Returns 674
```

### Conditional Type Aliases

Create types that change based on compile-time conditions:

```ch
comptime const is_32bit = true

type PlatformInt = if(is_32bit) u32 else u64

// sizeof(PlatformInt) is 4 when is_32bit is true
```

### Local Type Aliases

Type aliases can be defined inside functions:

```ch
func process() {
    const use_32 = true
    type LocalType = if(use_32) u32 else u64
    
    var x : LocalType = 100
}
```

## Automatic Memory Management

Chemical handles object lifetime through **automatic destructors**.

### Automatic Destructors
When a struct variable goes out of scope, the compiler automatically calls its destructor if one is defined (via `@delete`).

```ch
struct Resource {
    var data : *mut void
    
    @delete func delete(&mut self) {
        std::free(data)
        printf("Resource freed automatically!\n")
    }
}

func process() {
    var res = Resource { data : std::malloc(1024) }
    // ... use res ...
} // res.delete() is called automatically here
```

## Variants

Variants (also known as Tagged Unions) allow a variable to hold one of several different types of data.

### Definition and Layout
A variant consists of a **Tag** (automatically managed integer) and a **Union** of the data associated with each case.

```ch
variant Shape {
    Circle(radius : float)
    Rect(w : float, h : float)
    None()
}
```

### Pattern Matching

Pattern matching is strictly reserved for **Variants**.

#### `if (var ...)` Syntax
Extraction and condition in one step.

```ch
if (var Shape.Circle(r) = my_shape) {
    printf("Radius is %f\n", r)
}
```

#### `match` / `switch` Syntax
```ch
switch (my_shape) {
    Shape.Circle(r) => return 3.14 * r * r
    Shape.Rect(w, h) => return w * h
    default => return 0.0
}
```

#### The `else` Unwrapping
Used for quick data extraction. If the variant doesn't match the case, the `else` block is executed (must return, panic, or skip).

```ch
var Shape.Circle(r) = my_shape else std::panic("Expected a circle")
printf("Radius: %f\n", r);
```

### Type Testing with `is`
Check the state without extracting data.
```ch
if (my_shape is Shape.Circle) {
    // ...
}
```

> [!IMPORTANT]
> Because Variants use a tag and union layout, they are highly memory-efficient, consuming only as much space as the largest case + the tag.

