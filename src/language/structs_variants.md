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

### Struct Inheritance
Chemical supports **single struct inheritance**. A derived struct inherits all members and functions of its base.

```ch
struct Animal {
    var age : int
    func breathe() { ... }
}

struct Dog : Animal {
    var breed : std::string
}

var d = Dog {
    Animal : Animal { age : 5 },
    breed : "Golden Retriever"
}
d.breathe() // Inherited from Animal
```

## Enums

Enums represent a set of named constants. They can have an underlying type (default is `int`) and even support inheritance.

```ch
enum Color : u8 {
    Red,
    Green,
    Blue = 10, // Explicit value
    Yellow     // 11
}

// Enum Inheritance
enum extended_color : Color {
    Cyan,
    Magenta
}
```

## Unions

Unions are low-level memory structures where all members share the same memory location. They are primarily used for C interoperability or extreme memory optimization and are generally **unsafe**.

```ch
union IntFloat {
    var i : int
    var f : float
}

var u = IntFloat { i : 42 }
unsafe {
    printf("%f", u.f) // Accessing different members is unsafe!
}
```

## Type Aliases

Use the `type` keyword to create a new name for an existing type.

```ch
type ID = bigint
type Callback = (int) => void

var user_id : ID = 1000
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
