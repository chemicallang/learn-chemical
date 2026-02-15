# Unions

Unions are low-level memory structures where all members share the same memory location. They are primarily used for C interoperability or extreme memory optimization and are generally **unsafe**.

### Basic Unions

```ch
union IntFloat {
    var i : int
    var f : float
}

var u = IntFloat { i : 42 }
// u.f will reinterpret the same bytes as float

// when you try to initialize a union, you must initialize only a single member
var u2 = IntFloat { i : 234, f : 0.324f } // ❌ error: only a single member can be initialized
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