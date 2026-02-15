# Markdown Integration

Chemical lets you write content using Markdown directly inside your source files using the `#md` macro. This is extremely useful for blogs, documentation, or any text-heavy sections.

## Using `#md`

Everything inside the `#md` block is converted to valid HTML at compile time. One difference in md is that it doesn't use
braces, because that would conflict with its content, so we went with C preprocessor like approach.

```ch
#md

    # This is a Header
    
    You can use **bold**, *italic*, or [links](https://chemical-lang.org).
    
    - List items
    - Work as expected
    
    ```ch
    // Code blocks are also supported!
    func hello() { printf("hi"); }
    ```

#endmd
```

## Interpolation in Markdown

you can use `${}` to inject Chemical values into your Markdown content before it is converted to HTML.

```ch
var current_version = "1.2.3"

#md

The current version of our library is **${current_version}**.

#endmd
```

To use `#md`, you typically need the `md_cbi` module in your project. It handles the transformation from Markdown syntax to HTML tags.

---