# Frameworks (React, Solid & Preact)

Chemical allows you to use modern JavaScript frameworks for building interactive UI components. The compiler translates these components to JS and integrates them seamlessly into your static pages.

## Configuring Dependencies

Before using a framework macro, you must import the corresponding CBI in your `chemical.mod` file.

```ch
# chemical.mod
module my_app

source "src"
import react_cbi  # Required for #react
import solid_cbi  # Required for #solid
```

## Defining a Component

Components are defined at the **top level** of your file (outside of any function).

```ch
// This is a React component
#react Counter(initial_count : int) {
    const [count, setCount] = useState(initial_count || 0);
    
    return (
        <div>
            <p>Count: {count}</p>
            <button onClick={() => setCount(count + 1)}>Increment</button>
        </div>
    );
}
```

## Mounting Components

To include a component in your page, you must mount it using `<Component />` syntax inside a **local** `#html` block.

```ch
public func build_page(page : &mut HtmlPage) {
    page.defaultReactSetup(); // Injects framework runtime
    
    #html {
        <div id="content">
            <h1>My Interactive App</h1>
            <Counter initial_count={5} />
        </div>
    }
}
```

### The Hydration Model
When a component is mounted:
1.  **Code Injection**: Chemical appends the component's JS code to the page's script bundle.
2.  **Statics**: A static HTML placeholder is generated if possible.
3.  **Hydration**: On the client side, the framework mounts the interactive logic onto the placeholder.

> [!IMPORTANT]
> If a component is defined but never used via the `<Counter />` tag in an `#html` block, it will **not** be included in the bundle.

## Framework Setup Functions

Each framework requires a setup call on the `HtmlPage` to include its runtime (usually from a CDN in development).

| Framework | Setup Method |
| :--- | :--- |
| **React** | `page.defaultReactSetup()` |
| **SolidJS** | `page.defaultSolidSetup()` |
| **Preact** | `page.defaultPreactSetup()` |

---
