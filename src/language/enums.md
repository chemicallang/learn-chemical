# Enums

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