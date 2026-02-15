# Web Development Overview

Chemical takes a unique plugin approach to web development. It acts as a bridge between high-performance systems code and modern web frontends.

## Compiler Plugins

The compiler allows hooking into its lexing, parsing and code generation phases using compiler plugins

Instead of treating HTML or JS as strings, Chemical understands them at compile time using compiler plugins.

## The Astro-like Model

Chemical operates similarly to the [Astro framework](https://astro.build/):
1.  **Static by Default**: Most of your page is generated as static HTML for maximum speed.
2.  **Interactive Islands**: You can "hydrate" specific components using React, Solid, or Preact only where interaction is needed.
3.  **Single File Synergy**: You write your logic, styles, and structure in the same `.ch` files.

## The `HtmlPage` Struct

The core of web building in Chemical is the `HtmlPage` struct (found in the `page` module). It stores the state of a single web page.

```ch
func create_my_site() {
    var p = HtmlPage()
    p.defaultPrepare() // sets viewport, charset, etc.
    p.appendTitle("My Chemical App")
    
    // Logic to add content to p...
    
    p.writeToDirectory("out", "index") // generates out/index.html, index.css, etc.
}
```

## Available Macros

Macros in Chemical are categorized by their placement and scope.

### Top-Level Macros (File Scope)
These are used to define reusable components. They must be defined at the top level of a `.ch` file.
- **`#react`, `#solid`, `#preact`**: Define framework components.

### Local Macros (Function Scope)
These are used inside functions to generate content dynamically. They typically require a `page : &mut HtmlPage` to be present in the local scope.
- **`#html { ... }`**: For static HTML structure.
- **`#css { ... }`**: For styling (can return a class name).
- **`#js { ... }`**: For raw client-side JavaScript.
- **`#md { ... }`**: For embedding Markdown directly (converted to html).

> [!IMPORTANT]
> To use these macros, you must import the corresponding module (e.g., `import html_cbi`) in your `chemical.mod` file.

---
