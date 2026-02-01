# Getting Started

Welcome to Chemical! This guide will help you set up your environment and create your first high-performance application.

## 1. Installation

1.  Download the latest compiler for your architecture from the [Releases](https://github.com/chemical-lang/chemical/releases) page.
2.  Extract the binary to a directory on your machine.
3.  Open a terminal as Administrator (Windows) or use `sudo` (Linux) and run:
    ```bash
    chemical configure
    ```
    This automatically sets the `CHEMICAL_HOME` environment variable and adds the compiler to your `PATH`.

## 2. Your First Project

Chemical projects are defined by a `chemical.mod` file. This file tells the compiler about your module's name, source directory, and dependencies.

### Create the Structure
Create a new directory and these two files:

**`chemical.mod`**
```ch
module hello_world
source "src"
```

**`src/main.ch`**
```ch
import std

public func main() {
    printf("Hello, Chemical!\n");
}
```

## 3. Building and Running

You don't need to specify every file to the compiler. When you run the `chemical` command in a directory with a `chemical.mod` file, it will be **automatically detected** and processed.

```bash
chemical build.lab  # If you have a build.lab
# OR simply define a target:
chemical src/main.ch -o hello
```

## 4. Why use `chemical.mod`?

The `chemical.mod` file is the source of truth for your project's identity. 
- **Implicit Loading**: Any time you compile a file within a module, the compiler pre-loads the metadata from `chemical.mod`.
- **Dependency Management**: It allows you to import other Chemical modules by their logical name.

---

Next: **[Basics](language/basics.md)**
