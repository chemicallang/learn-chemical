# Introduction

Welcome to **Chemical**, a modern, statically typed systems programming language with a clean syntax and seamless interoperability with C libraries.

- **File extension**: `.ch`
- **Module descriptor**: `chemical.mod`

In this book, you will learn how to:

1. Scaffold a new Chemical project
2. Write and organize your source code in Markdown-friendly files
3. Import and use modules (including the C standard library via `cstd`)
4. Build and run your Chemical applications

### Hello, World!

1. Create a directory for your project and enter it:

   ```bash
   mkdir hello_chemical && cd hello_chemical
   ```

2. Create a `src/` folder and add `main.ch`:

   ```text
   src/main.ch
   ```

3. In `src/main.ch`, write your first program:

   ```ch
   public func main() : int {
       printf("Hello, World!\n");
       return 0;
   }
   ```

4. Create the `chemical.mod` file at the project root to describe sources and dependencies:

   ```text
   chemical.mod
   ```

   ```toml
   module main

   # Tell the compiler to include all .ch files in `src/`
   source "src"

   # Import the C standard library module
   import cstd
   ```

Your project structure now looks like:

```
hello_chemical/
├── chemical.mod
└── src/
    └── main.ch
```

5. Build and run your program:

* **Windows**:

  ```powershell
  chemical.exe chemical.mod -o main.exe
  .\main.exe
  ```

* **Linux/macOS**:

  ```bash
  chemical chemical.mod -o main && ./main
  ```

> **Tip:** If you prefer not to import `cstd`, you can declare extern functions inline:
>
> ```ch
> @extern
> public func printf(format: *char, _ : any...) : int
> ```

That's it! You’ve just compiled and run your first Chemical program. In the next chapter, we’ll dive deeper into project structure and configuration.\`\`\`