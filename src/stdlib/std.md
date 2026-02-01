# std: Core API Reference

The `std` module provides the foundational building blocks of the Chemical language. It is optimized for high performance and low memory overhead.

## Containers

### `std::vector<T>`
A contiguous, dynamic array.

**Key Methods:**
- `push_back(value)` / `push(value)`: Appends an element, growing the buffer if necessary.
- `pop_back()`: Removes the last element and calls its destructor.
- `get(index)`: Returns the element at the specified index.
- `get_ptr(index)` / `get_ref(index)`: Returns a pointer/reference to the element.
- `reserve(capacity)`: Pre-allocates memory to avoid repeated reallocations.
- `clear()`: Removes all elements and calls their destructors.
- `erase(index)`: Removes an element and shifts subsequent elements.
- `size()`: Returns the number of elements.

### `std::unordered_map<K, V>`
A hash map implemented with a load-factored array of buckets and linked-list chains.

**Key Methods:**
- `insert(key, value)`: Inserts or updates a key-value pair.
- `get_ptr(key)`: Returns a pointer to the value, or `null` if not found.
- `contains(key)`: Returns `true` if the key exists.
- `erase(key)`: Removes the pair and returns `true` if it existed.
- `iterator()`: Returns an iterator for manual traversal.

### `std::string` & `std::string_view`
- **`string`**: Owning, growable UTF-8 string with SSO (Short String Optimization).
- **`string_view`**: Non-owning reference to a character buffer.

## Specialized Strings

### `std::os_string`
Wraps platform-native strings (e.g., `wchar_t` on Windows, `char` on Linux). Essential for interacting with the operating system's file system and environment variables.

### `std::u16_string`
A specialized string for UTF-16 data, common in Windows APIs and some networking protocols.

## The Stream System

Chemical uses a powerful interface-based `Stream` system for input and output.

```ch
public interface Stream {
    func writeStr(&self, value : *char, length : ubigint);
    func writeInt(&self, value : int);
    // ... handles all primitive types
}
```

### Global Print Functions
The `std` module provides `print` and `println` which use a `CommandLineStream` by default. These support **interpolation** for any type that implements a corresponding write method.

```ch
import std

var x = 42
std.println("The value is ${x}"); // Automatic interpolation
```

## Error Handling

### `std::Option<T>` & `std::Result<T, E>`
These are variants used for safe value propagation without nulls or exceptions.

```ch
// Result unwrapping
var val = risk_call() else return err
```

## System & Diagnostics

### `std::panic(message : *char)`
Halts execution immediately. Chemical's panic is **location-aware**; it automatically captures and prints the file, line, and character where the panic was called.

```ch
std::panic("Critical Failure!"); 
// Output: panic with message 'Critical Failure!' at 'src/main.ch:12:5'
```

### Memory Management
- `std::malloc` / `std::free`: Bare-metal heap allocation (C-interop).
- `dealloc`: A keyword/intrinsic for safe, typed deallocation.

---

Next: **[concurrency: Multi-threading](concurrency.md)**
