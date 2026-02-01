# CBI Macros & Scopes

Chemical uses **Component-Based Interface (CBI)** macros to bridge systems programming and web development. To use these macros, you must first configure your project dependencies and understand where each macro can be placed.

## Configuration

Before using any macro, you must import the corresponding CBI module in your `chemical.mod` file. These modules provide the bridge logic for the compiler to process the special `#` blocks.

```ch
# chemical.mod
module my_website

source "src"
import html_cbi   # Required for #html, #css, #js
import react_cbi  # Required for #react
import solid_cbi  # Required for #solid
```

## Macro Scopes

Macros in Chemical are categorized into **Top-Level** and **Local** macros.

### Top-Level Macros

These are defined at the **file scope** (outside of any function). They are primarily used to define independent components.

- **`#react`**: Defines a React component.
- **`#solid`**: Defines a SolidJS component.
- **`#preact`**: Defines a Preact component.

```ch
#react MyButton(label : *char) {
    return <button className="btn">{label}</button>
}
```

### Local Macros

These are used **inside functions** or as **values**. They require a `page` variable of type `&mut HtmlPage` to be available in the local scope, as the compiler automatically calls `.append(...)` methods on it.

- **`#html`**: Appends HTML content to the page.
- **`#css`**: Appends CSS and returns a unique class name as a `*char`.
- **`#js`**: Appends client-side JavaScript.
- **`#md`**: Converts Markdown to HTML and appends it.

```ch
public func render_page(p : &mut HtmlPage) {
    var page = p
    
    var my_class = #css {
        color: blue;
        padding: 10px;
    }
    
    #html {
        <div class="${my_class}">
            <h1>Hello World</h1>
        </div>
    }
}
```

> [!NOTE]
> String literals in Chemical are `*char`. You can pass them directly to `printf` or CBI macros without calling `.data()`.

## Passing Values

You can interpolate Chemical values into any CBI block using the `${expression}` syntax.

```ch
var count = 5
#html {
    <p>The count is: ${count}</p>
}
```

---

Next: **[HTML, CSS & JavaScript](html_css_js.md)**
