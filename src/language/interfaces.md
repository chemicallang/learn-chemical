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

## Static Interfaces (`@static`)

Static interfaces are resolved at compile time. They behave like C++ templates or Rust's static dispatch, but the syntax is streamlined. When you use an interface in an extension function or as a generic constraint, the compiler optimizes away the virtual dispatch.

```ch
@static
interface Adder {
    func add(&self, other : int) : int
}

func do_add(obj : &Adder, val : int) : int {
    return obj.add(val)
}
```

## Dynamic Dispatch (`dyn`)

When you need to store different types that implement the same interface in a single list or pass them around without knowing their exact type at compile time, you use **Dynamic Dispatch**.

Use the `dyn` keyword to create a **fat pointer**. A `dyn Interface` consists of:
1. A pointer to the object instance.
2. A pointer to the vtable (the interface implementation).

```ch
var r = Robot { id : 1 }
var s : dyn Speaker = dyn<Speaker>(r)

s.say_hi() // Dynamic dispatch via vtable
```

### Safety & Lifetimes
Dynamic interface pointers (`dyn`) are powerful but require care. If the underlying object is deallocated or goes out of scope while a `dyn` pointer still exists, calling methods on it will result in a crash or undefined behavior.

```ch
var s : dyn Speaker
{
    var r = Robot { id : 99 }
    s = dyn<Speaker>(r)
}
// s.say_hi() // WARNING: Dangerous! r has been destroyed.
```

## Multiple Interface Implementation

A single struct can implement as many interfaces as needed.

```ch
struct MultiTool {}

impl Speaker for MultiTool { ... }
impl Printable for MultiTool { ... }
```
