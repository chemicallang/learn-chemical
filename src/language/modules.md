# Modules & Namespaces

Organizing large projects is easy in Chemical using namespaces and a simple module system.

## Namespaces

Namespaces prevent name collisions by grouping related types and functions.

### Declaring a Namespace
```ch
namespace Math {
    public func add(a : int, b : int) : int { return a + b }
}
```

### Accessing Symbols
Use the `::` operator to access members of a namespace.

```ch
var result = Math::add(5, 5)
```

### Extending Namespaces
You can open the same namespace in multiple files or blocks to add more functionality.

## The `using` Keyword

Tired of typing `Math::`? Use `using` to bring symbols into the current scope.

- **Single symbol**: `using Math::add;`
- **Entire namespace**: `using namespace Math;`

```ch
using namespace Math
var result = add(10, 10) // No Math:: needed!
```

## Modules

A **Module** is a collection of Chemical source files described by a `chemical.mod` file.

### How Visibility Works
- Symbols marked `public` are visible to other modules that `import` yours.
- Everything inside a module is visible to all files *within* that same module—no includes needed!

### `chemical.mod` example
```chmod
module my_lib
source "src"
import other_lib
```

### Importing in Source Files
In Chemical, you **do not** write `import` at the top of `.ch` files. Instead, you declare dependencies once in `chemical.mod`. Every file in your project can immediately see symbols from the imported modules.

---

Next: **[Advanced Features](advanced.md)**
