### String

Here's how strings can be used

```
func take_str(str : std::string) {
    printf("%s", str.data());
}

func run() {
    take_str(std::string("my string"))
}
```

Some functions available in the string struct

```
func run(str : std::string) {
    
    // append some characters
    str.append('a')
    str.append('b')

    // check if empty
    if(str.empty()) {
        // its empty
    }

    // get the size of string
    var s = str.size()

    // check if equal to another string
    if(str.equals(std::string("other"))) {
        // yes its equal
    }

    // create a substring
    var sub = str.substring(10, 15)

    // copy the string
    var co = str.copy()

    // clear the string
    str.clear()

}
```