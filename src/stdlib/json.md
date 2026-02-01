# json: Data Serialization

The `json` module allows you to parse and generate JSON data, making it easy to build APIs or save configuration files.

## Parsing JSON

You can parse a JSON string into a `JsonValue` variant.

```ch
import json

var raw = """{"name": "Alice", "age": 25}"""
var result = json::parse(raw)

var Object(map) = result else return

var name = map.get("name").as_string()
var age = map.get("age").as_int()
```

## Generating JSON

Use the `JsonBuilder` to construct JSON structures programmatically.

```ch
var builder = json::JsonBuilder()
builder.begin_object()
    builder.put_string("status", "success")
    builder.put_int("code", 200)
    
    builder.begin_array("data")
        builder.put_int(1)
        builder.put_int(2)
        builder.put_int(3)
    builder.end_array()
builder.end_object()

var output = builder.to_string()
// {"status":"success","code":200,"data":[1,2,3]}
```

## Serialization Rules
- **Strings**: Mapped to `std::string`.
- **Numbers**: Mapped to `i64` or `double`.
- **Objects**: Mapped to `std::unordered_map<std::string, JsonValue>`.
- **Arrays**: Mapped to `std::vector<JsonValue>`.

---

Next: **[net & http: Networking](net_http.md)**
