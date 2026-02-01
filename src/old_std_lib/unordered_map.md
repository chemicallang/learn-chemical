### Unordered Map

Here's how to use an unordered map in chemical

```ch
func take(map : std::unordered_map<int, int>& map) {

}

func create() {
    var m = std::unordered_map<int, int>()

    // insert values with keys
    m.insert(10, 20)
    m.insert(30, 40)

    // check if key exists
    var check = m.contains(10)

    // find the value of the key
    var value2 = m.get_ptr(10)

    // erase a value
    m.erase(10)

    // get the size
    var s = m.size()

    // check if empty
    m.empty()

}
```