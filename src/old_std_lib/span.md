### Span

span is a struct that is kind of like a string_view

```ch
func run() {
    var span = std::span<int>()

    span.data(); // gets the pointer

    span.size(); // gets the size

    var item3 = span.get(3); // gets pointer to an integer at location 3

    // check if empty
    if(span.empty()) {
        // its empty
    }

}
```

We can create spans out of arrays

```ch
func run() {
    var arr = [10, 20, 30, 40, 50]
    var view = std::span<int>(arr)
}
```

or vectors

```ch
func create_span(std::vector<int>& vec) {
    var view = std::span<int>(vec)
    // now you can pass it to other functions
}
```