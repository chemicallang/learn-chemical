# Learn Chemical

A comprehensive guide to the **Chemical** programming language — a high-performance, statically typed systems language that compiles to C, with first-class web development support.

## About

This book covers everything from basic syntax to advanced topics like memory management, web development with React/Solid, and building with the custom `lab` build engine.

## Sections

- **[Introduction](src/introduction.md)** — What is Chemical and why it exists
- **[Getting Started](src/getting_started.md)** — Installation and first project
- **Language Guide** — Syntax, types, functions, structs, enums, generics, interfaces, memory
- **Web Development** — HTML macros, CSS, JS, React/Solid components, mounting
- **Build System** — `chemical.mod`, `build.lab`, CLI reference
- **Standard Library** — Strings, vectors, maps, JSON, networking, concurrency

## Building the Docs

The documentation is built using a custom Chemical-based doc generator:

```bash
# Build the docs generator
chemical chemical.mod -o docs.exe

# Generate the static site
bash build.sh
```

Output is written to `./book` and deployed to Cloudflare Workers.

## License

Chemical Language Documentation — © 2026 Chemical Language Team
