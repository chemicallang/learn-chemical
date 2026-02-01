# Generics

In this chapter we explore generics in chemical

Generics are unstable feature of the compiler, Generics are a little unsafe (at runtime)

## Generic Functions

The generics in chemical are a little like templates in C++ at the moment

```ch
func <T> print(a : T, b : T) {
    printf("%d, %d", a, b);
}
```

Yes, you can do generic dispatch

```ch
func <T : Dispatch> call() {
    T::method()
}
```

You can also do conditional compilation

```ch
func <T> size() : T {
    if (T is short) {
        return 2
    } else if(T is int) {
        return 4
    } else if(T is bigint) {
        return 8
    } else {
        return sizeof(T)
    }
}
```

## Generic Structs

The syntax for generic structs is as follows

```ch
struct Point<T> {
    var a : T
    var b : T
    func print(&self){
        printf("%d, %d", a, b);
    }
}

func usage() {
    var p = Point<int> { a : 10, b : 20 }
    p.print()
}
```

## Generic Variants

Generic variants are similar to generic structs

```ch
variant Optional<T> {
    Some(value : T)
    None()
}

func usage() {
    var opt = Optional.Some<int>(10)
    var Some(value) = opt else -1
    printf("%d", value)
}
```