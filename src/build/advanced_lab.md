# Advanced Build Patterns

As your Chemical projects grow, you can use advanced patterns in `build.lab` to manage complexity, integrate C/C++ code, and automate post-build actions.

## Multi-Module Orchestration

You can import other `build.lab` files to organize your build logic. This is commonly used in monorepos or when building complex test suites.

```ch
// build.lab
import lab
import "./libs/my_lib/build.lab" as myLib

func build(ctx : *mut AppBuildContext) {
    var exe = ctx.build_exe("my_app")
    
    // Add module defined in another build.lab
    ctx.add_module(exe, myLib.build(ctx, exe))
}
```

## Build Hooks

The `on_finished` hook allows you to run code after a build job completes. This is useful for launching the executable immediately or performing cleanup.

```ch
var jc = JobContext { ctx: ctx, job: exe }

ctx.on_finished((data : *void) => {
    const j = data as *mut JobContext
    if (j.job.getStatus() == LabJobStatus.Success) {
        printf("Build succeeded! Launching...\n")
        j.ctx.launch_executable(j.job.getAbsPath(), true)
    }
}, &jc)
```

## C/C++ Interoperability

The `lab` engine makes it easy to combine Chemical code with existing C or C++ modules.

### Including C Files

```ch
const c_mod = ctx.c_file_module(
    std::string_view(""), 
    std::string_view("my_c_logic"), 
    std::string_view("src/logic.c"), 
    []
)
ctx.add_module(exe_job, c_mod)
```

### Translating C to Chemical

You can even translate C files to Chemical at build time to facilitate easier integration.

```ch
const input_c = "src/legacy.c"
const output_ch = ctx.build_mod_file_path(exe_name, "", "translated", "legacy.ch")
ctx.translate_file_to_chemical(input_c, output_ch)
```

## Custom CLI Arguments

You can pass custom flags to your `build.lab` script from the command line using the `--arg-` prefix.

```bash
chemical build.lab --arg-my_custom_flag=true
```

```ch
if (ctx.has_arg("my_custom_flag")) {
    printf("Custom flag value: %s\n", ctx.get_arg("my_custom_flag").data())
}
```

## Environment Flags

Use `ctx.define` to set compile-time definitions (equivalent to `#define` in C or `def.OS` in Chemical).

```ch
ctx.define(exe_job, "EXPERIMENTAL_FEATURE")
```

---

Next: **[CLI Reference](cli.md)**
