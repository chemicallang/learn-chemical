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