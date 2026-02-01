# chemical.mod

The `chemical.mod` file is the fundamental unit of project configuration in Chemical. While `build.lab` is for complex build orchestration, `chemical.mod` is used to define simple modules and their immediate dependencies.

## Structure of `chemical.mod`

A typical `chemical.mod` consists of three main parts: module name, source directories, and imports.

```chmod
# Define the name of this module
module my_module

# Specify where the .ch source files are located
source "src"

# Import other modules this project depends on
import std
import fs
import my_other_lib
```

## Keyword Reference

- **`module <name>`**: (Required) Sets the name of the module. This name is used by others when they `import` your project.
- **`source <path>`**: Adds a directory to be scanned for `.ch` files. You can have multiple `source` lines.
- **`import <module_name>`**: Tells the compiler to make the public symbols of another module available to this one.
- **`export <module_name>`**: Similar to `import`, but also makes the symbols of that module available to anyone who imports *your* module (transitive dependency).

## No Top-Level Imports
One of the unique features of Chemical is that you **never** write `import` at the top of a `.ch` file. 

If you have two files `a.ch` and `b.ch` in the same module, they can see each other's public symbols automatically. If you import `std` in `chemical.mod`, all files in your project can see `std::string`, `std::vector`, etc., immediately.

---

Next: **[Writing build.lab](build_lab.md)**
