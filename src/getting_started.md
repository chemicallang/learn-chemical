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
```chmod
module hello_world
source "src"
import std
```

**`src/main.ch`**
```ch
public func main() : int {
    printf("Hello, Chemical!\n");
    return 0;
}
```

##### What's happening in chemical.mod file

`source "src"` would add the `src` directory and any file inside it (recursively) that has a .ch extension

`import std` exports printf symbol

##### Where's all the imports

Do not write import statements in files ending with `.ch` extension, Import statements are only valid in `chemical.mod`
and `build.lab` files.

## 3. Building and Running

```bash
chemical chemical.mod -o hello.exe
```

## 4. Multiple modules

use this in a `chemical.mod` file to import a module that exists locally

```chmod
import "my_mod"
```

Notice this time, I added quotes around `my_mod`, this tells the compiler that its a directory. Compiler then looks for a chemical.mod file
in the directory, at path `my_mod/chemical.mod` and compiles that too.

---
