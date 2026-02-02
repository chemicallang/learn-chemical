# Generics

Chemical provides a powerful generics system that allows you to write reusable, type-safe code. Generics can be applied to functions, structs, variants, and interfaces.

## Basic Syntax

Generic parameters are specified within angle brackets `< >` before the function name or after the type name.

```ch
func <T> identity(value : T) : T {
    return value
}

struct Box<T> {
    var item : T
}

var int_box = Box<int> { item : 42 }
```

## Default Type Parameters

You can provide default values for generic type parameters.

```ch
// R defaults to int if not specified
func <T, R = int> convert(value : T) : R {
    return value as R
}
```

## Generic Dispatch & Constraints

You can constrain a generic type to only those that implement a specific interface.

```ch
interface Printable {
    func print(&self)
}

func <T : Printable> print_item(item : &T) {
    item.print()
}
```

## Conditional Compilation with `is`

The `if (T is Type)` construct allows the compiler to choose different code paths based on the concrete type provided for a generic parameter. This is similar to C++ `if constexpr`.

```ch
func <T> get_type_size() : int {
    if (T is short) {
        return 2
    } else if (T is int) {
        return 4
    } else {
        return sizeof(T) as int
    }
}
```

## Generic Variants

Generics are essential for creating flexible data structures like `Option` or `Result`.

```ch
variant Optional<T> {
    Some(value : T)
    None()
}

var opt = Optional.Some<int>(10)
```
