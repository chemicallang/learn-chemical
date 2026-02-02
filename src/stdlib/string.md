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

#### Appending Characters

Append a single character to the string:

```ch
var s = std::string("Hello")
s.append('!')  // "Hello!"
s.append('!')  // "Hello!!"
```

#### Appending Views and Strings

Append string views or string literals using `append_view`:

```ch
var s = std::string("Hello")
s.append_view(" World")                    // Direct literal
s.append_view(std::string_view("!!!"))     // From string_view
```

> [!IMPORTANT]
> Chemical does NOT support string concatenation with `+`. Always use `append` or `append_view` instead.

```ch
// WRONG - will not compile
var s = "Hello" + " World"

// CORRECT
var s = std::string("Hello")
s.append_view(" World")
```

#### Appending Numbers

Convert and append numeric values:

```ch
var s = std::string("Value: ")
s.append_integer(42)        // "Value: 42"
s.append_uinteger(100u)     // "Value: 42100"
```

#### Appending Floating Point

Append formatted floating-point numbers with precision control:

```ch
var s = std::string("Pi: ")
s.append_double(3.14159, 2)  // "Pi: 3.14" (2 decimal places)
```

#### Other Mutations

- `clear()`: Efficiently resets the string to empty.
- `erase(start, len)`: Removes a range of characters.
- `reserve(capacity)`: Pre-allocates memory.
- `set(index, char)`: Modifies a character at a specific index.

```ch
var s = std::string("Hello World")
s.erase(5, 6)   // "Hello"
s.set(0, 'J')   // "Jello"
s.clear()       // ""
```

### Inspection

- `size()`: Returns current length.
- `empty()`: Returns true if size is 0.
- `find(view)`: Returns the index of the first occurrence of a substring, or `NPOS` if not found.
- `contains(view)`: Quick check for substring existence.
- `ends_with(view)`: Checks if the string ends with a specific suffix.
- `c_str()`: Returns a null-terminated `*char` pointer.

```ch
var s = std::string("Hello World")
s.size()              // 11
s.empty()             // false
s.find("World")       // 6
s.contains("Hello")   // true
s.ends_with("World")  // true
```

---

## `std::string_view`

A `string_view` is a lightweight object that points to an existing character buffer. It does not own the memory.

### Implicit Construction
Literals are implicitly convertible to `string_view`, making it the ideal type for function parameters.

```ch
func process(name : std::string_view) {
    printf("Processing %s\n", name.data())
}

process("Alice")  // Implicit conversion works!
```

### Key Functions

- `subview(start, end)`: Returns a new view into a portion of the original data.
- `skip(count)`: Returns a new view starting after the first `count` characters.
- `data()`: Returns the raw `*char` pointer.
- `size()`: Returns the length.

```ch
var view = std::string_view("Hello World")
var hello = view.subview(0, 5)    // "Hello"
var world = view.skip(6)          // "World"

view.data()                        // Raw pointer
view.size()                        // 11
```

### Comparison

Use `equals()` for string comparison:

```ch
var a = std::string_view("hello")
var b = std::string_view("hello")
var c = std::string_view("world")

a.equals(b)  // true
a.equals(c)  // false
```

> [!CAUTION]
> Always ensure the underlying data for a `string_view` outlives the view itself.

---

## Character Strings (`*char`)

Raw character pointers work like C strings:

```ch
var str = "hello"
str[0] == 'h'
str[4] == 'o'
str[5] == '\0'  // Null terminator
```

### Multiline Strings

Use triple quotes for multiline strings:

```ch
var multi = """First line
Second line
Third line"""
strlen(multi)  // Includes newline characters
```

### String Arrays

Strings can be stored in character arrays:

```ch
var str : []char = "hello"
str[0] == 'h'
str[5] == '\0'

// Fixed-size arrays are zero-padded
var str2 : [10]char = "hello"
str2[5] == '\0'
str2[9] == '\0'
```

### Escape Characters

```ch
var escaped = "\n\t\"\\'"
// Contains: newline, tab, quote, backslash, single quote
```

