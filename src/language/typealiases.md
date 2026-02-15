# Type Aliases

Use the `type` keyword to create a new name for an existing type.

### Basic Aliases

```ch
type ID = bigint
type Callback = (int) => void

var user_id : ID = 1000
```

### Function Type Aliases

Simplify complex function types:

```ch
type SimpleFunc = () => int
type HandlerFunc = (event : *Event) => void

func take_simple_func(simple : SimpleFunc) : int {
    return simple()
}

take_simple_func(() => 674)  // Returns 674
```

### Conditional Type Aliases

Create types that change based on compile-time conditions:

```ch
comptime const is_32bit = true

type PlatformInt = if(is_32bit) u32 else u64

// sizeof(PlatformInt) is 4 when is_32bit is true
```

### Local Type Aliases

Type aliases can be defined inside functions:

```ch
func process() {
    const use_32 = true
    type LocalType = if(use_32) u32 else u64
    
    var x : LocalType = 100
}
```