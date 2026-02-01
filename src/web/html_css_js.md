# HTML, CSS & JavaScript

The basic building blocks of any website are handled effortlessly in Chemical using dedicated CBI blocks.

## Static HTML with `#html`

The `#html` block allows you to write standard HTML. Anything inside this block is compiled into static strings that are appended to your `HtmlPage`.

### Value Interpolation
You can inject Chemical variables into your HTML using the `${}` syntax.

```ch
public func welcome(page : &mut HtmlPage, user_name : *char) {
    #html {
        <div class="welcome">
            <h1>Welcome, ${user_name}!</h1>
            <p>This is a static HTML block.</p>
        </div>
    }
}
```

## Styling with `#css`

The `#css` block handles your styles. It can automatically generate class names and append styles to the page's generated CSS file. **It returns the generated class name as a `*char`**, which you can then pass to other elements.

```ch
public func render_styled_div(page : &mut HtmlPage) {
    var my_class = #css {
        background: #f0f0f0;
        padding: 20px;
        border-radius: 8px;
    }
    
    #html {
        <div class="${my_class}">
            Styled with Chemical CSS!
        </div>
    }
}
```

## Client-side Logic with `#js`

Use `#js` to write code that runs in the visitor's browser. This is perfect for simple interactivity like opening a modal.

```ch
public func add_scripts(page : &mut HtmlPage) {
    #js {
        console.log("Hello from the client browser!");
        
        function showAlert() {
            alert("You clicked the button!");
        }
    }
    
    #html {
        <button onclick="showAlert()">Click Me</button>
    }
}
```

## How it works under the hood
When you use these **local macros**, they don't just return text. They actually call methods on an `HtmlPage` instance:
- `#html` calls `page.append_html(...)`
- `#css` calls `page.append_css(...)` and generates a class.
- `#js` calls `page.append_js(...)`

This is why these macros must be inside a function where an `HtmlPage` (typically named `page`) is available.

> [!NOTE]
> All strings in Chemical (literals or multiline) are `*char`. You do not need to call `.data()` to use them in `printf` or CBI blocks.
