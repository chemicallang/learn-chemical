# Memory & Unsafe

As a systems language, Chemical gives you direct control over memory when needed, while offering safer abstractions for everyday tasks.

## Pointers and References

### References (`&`)
References are safe, non-null pointers managed by the language.
- `&T`: Immutable reference.
- `&mut T`: Mutable reference.

### Pointers (`*`)
Pointers are raw memory addresses, similar to C pointers. They are **unsafe** to dereference.
- `*T`: Immutable pointer.
- `*mut T`: Mutable pointer.

#### Pointer Arithmetic
Chemical supports standard pointer arithmetic within `unsafe` blocks.
- `ptr + n` / `ptr - n`: Offset the pointer.
- `ptr1 - ptr2`: Calculate the distance between two pointers of the same type.
- `ptr++` / `ptr--`: Increment or decrement the pointer.
- `ptr[index]`: Array-style access via pointers.

```ch
unsafe {
    var arr = [1, 2, 3]
    var p : *int = &arr[0]
    var second = *(p + 1) // 2
    var third = p[2]      // 3
}
```

## Type Reflection: `sizeof` and `alignof`

Use these built-in macros to get memory characteristics of any type. They return a `ubigint`.

- `sizeof(T)`: Returns the size of type `T` in bytes.
- `alignof(T)`: Returns the alignment requirement of type `T`.

```ch
var size = sizeof(int)    // 4
var align = alignof(long) // 4 or 8 depending on platform
```

## Unsafe Blocks

Operations that could potentially crash the program (like manual memory management or pointer dereferencing) must be wrapped in an `unsafe` block. This serves as a "warning sign" in your code.

```ch
unsafe {
    var ptr = malloc(16) as *mut int
    *ptr = 100
    free(ptr)
}
```

## Manual Allocation

Chemical provides keywords for manual memory management within unsafe blocks:

- `new T`: Allocates memory for type `T` and calls its constructor.
- `new (ptr) T`: **Placement new**. Constructs an object of type `T` at the specified memory address `ptr` without allocating new memory.
- `dealloc ptr`: Frees memory allocated for non-struct types.
- `destruct ptr`: Calls the destructor for a struct and then frees the memory.

```ch
unsafe {
    var p = new Player("Antigravity")
    
    // Placement new example
    var buffer = malloc(sizeof(Point)) as *mut Point
    new (buffer) Point { x : 10, y : 20 }
    
    destruct p
    free(buffer)
}
```

## Destructors

You can define a destructor for a struct using the `@delete` annotation. This function will be called automatically when an instance goes out of scope or when `destruct` is called.

```ch
struct Resource {
    var raw_handle : *void
    
    @delete
    func destroy(&self) {
        unsafe {
             printf("Cleaning up resource...\n")
             close_handle(self.raw_handle)
        }
    }
}
```

---
