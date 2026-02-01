# Lab Overview

**Lab** is the custom build engine for the Chemical language. It is designed to be scriptable, fast, and extensible. Unlike traditional build systems that use static configuration files (like JSON or YAML), Lab uses Chemical itself to define the build process.

## Why Scriptable Builds?

Static configuration often falls short when you need complex logic during a build (e.g., generating code based on assets, conditional compilation for obscure targets, or multi-step toolchains). Lab gives you the full power of a programming language for your build scripts.

## Core Concepts

### The Build Script (`build.lab`)
A `build.lab` file is a Chemical file that contains a `build` function. This function is called by the compiler to orchestrate the build.

```ch
// build.lab
import lab

func build(ctx : *mut BuildContext) {
    const exe_name = "my_app"
    const job = ctx.build_exe(exe_name)
    
    // Define the module
    const main_mod = ctx.chemical_dir_module("", "main", "src", [])
    
    // Add the module to the job
    ctx.add_module(job, main_mod)
}
```

### BuildContext
The `BuildContext` is an interface provided to your `build` function. It contains methods to:
- Create modules (`chemical_dir_module`, `c_file_module`).
- Define output targets (`build_exe`, `build_dynamic_lib`, `build_cbi`).
- Manage dependencies and linking.
- Access command-line arguments.

### Lab Jobs
A **Job** represents a single unit of work (e.g., "Build this executable"). You can have multiple jobs in a single build process (e.g., build a library and then build a test suite that uses it).

---

Next: **[chemical.mod](mod.md)**
