# fs: File System

The `fs` module provides a simple and efficient API for interacting with the file system.

## Basic File Operations

### Reading Files
```ch
import fs
import std

var content = fs::read_file("config.txt") // Returns std::string
if (!content.empty()) {
    printf("Read %d bytes\n", content.size())
}
```

### Writing Files
```ch
var data = "Important information"
fs::write_to_file("output.txt", data.data())
```

## Directory Management

### Creating and Deleting
```ch
fs::mkdir("logs")
fs::remove_dir("old_logs")
```

### Path Manipulation
The `fs` module includes helpers for building paths across different operating systems.

```ch
var full_path = fs::path_join("home", "user", "documents")
// "home/user/documents" on Linux, "home\user\documents" on Windows
```

## Checking Existence

```ch
if (fs::exists("data.bin")) {
    printf("File found!\n")
}

if (fs::is_directory("src")) {
    printf("Source directory exists.\n")
}
```

---

Next: **[json: Data Serialization](json.md)**
