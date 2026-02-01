### String View

`string_view` is a struct that is similar to C++ string_view, string_view contains
a data pointer and a size, The actual string is allocated somewhere else, This is just
a view into it, This can be easily sliced

Lets create and print a string_view

```ch
func print_my_view(view : std::string_view) {
    printf("%s\n", view.data());
}

func run() {
    // create by implicit constructor
    print_my_view("Hello World")
    // create explicitly
    print_my_view(std::string_view("Hello World2"))
}
```

A `std::string_view` has `data` and `size` functions