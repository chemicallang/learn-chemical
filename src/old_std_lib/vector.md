### Vector

Here are some functions available in the vector struct

```ch
func create_vec() {
    var v = std::vector<int>()

    // get the item at index
    var item = v.get(1)
    var item_ptr = v.get_ptr(1)

    // push two items 0=>32, 1=>10
    v.push(32)
    v.push(10)

    // remove the second item
    v.remove(1)

    // remove the last item
    v.remove_last()

    // check if its empty
    if(v.empty()) {
        // its empty here
    }
    
    // get the size and capacity
    var s = v.size()
    var c = v.capacity()

    // clear all the items
    v.clear()

    // automatically destructs
}
```

