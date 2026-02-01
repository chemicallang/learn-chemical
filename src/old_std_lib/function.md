### Capturing Functions

To use lambdas that are capturing, We use the `std::function` struct

```ch
func call_lamb(my_lamb : std::function<() => int>) {
    printf("%d", my_lamb())
}

func create_lamb() {
    var i = 33
    call_lamb(|i|() => {
        return i;
    })
}
```

The given list in pipes `||` contains identifiers that are captured

You can type `&` before them to capture them by reference

```ch
func create_lamb() {
    var i = 44
    call_lamb(|&i|() => {
        return i;
    })
}
```