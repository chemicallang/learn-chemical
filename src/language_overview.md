# Language Overview

Chemical is a native, statically‑typed programming language designed to be safe and easy to use while giving developers low‑level control. If you’re familiar with languages like TypeScript, Rust, or C, many of Chemical’s constructs will feel familiar—but with cleaner syntax and safety‑oriented defaults.

In this chapter, we’ll cover the core syntax and features of Chemical: enums, structs, interfaces, variants, control flow, unsafe blocks, variable declarations, and the built‑in type system.

---

## Variables & Constants

Use `var` for mutable bindings and `const` for immutable:

```ch
var first = 0       // mutable
const second = 1    // immutable
```

Optionally, annotate types with `: Type`:

```ch
var count: int = 42
const name: *char = "Chemical"
```

## Built‑In Types

Chemical provides a range of primitive types:

* **Boolean & Characters**: `bool`, `char`, `uchar`
* **Integers**: `short`, `ushort`, `int`, `uint`, `long`, `ulong`
* **Arbitrary‑Precision**: `bigint`, `ubigint`
* **Floating Point**: `float`, `double`
* **Function Type**: `(a : int, b : int) => int`


Pointers and reference types also exist

* **Pointer Types**: `*int, *mut int`
* **Reference Types**: `&int, &mut int`

These types form the foundation for more complex data structures and interop with C via `cstd`.

## Functions

Functions in chemical start with `func` keyword, Here's a function that computes sum of two integers

```ch
func sum(a : int, b : int) : int {
    return 10;
}
```

Extension methods would be discussed below after structs

Lets now see a generic function

```ch
func <T> print(a : T, b : T) : T {
    return a + b;
}
```

#### Calling function pointers

```ch
func call_it(lambda : () => int) : int {
    return lambda()
}
```

## Null Value

In C++ there's `nullptr` keyword which allows you to quickly check a pointer if it's null, similarly we have `null` keyword

```ch
if(pointer == null) {
    // the pointer is null here
}
```

## Control Flow

Chemical supports a rich set of control constructs:

* **`if` / `else`**

  ```ch
  if (condition) {
      // then‑branch
  } else {
      // else‑branch
  }
  ```

* **`loop`** (infinite)

  ```ch
  loop {
      // runs until `break`
  }
  ```

* **`for`**

  ```ch
  for (var i = 0; i < 10; i++) {
      printf("Iteration %d\n", i)
  }
  ```

* **`while`**

  ```ch
  while (someCondition) {
      // ...
  }
  ```

* **`do while`**

  ```ch
  do {
      // ...
  } while (someCondition)
  ```

* **`switch`**

  ```ch
  switch (thing) {
      1        => { /* … */ }
      2        => { /* … */ }
      3, 4, 5  => { /* … */ }
      default  => { /* … */ }
  }
  ```

---

## Enums

Enumerations (enums) are declared with the `enum` keyword and are fully scoped:

```ch
enum Fruits {
    Mango,
    Banana,
}
````

Access them by qualifying with the enum name:

```ch
let f = Fruits.Mango   // ✅
let g = Mango          // ❌ invalid: must write `Fruits.Mango`
```

---

## Arrays

Array can hold multiple types and provide indexed access, Just use `[]` to create an array

```ch

var arr = [ first_value, second_value ]
var first_value = &arr[0] // pointer to the first value

```

## Structs

Structs hold grouped data and methods. Use `public` to make them visible across modules:

```ch
public struct Point {
    var x: int
    var y: int

    func sum(&self): int {
        return x + y
    }
}
```

Lets create an object of this struct and call sum on it

```ch
var point = Point { x : 10, y : 20 }
var sum = point.sum()
```

You can omit the type when it can be inferred

```ch
func create_point() : Point {
    return { x : 10, y : 20 }
}
```

### Constructors and Destructors

Chemical provides a way to write constructors and destructors for a struct, here the function
that has annotation `@make` is a constructor and function with annotation `@delete` is a destructor

```
struct HeapData {

    var data : *void

    @make
    func make() {
        data = malloc(sizoef(Data))
    }

    @delete
    func delete(&self) {
        free(data)
    }

}
```

### Inheritance

You can use inheritance to build struct definitions

```
struct Animal {}

struct Dog : Animal {}

struct Fish : Animal {}
```

You can inherit a single struct, can implement multiple interfaces

### Extension Methods

Add methods after the struct definition:

```ch
func (p: &Point) div(): int {
    return p.x / p.y
}
```

Extension methods only support reference types that point to a container (struct / variant / static interface)

---

## Interfaces

Define an interface of method signatures:

```ch
interface Printer {
    func print(&self, a: int)
}
```

Implement it in two ways:

### Inline

```ch
struct ImplPrinter : Printer {
    @override
    func print(&self, a: int) {
        printf("Printed: %d", a)
    }
}
```

### `impl` Block

```ch
impl Printer for ImplPrinter {
    func print(&self, a: int) {
        printf("Printed: %d", a)
    }
}
```

### Static Interfaces

interfaces can be made static using `@static` annotation above them, This means interfaces will be implemented
once

```ch
@static
interface Organizer {
    func organize(&self)
}
```

Extension methods are only possible on static interfaces, Normal interfaces cannot support extension methods

## Namespaces

Similar to `c++` namespaces

```ch
public namespace mine {
    
    public var global_variable : int = 0

    public struct Point {
        var x : int
        var y : int
    }

}
```

Access members like this

```ch
func temp() {
    var p = mine::Point { x: 10, y: 10 }
}
```

#### Using statement

You can use the `using` keyword to bring symbols for a namespace into current scope

```ch
using namespace std;
```

or just a single symbol

```ch
using std::string_view
```

---

## Variants & Pattern‑Matching

Variants are tagged unions:

```ch
variant Optional {
    Some(value: int),
    None(),
}
```

Create and return them:

```ch
func create_optional(condition: bool): Optional {
    if (condition) {
        return Optional.Some(10)
    } else {
        return Optional.None()
    }
}
```

Match on them with `switch` (no `case` keyword):

```ch
func check_optional(opt: Optional) {
    switch (opt) {
        Some(value) => { printf("%d", value) }
        None        => { /* nothing */ }
    }
}
```

You can easily check a variant using `is` keyword

```ch
func is_this_some(opt: Optional): bool {
    return opt is Optional.Some
}
```

Members can be extracted easily and safely using this syntax

```ch
func get_value() : int {
    // default value is -1 if its not `Some`
    var Some(value) = opt else -1
    printf("the value is : %d\n", value);
}
```

It supports different else cases

```ch
func print_value() {
    // return early without printing if its not `Some`
    var Some(value) = opt else return;
    printf("the value is : %d\n", value);
}

func get_value() : int {
    // compiler assumes its always `Some`
    var Some(value) = opt else unreachable;
    printf("the value is : %d\n", value);
}
```

---

## Unsafe Blocks

By default, Chemical enforces safety checks. To perform unchecked or low‑level operations, wrap code in `unsafe`:

```ch
unsafe {
    var value = *ptr    // raw pointer dereference
}
```

The compiler will emit an error if you attempt pointer dereference or other unsafe ops outside of an `unsafe` block.


---

## Type statements (typealias)

Type alias allows us to alias a type, Lets see

```ch
type MyInt = int
```

Now you can use MyInt instead of int

```
func check_my_int(i : MyInt) : bool
```