# Strings & Views

Chemical provides two primary string types in the `std` namespace: `string` (owning, growable) and `string_view` (non-owning reference).

## `std::string`

`std::string` is a high-performance UTF-8 string implementation that uses **Short String Optimization (SSO)**.

### Internal States
A string can be in one of three states:
1. **Constant**: Points to a literal string (e.g., `"hello"`) without copying.
2. **SSO**: Small strings (up to 15 characters) are stored directly inside the struct.
3. **Heap**: Larger strings are allocated on the heap.

### Construction
```ch
import std

var s1 = std::string("Literal")    // Constant state initially
var s2 = std::string('a')          // SSO state
var s3 = std::string(other_view)   // Copies data from a view
```

### Manipulation API

#### Appending
Chemical provides specialized append functions for efficiency.
- `append(char)`: Appends a single character.
- `append_view(view)`: Appends a `string_view` or literal string.
- `append_integer(long)` / `append_uinteger(ulong)`: Converts and appends an integer.
- `append_double(double, precision)`: Appends a formatted floating-point number.

```ch
var s = std::string("Value: ")
s.append_integer(42)
s.append_view("!") // "Value: 42!"
```

#### Other Mutations
- `clear()`: Efficiently resets the string to empty.
- `erase(start, len)`: Removes a range of characters.
- `reserve(capacity)`: Pre-allocates memory.
- `set(index, char)`: Modifies a character at a specific index.

### Inspection
- `size()`: Returns current length.
- `empty()`: Returns true if size is 0.
- `find(view)`: Returns the index of the first occurrence of a substring, or `NPOS` if not found.
- `contains(view)`: Quick check for substring existence.
- `ends_with(view)`: Checks if the string ends with a specific suffix.

---

## `std::string_view`

A `string_view` is a lightweight object that points to an existing character buffer. It does not own the memory.

### Implicit Construction
Literals are implicitly convertible to `string_view`, making it the ideal type for function parameters.

```ch
func process(name : std::string_view) {
    printf("Processing %s\n", name.data())
}

process("Alice") // Implicit conversion works!
```

### Key Functions
- `subview(start, end)`: Returns a new view into a portion of the original data.
- `skip(count)`: Returns a new view starting after the first `count` characters.
- `data()`: Returns the raw `*char` pointer.
- `size()`: Returns the length.

> [!CAUTION]
> Always ensure the underlying data for a `string_view` outlives the view itself.
