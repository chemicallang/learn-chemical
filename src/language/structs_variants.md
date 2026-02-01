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

### Methods and `@constructor`

You can add behavior to your structs using functions. Use `@constructor` for complex initialization logic.

```ch
struct Player {
    var name : std::string
    var health : int

    @constructor func constructor(n : *char) {
        name = std::string(n)
        health = 100
    }
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
