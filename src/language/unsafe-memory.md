# Unsafe Memory

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

In Chemical, when you use & operator on a value, you take a pointer (not a reference), that's because references
are taken implicitly in chemical. If the type is a reference, you just need to pass a l-value.

### Taking Addresses

```ch
var i = 2
var j = &raw mut i    // Mutable pointer to i
*j = *j + 1       // Modify through reference
// i is now 3
```

### Double Dereference

```ch
var i = 123
var j = &raw i
var k = &raw j
**k == 123  // Dereference twice to get original value
```

### Address of Dereference

```ch
var i = 234
var k = *&raw i    // Dereference immediately after taking address
// k == 234
```

### Pointer Notation

```ch
var i = 345
var j = &raw i
var k = &raw *j    // Address of dereferenced value
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
var ptr = &raw arr[0]

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
var ptr1 = &raw arr[0] + 2    // Points to arr[2]
var ptr2 = &raw arr[0]        // Points to arr[0]
var diff = ptr1 - ptr2    // 2
```

### Pointer Comparison

Compare pointers to determine relative positions:

```ch
var arr = [10, 20, 30, 40, 50]
var ptr1 = &raw arr[0] + 2
var ptr2 = &raw arr[0]

ptr1 > ptr2   // true
ptr2 < ptr1   // true
ptr1 == ptr2  // false

var ptr3 = &raw arr[0] + 2
ptr1 == ptr3  // true (same address)
```

### Index Operator on Pointers

Access memory like an array through pointers:

```ch
var arr = [10, 20, 30]
var ptr = &raw arr[0]
ptr[0]   // 10
ptr[1]   // 20
ptr[2]   // 30
```

### Pointer Access After Arithmetic

Access struct members after pointer arithmetic:

```ch
struct Point { var a : int; var b : int }

var p = Point { a : 22, b : 33 }
const j = &raw p
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

Use these built-in macros to get memory characteristics of any type. They return a `ubigint` or `u64`.

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
// dealloc only calls free, you can also use delete
dealloc x

// Works with const too
const x = new int
*x = 13
// int does not have a destructor, so delete only performs free
delete x
```

### `new` - Pointer Types

```ch
var x = new *int
var y = 13
*x = &raw y
const ptr = *x
*ptr == 13
delete x
```

### `new` - With Struct Types

```ch
// Allocate without initialization (zero-initialized)
var x = new MyStruct
x.a = 234
x.b = 111
delete x

// Allocate with initialization
var x = new MyStruct { a : 10, b : 20 }
delete x

// Allocate with constructor call
var x = new Player("Antigravity")
delete x
```

### `new` - Namespaced Types

```ch
var x = new namespace::MyStruct
x.a = 821
x.b = 2834
delete x
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

// destruct + free
delete ptr
```

### Placement `new` with Constructor

```ch
var ptr = malloc(sizeof(Player)) as *mut Player
new (ptr) Player("Alice")
ptr.name == "Alice"
// destruct + free
delete ptr
```

### Placement `new` Without Variable

```ch
var ptr = malloc(sizeof(MyStruct)) as *mut MyStruct
new (ptr) MyStruct { a : 12, b : 43 }
ptr.a == 12  // Access directly through ptr
// destruct + delete
delete ptr
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

// destruct + free
delete ptr
```

### Reusing memory using placement `new`

`destruct` and then `placement new` can be used to re-initialize a pointer to a struct. It allows reusing already
allocated memory, instead of using `malloc` or `new` to allocate again.

```ch
var ptr = malloc(sizeof(MyStruct)) as *mut MyStruct
new (ptr) MyStruct { a : 12, b : 43 }

// destruct MyStruct, without calling free
destruct ptr;

// reinitialize the `ptr`
new (ptr) MyStruct { a : 10, b : 98 }

// finally destruct + delete
delete ptr;
```

## Deallocation

- `dealloc ptr`: Frees memory allocated, only frees memory
- `destruct ptr`: Calls the destructor for a struct (does not free the memory)
- `delete ptr` : Calls the destructor and then frees the memory

```ch
var x = new int
dealloc x

// For structs with destructors
var p = new Player("Alex")
delete p  // Calls Player's destructor and then free

// warning: if you use dealloc with p, destructor won't be called
// warning: if you use destruct with p, free won't be called
```
