# Memory & Unsafe

As a systems language, Chemical gives you direct control over memory when needed, while offering safer abstractions for everyday tasks.

## Pointers and References

### References (`&`)
References are safe, non-null pointers managed by the language.
- `&T`: Immutable reference.
- `&mut T`: Mutable reference.

### Pointers (`*`)
Pointers are raw memory addresses, similar to C pointers.
- `*T`: Immutable pointer.
- `*mut T`: Mutable pointer.

```ch
var x = 42
var ref : &int = &x
var ptr : *int = &x
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
- `dealloc ptr`: Frees memory allocated for non-struct types.
- `destruct ptr`: Calls the destructor for a struct and then frees the memory.

```ch
unsafe {
    var p = new Player("Antigravity")
    // ... use p ...
    destruct p
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

Next: **[Modules & Namespaces](modules.md)**
