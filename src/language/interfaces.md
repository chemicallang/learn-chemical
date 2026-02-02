# Interfaces & Dynamic Dispatch

Interfaces define a set of methods that a type must implement. Chemical supports two forms of interface usage: **Static** and **Dynamic**.

## Interface Definition

Any struct or variant can implement an interface by defining the required methods.

```ch
interface Speaker {
    func say_hi(&self)
}

struct Robot {
    var id : int
}

// Implementing the interface
impl Speaker for Robot {
    func say_hi(&self) {
        printf("Beep boop, I am Robot %d\n", self.id)
    }
}
```

## Implementation Patterns

### Using `impl` Blocks

The most common way to implement an interface:

```ch
impl Speaker for Robot {
    func say_hi(&self) {
        printf("Hello from Robot %d\n", self.id)
    }
}
```

### Inline Implementation

You can also implement interfaces directly when defining a struct using the `:` syntax:

```ch
struct Dog : Speaker {
    var name : *char
    
    @override
    func say_hi(&self) {
        printf("Woof! I'm %s\n", name)
    }
}
```

### Implementation Before Declaration

Chemical allows using interfaces before their full declaration (forward declaration is automatic):

```ch
impl SomeInterface for MyStruct {
    // Implementation
}

// Interface can be declared later in the file
interface SomeInterface {
    func method(&self)
}
```

## Static Interfaces (`@static`)

Static interfaces are resolved at compile time. They behave like C function declarations, but with the benefit of type safety. When you use a static interface, the compiler optimizes away any virtual dispatch.

### When to Use Static Interfaces

- **Library Authors**: Declare expected functions that consumers must implement
- **C Interoperability**: Define callbacks or plugin interfaces
- **Zero Overhead**: When you need interface-like behavior without runtime cost

```ch
@static
interface Adder {
    func add(&self, other : int) : int
}

struct Number : Adder {
    var value : int
    
    @override
    func add(&self, other : int) : int {
        return value + other
    }
}
```

### Static Interface Usage

Static interface methods are called directly without virtual dispatch:

```ch
func do_add(obj : &Adder, val : int) : int {
    return obj.add(val)  // Direct call, no vtable lookup
}
```

### Extension Functions on Static Interfaces

You can add extension functions to static interfaces:

```ch
@static
interface Summer {
    func sum(&self) : int
}

// Extension function accessible by any type implementing Summer
func (s : &Summer) triple_sum() : int {
    return s.sum() * 3
}
```

### Multi-Module Static Interfaces

Static interfaces work across module boundaries:

```ch
// In library module
@static 
public interface Logger {
    func log(&self, msg : *char)
}

// In consumer module
struct FileLogger : Logger {
    @override
    func log(&self, msg : *char) {
        // Write to file
    }
}
```

## Dynamic Dispatch (`dyn`)

When you need to store different types that implement the same interface in a single list or pass them around without knowing their exact type at compile time, you use **Dynamic Dispatch**.

### Creating Dynamic Objects

Use the `dyn` keyword to create a **fat pointer**:

```ch
var r = Robot { id : 1 }
var s : dyn Speaker = dyn<Speaker>(r)

s.say_hi()  // Dynamic dispatch via vtable
```

### Fat Pointer Layout

A `dyn Interface` type is a fat pointer consisting of:
1. A pointer to the object instance
2. A pointer to the vtable (the interface implementation)

This is essentially `16 bytes` on 64-bit systems (two pointers).

### Using Dynamic Objects in Functions

```ch
func make_speak(speaker : dyn Speaker) {
    speaker.say_hi()
}

var robot = Robot { id : 42 }
make_speak(dyn<Speaker>(robot))
```

### Dynamic Objects as Return Values

```ch
func create_speaker(robot_mode : bool) : dyn Speaker {
    if (robot_mode) {
        return dyn<Speaker>(Robot { id : 1 })
    } else {
        return dyn<Speaker>(Dog { name : "Buddy" })
    }
}
```

### Dynamic Objects in Structs

```ch
struct SpeakerContainer {
    var speaker : dyn Speaker
}

var container = SpeakerContainer {
    speaker : dyn<Speaker>(Robot { id : 10 })
}
container.speaker.say_hi()
```

### Arrays of Dynamic Objects

```ch
var speakers : []dyn Speaker = [
    dyn<Speaker>(Robot { id : 1 }),
    dyn<Speaker>(Dog { name : "Rex" }),
    dyn<Speaker>(Robot { id : 2 })
]

for (var i = 0; i < 3; i++) {
    speakers[i].say_hi()
}
```

### Safety & Lifetimes

> [!CAUTION]
> Dynamic interface pointers (`dyn`) are powerful but require care. If the underlying object is deallocated or goes out of scope while a `dyn` pointer still exists, calling methods on it will result in a **crash or undefined behavior**.

```ch
var s : dyn Speaker
{
    var r = Robot { id : 99 }
    s = dyn<Speaker>(r)
}
// s.say_hi() // DANGEROUS! r has been destroyed.
```

> [!WARNING]
> The Chemical compiler is currently in **pre-alpha**. There is **no lifetime checking** to prevent dangling `dyn` references. You must manually ensure object lifetime exceeds the lifetime of any `dyn` pointers.

**Safe Pattern**: Allocate on the heap to extend lifetime:

```ch
unsafe {
    var robot_ptr = new Robot { id : 100 }
    var speaker : dyn Speaker = dyn<Speaker>(*robot_ptr)
    
    // Use speaker...
    speaker.say_hi()
    
    // Clean up when done
    dealloc robot_ptr
}
```

## Multiple Interface Implementation

A single struct can implement as many interfaces as needed:

```ch
interface Printable {
    func print(&self)
}

interface Serializable {
    func serialize(&self) : *char
}

struct MultiTool {
    var data : int
}

impl Speaker for MultiTool {
    func say_hi(&self) {
        printf("Hi from MultiTool\n")
    }
}

impl Printable for MultiTool {
    func print(&self) {
        printf("MultiTool: %d\n", data)
    }
}
```

## Interface with Inheritance

When a struct inherits from another struct, it can implement different interfaces at each level:

```ch
struct Animal {
    var age : int
}

impl Speaker for Animal {
    func say_hi(&self) {
        printf("Animal sound\n")
    }
}

struct Dog : Animal {
    var name : *char
}

// Dog inherits Speaker implementation from Animal
// But can also implement additional interfaces
impl Printable for Dog {
    func print(&self) {
        printf("Dog: %s, age %d\n", name, age)
    }
}
```

