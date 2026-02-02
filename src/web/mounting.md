# Component Mounting

For a component's JavaScript and state logic to be included in the final web bundle, it must be explicitly **mounted** within an `#html` block.

## Mounting Syntax

Components are mounted using standard JSX-like tags within an `#html` macro. This tells the compiler to:
1. Generate the static HTML for the component.
2. Inject the necessary framework scripts (React, Solid, etc.).
3. Add the hydration logic to the client-side bundle.

```ch
#react Greeting(name : *char) {
    return <h1>Hello, {name}!</h1>
}

public func home(page : &mut HtmlPage) {
    #html {
        <div>
            <Greeting name="Alice" />
        </div>
    }
}
```

> [!IMPORTANT]
> If you define a component but never "use" it via the `<Component />` tag in an `#html` block, its JavaScript code will **not** be present in the final page bundle.

## The Hydration Model

Chemical follows a "Static-by-Default" approach similar to Astro. 
- Content outside of components is static HTML.
- Components allow you to add interactivity (state, effects) to specific parts of the page.
- The `#js` macro can be used for simple, framework-less client-side logic.

## Layouts and Slots

You can pass children to components or use them within layouts to structure your site.

```ch
#html {
    <Layout title="Home">
        <Greeting name="Admin" />
    </Layout>
}
```

## Scoped Styles

If a component uses an internal `#css` block, those styles are automatically scoped and included in the page's generated CSS file.

---