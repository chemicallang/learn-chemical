## Automatic Memory Management

Chemical handles object lifetime through **automatic destructors**.

### Automatic Destructors
When a struct variable goes out of scope, the compiler automatically calls its destructor if one is defined (via `@delete`).

```ch
struct Resource {
    var data : *mut void
    
    @delete func delete(&mut self) {
        free(data)
        printf("Resource freed automatically!\n")
    }
}

func process() {
    var res = Resource { data : std::malloc(1024) }
    // ... use res ...
} // res.delete() is called automatically here
```

## Move & Copy Semantics

Chemical distinguishes between three categories of types based on their copy and move behavior.

### Non-Movable Types (Bitwise Copy)

Simple structs without any special annotations are copied by value (bitwise copy):

```ch
struct Point {
    var x : int
    var y : int
}

var a = Point { x : 10, y : 20 }
var b = a  // Bitwise copy, both a and b are usable
a.x == b.x // true
```

### Movable Types

Structs with a destructor (`@delete`) are **movable**. When assigned, ownership transfers and the original becomes invalid:

```ch
struct MoveObj {
    var i : int
    
    @delete
    func delete(&self) {
        printf("Deleted!\n")
    }
}

var a = MoveObj { i : 32 }
var b = a   // a is MOVED into b, a is now invalid
// Destructor called once when b goes out of scope
```

### Copyable Types

Use `@copy` to define explicit copy behavior:

```ch
struct CopyObj {
    var i : int
    
    @copy
    func copy(&mut self, other : &self) {
        i = other.i
    }
}

var a = CopyObj { i : 45 }
var b = a.copy()  // Explicit copy required
```

### Move/Copy Behavior Summary

| Type          | Annotation     | Assignment Behavior              |
|---------------|----------------|----------------------------------|
| Non-movable   | None           | Bitwise copy, both usable        |
| Movable       | `@delete` only | Move ownership, original invalid |
| Explicit copy | `@copy`        | Must call `.copy()` explicitly   |