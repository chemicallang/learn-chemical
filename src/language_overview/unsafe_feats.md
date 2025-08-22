# Unsafe Features

> These features are **experimental**. They are useful but unsafe and may change.

Chemical does **not** currently enforce safety for these features. To use any unsafe feature you **must** place it inside an `unsafe` block.

---

## 1. `new` — heap allocation

Use `new` (not `malloc`) to allocate on the heap. `new` returns an *unsafe pointer* that must be manually released.

**Key points**

* Use `new T` to allocate an object of type `T` on the heap.
* Use `delete` to destruct and free the memory, or `dealloc` to free without running destructors (see below).

```c
// allocate an integer on the heap
var heap_int = new int

// assign to it
*heap_int = 33

// must deallocate / free the heap-allocated integer
delete heap_int
```

You can allocate structs and call constructors:

```c
var p = new Point { a: 10, b: 20 }

// calling a constructor
var p2 = new Point(10, 20)

// release p (calls destructor and frees memory)
delete p
```

---

## 2. Placement `new`

Placement `new` separates allocation from initialization. Useful when you have a custom allocator that returns raw memory and you want to construct an object into that memory.

Placement `new` also avoids calling a destructor implicitly via assignment — you explicitly destruct when needed.

```c
// allocate a Point on the heap
var p = new Point

// initialize the pointer with a struct literal
new (p) Point { a: 10, b: 20 }

// or call a constructor
new (p) Point(10, 20)
```

**Initialize multiple objects**

```c
// allocate 10 points
var p = new Point[10]

// initialize 10 points
// initialize 10 points
for(var i = 0; i < 10; i++) {
    new (p + i) Point { a: 10, b: 20 }
}

// or call constructors for each
// initialize 10 points
for(var i = 0; i < 10; i++) {
    new (p + i) Point(10, 20)
}
```

---

## 3. `destruct`

`destruct` runs an object's destructor without freeing its memory. This lets you reuse the memory at the same address (for example, with placement `new`).

```c
// allocate container on heap
var p = new Container()

// run destructor but keep memory
destruct p

// reuse the memory by constructing a new object there
new (p) Container()

// remember: you must free the container later to avoid a memory leak
dealloc p
```

**Destructing multiple objects**

This pattern appears in container implementations (e.g. dynamic arrays). You must provide the count when destructing multiple objects.

```c
// allocate 10 points on the heap
var p = new Point[10]

// initialize 10 points (must initialize before calling destructors)
// initialize 10 points
for(var i = 0; i < 10; i++) {
    new (p + i) Point { a: 10, b: 20 }
}

// destruct 10 points from the heap
destruct[10] p
```

> Note: the size passed to `destruct[...]` need not be a compile-time constant.

---

## 4. `dealloc`

`dealloc` frees memory **without** running destructors (similar to `free` in C). Prefer `dealloc` over `free` since `dealloc` can be optimized away when targeting a managed runtime (JVM/CLR) later.

Only use `dealloc` for types that **do not** have destructors. For types with destructors, use `destruct` (and then `dealloc` if you also want to free memory).

```c
// allocate an integer on heap
var p = new int

// deallocate from heap
dealloc p
```

**Typical flow when you need explicit destructor + free**

```c
// allocate a point on heap
var p = new Point()

// run destructor
destruct p

// reuse its memory
new (p) Point()

// destruct new memory
destruct p

// free the memory
dealloc p
```

---

## 5. `delete`

`delete` is syntactic sugar: it first runs the destructor (if present) and then frees the memory — equivalent to `destruct` followed by `dealloc`.

```c
// allocate on heap
var p = new Point()

// destruct + free
delete p
```

**Multiple objects**

```
// allocate 10 points
var p = new Point[10]

// initialize 10 points
for(var i = 0; i < 10; i++) {
    new (p + i) Point { a: 10, b: 20 }
}

// destruct 10 points and free memory
delete[10] p
```

---

## 6. `intrinsics::forget`

intrinsics::forget is an intrinsic function in the compiler that allows you to forget destruction for a variable
or parameter

```
func take_object(obj : Object) {
    
    // obj will not be dropped
    intrinsics::forget(obj)

    // the obj has been moved into take_object function
    // which means it won't be destructed at the call site as well
    // so you can move obj manually by using memcpy here

}
```

---

## Safety reminders

* All heap operations described here are **unsafe** and must be inside an `unsafe` block.
* Always ensure objects are properly constructed before calling destructors.
* If you skip destructors and use `dealloc`, be certain the type has no destructor logic.
* Mismatched `new`/`delete`, `destruct`/`dealloc`, or double-frees will cause undefined behavior.