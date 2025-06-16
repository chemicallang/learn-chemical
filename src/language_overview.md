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

These types form the foundation for more complex data structures and interop with C via `cstd`.

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

### Extension Methods

Add methods after the struct definition:

```ch
func (p: &Point) div(): int {
    return p.x / p.y
}
```

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
        Optional.Some(value) => { printf("%d", value) }
        Optional.None        => { /* nothing */ }
    }
}

func is_this_some(opt: Optional): bool {
    return opt is Optional.Some
}
```

---

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

## Unsafe Blocks

By default, Chemical enforces safety checks. To perform unchecked or low‑level operations, wrap code in `unsafe`:

```ch
unsafe {
    var value = *ptr    // raw pointer dereference
}
```

The compiler will emit an error if you attempt pointer dereference or other unsafe ops outside of an `unsafe` block.


---