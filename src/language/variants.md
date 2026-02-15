# Variants

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
var Shape.Circle(r) = my_shape else unreachable
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

### Methods in Variants

Variants can have methods that operate on their internal data:

```ch
variant FuncInVariant {
    First(value : int)
    Second(value : int)
    
    func get(&self) : int {
        switch(self) {
            First(value) => return value;
            Second(value) => return value;
        }
    }
}

var v = FuncInVariant.First(232)
v.get()  // Returns 232
```

### Variant Inheritance from Structs

Variants can inherit from structs to share common data across all cases:

```ch
struct Point {
    var a : int = 10
    var b : int = 20
    
    func multiply(&self) : int {
        return a * b
    }
}

variant Shape : Point {
    Circle(radius : int)
    Rect(width : int, height : int)
}

var s = Shape.Circle(5)
s.a  // 10 (inherited, default initialized)
s.b  // 20 (inherited, default initialized)
s.multiply()  // 200
```

### Variant Interface Implementation

Variants can implement interfaces with `@override`:

```ch
interface Giver {
    func give(&self) : int
}

variant OptionalInt : Giver {
    None()
    Some(value : int)
    
    @override
    func give(&self) : int {
        switch(self) {
            None() => return -1;
            Some(value) => return value;
        }
    }
}
```

#### Static Dispatch with Variants

Use generic constraints for zero-cost abstraction:

```ch
func <T : Giver> get_value(v : &T) : int {
    return v.give()
}

var opt = OptionalInt.Some(42)
get_value(opt)  // 42
```

#### Dynamic Dispatch with Variants

Use `dyn` for runtime polymorphism:

```ch
func process_giver(g : dyn Giver) : int {
    return g.give()
}

var opt = OptionalInt.Some(93)
process_giver(dyn<Giver>(opt))  // 93
```