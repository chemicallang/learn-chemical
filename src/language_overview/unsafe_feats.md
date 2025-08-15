# Unsafe Features

These features are experimental, They are mostly expected to stay
because they are very useful even though unsafe, but things can change

Currently chemical doesn't enforce safety, however that will change,
To use these features you must put them in unsafe block

## New

Want to allocate on heap, You should not use malloc and instead use `new` like in C++

The return is an unsafe pointer that must be manually deallocated

Allocating using new + type

```
// allocating an integer on heap
var heap_int = new int

// lets assign to it
*heap_int = 33

// must de-allocate / free the heap allocated integer
delete heap_int
```

You can use it with structs

```
var p = new Point { a : 10, b  : 20 }

// calling constructors
var p2 = new Point(10, 20)

// release p (calls destructor and free's memory)
delete p
```

## Placement New

Placement new allows separation of allocation and initialization, because sometimes allocators
are used to allocate which return pointers then placement new can be used to initialize such pointers

Placement new is also used because dereferencing and assignment destructs / drops the previous value which is
expected behavior

```
// allocate a Point on heap
var p = new Point

// initialize the pointer with a custom struct
new (p) Point { a : int, b : int }

// or call constructors
new (p) Point(10, 20)
```

Initializing multiple objects, One can initialize multiple objects

```
// allocate 10 points
var p = new Point[10]

// initialize 10 points
new[10] (p) Point { a : 10, b : 20 }

// or call constructors
new[10] (p) Point(10, 20)
```

## Destruct

Chemical provides a destruct statement which allows you to destruct something without freeing its memory
for example

This allows reusing memory after destructing the original object at that location

```
// allocate container on heap
var p = new Container()

// lets destruct the container
destruct p

// lets reuse the memory
new (p) Container()

// You must free the container
// otherwise there would be a memory leak
```

Destructing multiple, a pointer can refer to multiple objects, We see this in the implementation of vector
Here's how to handle such case

```
// allocate 10 points on the heap
var p = new Point[10]

// initialize 10 points (must initialize before calling destructors)
new[10] (p) Point { a : 10, b : 20 }

// destruct 10 points from the heap
destruct[10] p
```

Notice you have to provide size, this size need not be a constant

## Dealloc

Dealloc allows you to free the memory without any destruction, its like the free function from C standard library
You should definitely use dealloc instead of free, because it allows us to eliminate such statements when
targeting a runtime which will garbage collect (jvm / clr) in the future

```
// allocate a integer on heap
var p = new int

// de allocate from heap
dealloc p
```

Please note that the above example only should be used with types that don't have destructors, for types that have
destruction and destruct statement should be used, which automatically is a no-op when destructor is not present

Here's the complete flow
```
// allocate a point on heap
var p = new Point()

// destruct the point
destruct p

// reuse its memory
new (p) Point()

// free the point
dealloc p
```

### Delete

A delete statement statement is just like a destruct statement, Its just syntactic sugar

It first destructs the object then frees the memory

```
// allocate on heap
var p = new Point()

// destruct + delete from heap
delete p
```

Similarly on multiple objects you should do

```
// allocate 10 points
var p = new Point[10]

// initialize 10 points (must initialize before calling destructors)
new[10] (p) Point { a : 10, b : 20 }

// destruct 10 points and also free the memory
delete[10] p
```