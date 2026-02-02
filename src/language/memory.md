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

### Taking Addresses

```ch
var i = 2
var j = &mut i    // Mutable reference
*j = *j + 1       // Modify through reference
// i is now 3
```

### Double Dereference

```ch
var i = 123
var j = &i
var k = &j
**k == 123  // Dereference twice to get original value
```

### Address of Dereference

```ch
var i = 234
var k = *&i    // Dereference immediately after taking address
// k == 234
```

### Pointer Notation

```ch
var i = 345
var j = &i
var k = &*j    // Address of dereferenced value
// *k == 345
```

#### Pointer Arithmetic
Chemical supports standard pointer arithmetic within `unsafe` blocks.

**Basic Operations:**
- `ptr + n` / `ptr - n`: Offset the pointer by N elements.
- `ptr1 - ptr2`: Calculate the distance between two pointers of the same type.
- `ptr++` / `ptr--`: Increment or decrement the pointer by one element.
- `ptr[index]`: Array-style access via pointers.

```ch
var arr = [10, 20, 30, 40, 50]
var ptr = &arr[0]

*ptr       // 10
ptr++      // Move to next element
*ptr       // 20
ptr++
*ptr       // 30
ptr--      // Move back
*ptr       // 20
```

### Pointer Subtraction

Calculate the distance between two pointers:

```ch
var arr = [10, 20, 30, 40, 50]
var ptr1 = &arr[0] + 2    // Points to arr[2]
var ptr2 = &arr[0]        // Points to arr[0]
var diff = ptr1 - ptr2    // 2
```

### Pointer Comparison

Compare pointers to determine relative positions:

```ch
var arr = [10, 20, 30, 40, 50]
var ptr1 = &arr[0] + 2
var ptr2 = &arr[0]

ptr1 > ptr2   // true
ptr2 < ptr1   // true
ptr1 == ptr2  // false

var ptr3 = &arr[0] + 2
ptr1 == ptr3  // true (same address)
```

### Index Operator on Pointers

Access memory like an array through pointers:

```ch
var arr = [10, 20, 30]
var ptr = &arr[0]
ptr[0]   // 10
ptr[1]   // 20
ptr[2]   // 30
```

### Pointer Access After Arithmetic

Access struct members after pointer arithmetic:

```ch
struct Point { var a : int; var b : int }

var p = Point { a : 22, b : 33 }
const j = &p
const k = j + 1
const d = k - 1
d.a == 22 && d.b == 33  // true
```

### Dereferencing Function Return Values

Directly dereference and assign to pointers returned from functions:

```ch
func ret_ptr(ptr : *mut int) : *mut int {
    return ptr
}

var i = 20
*ret_ptr(&mut i) = 30
// i is now 30
```

## Type Reflection: `sizeof` and `alignof`

Use these built-in macros to get memory characteristics of any type. They return a `ubigint`.

### Basic Usage

- `sizeof(T)`: Returns the size of type `T` in bytes.
- `alignof(T)`: Returns the alignment requirement of type `T`.

```ch
var size = sizeof(int)    // 4
var align = alignof(long) // 4 or 8 depending on platform
```

### Platform-Specific Sizes

```ch
comptime if(def.is64Bit) {
    comptime if(def.windows) {
        sizeof(long) == 4  // Windows 64-bit: long is still 4 bytes
    } else {
        sizeof(long) == 8  // Linux/Mac 64-bit: long is 8 bytes
    }
}
```

### Struct Sizes

```ch
struct MyStruct {
    var a : int
    var b : int
    var c : int
}

sizeof(MyStruct)   // 12 (3 * 4 bytes)
alignof(MyStruct)  // 4 (aligned to int)
```

### Array Sizes

```ch
sizeof([4]int)       // 16 (4 * 4 bytes)
sizeof([4]MyStruct)  // 48 (4 * 12 bytes)
```

### Reference Sizes

References return the size/alignment of the underlying type, not the pointer:

```ch
sizeof(&char)    == sizeof(char)
sizeof(&int)     == sizeof(int)
sizeof(&MyStruct) == sizeof(MyStruct)

alignof(&int)    == alignof(int)
```

### Use in Comptime Functions

```ch
comptime func <T> comptime_size_of() : ubigint {
    return sizeof(T)
}

comptime func <T> comptime_align_of() : ubigint {
    return alignof(T)
}

// Works with generics
comptime_size_of<int>()  // 4
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

### `new` - Basic Allocation

```ch
// Allocate memory for a type
var x = new int
*x = 13
dealloc x

// Works with const too
const x = new int
*x = 13
dealloc x
```

### `new` - Pointer Types

```ch
var x = new *int
var y = 13
*x = &y
const ptr = *x
*ptr == 13
dealloc x
```

### `new` - With Struct Types

```ch
// Allocate without initialization (zero-initialized)
var x = new MyStruct
x.a = 234
x.b = 111

// Allocate with initialization
var x = new MyStruct { a : 10, b : 20 }

// Allocate with constructor call
var x = new Player("Antigravity")
```

### `new` - Namespaced Types

```ch
var x = new namespace::MyStruct
x.a = 821
x.b = 2834
```

### Placement `new`

Construct an object at a specific memory address without allocating new memory:

```ch
// Allocate raw memory
var ptr = malloc(sizeof(MyStruct)) as *mut MyStruct

// Construct at that location
var x = new (ptr) MyStruct { a : 87, b : 33 }

// Use x...
x.a == 87

// Free the raw memory (not the object)
free(ptr)
```

### Placement `new` with Constructor

```ch
var ptr = malloc(sizeof(Player)) as *mut Player
new (ptr) Player("Alice")
ptr.name == "Alice"
free(ptr)
```

### Placement `new` Without Variable

```ch
var ptr = malloc(sizeof(MyStruct)) as *mut MyStruct
new (ptr) MyStruct { a : 12, b : 43 }
ptr.a == 12  // Access directly through ptr
free(ptr)
```

### Placement `new` with Variants

```ch
variant OptInt {
    Some(value : int)
    None()
}

var ptr = new OptInt
new (ptr) OptInt.Some(763)

var Some(value) = *ptr else return
value == 763

dealloc ptr
```

## Deallocation

- `dealloc ptr`: Frees memory allocated for non-struct types.
- `destruct ptr`: Calls the destructor for a struct and then frees the memory.

```ch
// For simple types
var x = new int
dealloc x

// For structs with destructors
var p = new Player("Antigravity")
destruct p  // Calls Player.@delete then frees memory
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

## Destructor Lifecycle

Understanding when `@delete` is called is critical for managing resources.

### Scope Exit

Destructors are called in reverse order of declaration when a scope ends.

```ch
{
    var a = Resource { ... }
    var b = Resource { ... }
} // b.destroy() called, then a.destroy()
```

### Control Flow: `break`, `continue`, `return`

Chemical ensures destructors are called even when exiting a block prematurely.

```ch
func process() {
    var res = Resource { ... }
    if (error) {
        return // res.destroy() is called before returning
    }
}

loop {
    var res = Resource { ... }
    if (done) {
        break // res.destroy() is called before breaking
    }
}
```

### Moves and Destructors

If an object is **moved** to another variable or passed to a function by value, the original variable is considered "empty" and its destructor will **not** be called.

```ch
func take(res : Resource) { } // res.destroy() called here at end of take()

func example() {
    var a = Resource { ... }
    take(a) // a is MOVED to 'take', a.destroy() will NOT be called in example()
}
```

### Assignment to Movable Types

When you assign a new value to a variable that already holds a movable object, the **previous** object's destructor is called before the assignment happens.

```ch
var a = Resource { name: "First" }
a = Resource { name: "Second" } // a.destroy() ("First") is called here
```


