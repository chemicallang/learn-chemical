# Namespaces

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

But you must keep the same access specifier

```ch
public namespace Math {}

// ❌ error: namespace Math's access specifier must match with existing namespace
namespace Math {}
```

## The `using` Keyword

Tired of typing `Math::`? Use `using` to bring symbols into the current scope.

- **Single symbol**: `using Math::add;`
- **Entire namespace**: `using namespace Math;`

```ch
using namespace Math
var result = add(10, 10) // No Math:: needed!
```