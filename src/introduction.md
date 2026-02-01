# Introduction

Chemical is a high-performance, statically typed systems programming language designed for modern developers who value both local systems performance and web-scale interoperability.

It combines the strictness and power of C/C++ with a cleaner, more readable syntax, and incorporates an "Astro-like" web development model directly into the language core.

## Key Philosophies

- **No Magic**: Chemical avoids background magic. For example, string concatenation or memory allocation is explicit, giving you full control over performance.
- **Modern Syntax**: A clean, expression-oriented syntax that reduces boilerplate.
- **Seamless Interoperability**: Chemical translates directly to C, allowing it to leverage the entire ecosystem of C libraries without complex bindings.
- **Web-First Systems Language**: Unlike other systems languages, Chemical treats HTML, CSS, and JS as first-class citizens through its Component-Based Interface (CBI) system.

## In This Documentation

This book is organized to take you from a curious beginner to a Chemical expert:

1.  **[Getting Started](getting_started.md)**: Install the compiler and build your first program.
2.  **[Language Guide](language/basics.md)**: Explore the core syntax, type system, and memory management.
3.  **[Web Development](web/overview.md)**: Learn how to build websites using static HTML and interactive components (React, Solid).
4.  **[Build System](build/lab.md)**: Master the `lab` build engine and `chemical.mod` configuration.
5.  **[Standard Library](stdlib/std.md)**: Discover the built-in tools for strings, vectors, maps, and more.

## Quick Look

```ch
public func main() : int {
    var message = "Hello, Chemical!"
    printf("%s\n", message)
    return 0
}
```

Ready to dive in? Let's get started!