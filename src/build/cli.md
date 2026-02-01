# CLI Reference

The `chemical` command-line tool is a versatile entry point for compilation, translation, and project management.

## Project Setup

### `configure`
Configures the compiler for the current OS. It sets `CHEMICAL_HOME` and adds the compiler to the system `PATH`.
```bash
chemical configure
```

## Compilation Basics

### Single File Compilation
```bash
chemical main.ch -o main.exe
```

### Options
- **`-o <path>`, `--output <path>`**: Specify the output file. The output type is determined by the extension (`.exe`, `.o`, `.c`, `.ch`).
- **`--ignore-extension`**: Ignore the output file's extension and use default behavior.
- **`-g`**: Include debug information (automatically enabled in `debug` modes).

## Output Modes (`--mode` or `-m`)

Chemical supports several pre-configured compilation modes:

| Mode | Description |
| :--- | :--- |
| `debug` | Standard debug build (default). |
| `debug_quick` | Fast compilation, minimal optimizations. |
| `debug_complete` | Full debug info, exhaustive checks. |
| `release_fast` | Optimized for execution speed. |
| `release_small` | Optimized for binary size. |

```bash
chemical main.ch -m release_fast -o production_app
```

## Build System & Modules

### Building a Project
Running a `.lab` or `.mod` file triggers the build system.
```bash
chemical build.lab
```

### Arguments for `build.lab`
You can pass custom arguments to your build scripts using the `--arg-` prefix.
```bash
chemical build.lab --arg-target=wasm
```

### Module Management
- **`--mod <name>=<path>`**: Manually define a module mapping.
- **`--cbi-m <name>:<path>`**: Register a CBI module (like `html_cbi`) by pointing to its source directory.

## Intermediate Artifacts

You can output specific compilation stages:
- **`--out-ll <path>`**: Output LLVM IR.
- **`--out-asm <path>`**: Output Assembly.
- **`--out-bc <path>`**: Output LLVM Bitcode.
- **`--out-obj <path>`**: Output Object file.
- **`--debug-ir`**: Output IR even if compilation fails.

## JIT Execution

Run Chemical code immediately without permanent binary generation.
```bash
chemical --jit main.ch
```

## Toolchain Wrappers

Chemical acts as a driver for several underlying tools:
- **`cc`**: A wrapper for Clang.
- **`ar`**: Archive utility.
- **`dlltool`**: DLL management.
- **`lib`, `ranlib`**: Library indexing.

Examples:
```bash
chemical cc main.c -o main.o
chemical ar rc libtest.a test1.o test2.o
```

## Other Flags
- **`--version`**: Display current version.
- **`--help`**: Display help message.
- **`--verbose`, `-v`**: Enable detailed logging.
- **`--benchmark`, `-bm`**: Benchmark the compilation process.
- **`--assertions`**: Force enable assertions in the generated code.
- **`--lto`**: Force Link Time Optimization.
- **`--no-cache`**: Disable compilation cache.
- **`--res <dir>`**: Change the location of the compiler's resources directory.
