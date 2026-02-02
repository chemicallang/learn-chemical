# Writing build.lab

`build.lab` files are the "executable recipes" for your project. They are written in Chemical itself but have special capabilities for project orchestration.

## File Structure

Unlike standard `.ch` files, `build.lab` files support **`import` statements** at the very top. This allows you to import other build scripts or modules and use their logic.

```ch
import lab
import std
import "./submod/build.lab" as submod  // Direct script import
import "@json/build.lab" as jsonMod      // Alias-based import
```

## Module Symmetry

Chemical supports a unique symmetrical relationship between logical modules (`chemical.mod`) and build scripts (`build.lab`).

1.  **Inverse Imports**: 
    - A `build.lab` can import a module that contains a `chemical.mod`.
    - A `chemical.mod` can import a module that contains a `build.lab` (the build script will be executed to resolve the module).
2.  **Automatic Detection**: 
    When you run `chemical build.lab`, the compiler automatically detects your environment. If a `chemical.mod` is present in the directory, its metadata is pre-loaded before the `build(ctx)` function is called.

## Using Imported Build Scripts

When you import a `.lab` file, you can call its `build` function or any other public functions it defines. This is perfect for composing complex builds from smaller parts.

```ch
import "./network_module/build.lab" as net

func build(ctx : *mut BuildContext) {
    // Manually trigger the build logic for the sub-module
    const net_job = net.build(ctx)
    
    const main_job = ctx.build_exe("my_app")
    ctx.add_module(main_job, net_job)
}
```

## Relative Paths

In `build.lab`, you have access to `lab::rel_path_to(path)`. This ensures that paths are resolved relative to the location of the `.lab` file, making your build scripts portable.

```ch
const src_path = lab::rel_path_to("src")
ctx.chemical_dir_module("", "core", src_path, [])
```

## Definitions and Comptime

You can pass flags to your code using `ctx.define`.

```ch
ctx.define(job, "DEBUG_LOGS")
```

In your source code:
```ch
comptime if (def.DEBUG_LOGS) {
    printf("Debug info...\n");
}
```

---
