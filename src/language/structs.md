# Structs

Structs are the primary way to organize data in Chemical. They are contiguous blocks of memory.

### Definition and Initialization

```ch
struct Point {
    var x : float
    var y : float
}

func demo() {
    var p = Point { x : 10.0, y : 20.0 }
}
```

When you use no initializer, Chemical doesn't zero out the variable, Chemical may generate an error in the future
if you used it before initializing, for example

```ch
struct Point {
    var x : int
    var y : int
}
func demo() {
    var p : Point
    // ❌ runtime memory access exception, p hasn't been initialized
    // since p contains garbage data
    printf("%d, %d\n", p.x, p.y);
}
```

When you use brace initializer, you must initialize all the fields, otherwise compiler will produce an error

```ch
func demo() {
    // this will cause an error, you didn't initialize all the fields
    // the compiler will ask you to initialize the y field
    // ❌ Invalid, must initialize the field y
    var z = Point { x : 1.0 }
}
```

You can use default value for the field 'y' in the struct, compiler will no longer force you to initialize it

```ch
struct Point {
    var x : int
    var y : int = 99
}

func demo() {
    var p = Point { x : 10 }
    // p.y is 99 here
}
```

When the compiler can infer the type of the struct, you can use braces without the type to initialize it

```ch
struct Point { 
    var x : int = 10
    var y : int = 20 
}
func demo() {
    var p : Point = {}
    // p.x is 10 and p.y is 20
    
    var p2 : Point = { x : 20 }
    // p2.x is 20 and p2.y is also 20
}
```

### Struct and Union members

structs can contain anonymous structs for complex layouts:

```ch
struct Storage {
    struct {
        var data : *char
        var length : size_t
    } heap;
    struct {
        var buffer : [16]char
        var length : uchar
    } sso;
}

var s : Storage
s.sso.buffer[0] = 'H'
s.sso.length = 1
```

### Constructors

You can use constructors to initialize structs, which come in handy for structs that have a lot of fields.
In chemical, constructors are just functions that return an object of the struct. You must however use the annotation
`@make` for constructors.

All constructors must have different names than their functions, otherwise conflicts will cause compilation errors. If
there are two constructors that take the same number of arguments and types, the first constructor (that appears first at top)
will be called.

```ch
struct Point {
    var x : int
    var y : int

    @make
    func make() {
        // you must return an object of Point
        return Point { x : 10, y : 20 }
    }
    
    @make
    func make2(value : int) {
        // constructors automatically have return type of the struct, therefore you don't need to mention it
        return { x : value, y : value }
    }

}

func demo() {
    // calls the first function, which has @make annotation, that can accept given arguments
    var p = Point()
    // p.x is 10, p.y is 20
    
    var p2 = Point(99)
    // p2.x is 99, p2.y is 99
}
```

### Automatic Constructor Generation

The compiler will generate a constructor for you, as long as it can. There are these rules compiler follows

1 - Every member of the struct has a known default value
2 - Every inherited struct can be initialized via default values or has a default constructor

If these are true, compiler generates a default constructor for you.

```ch
// will generate an automatic constructor
struct Auto {}

// will generate an automatic constructor
struct Auto2 { 
    var a : int = 10
    var b : int = 20
}

// ❌ will not generate an automatic constructor
// because default value for b is missing
struct Auto3 {
    var a : int = 10
    var b : int
}

// will generate an automatic constructor
struct Inherited {
    var a : int = 10
    var b : int = 20
}

// will generate an automatic constructor, that'll automatically initialize the Inherited struct
struct Auto4 : Inherited {

}

struct Inherited2 {
    var a : int
    var b : int
    @make
    func make() {
        return { a : 10, b : 20 }
    }
}

// will generate an automatic construcotr because Inherited2 has a default construcotr
struct Auto5 : Inherited2 {

}

// no default/automatic constructor, default value for b is missing
struct Inherited3 {
    var a : int = 10
    var b : int
}

// ❌ will not generate an automatic constructor
// because Inherited3 doesn't have a default constructor
struct Auto6 : Inherited3 {

}

func demo() {
    var a = Auto()
    var a2 = Auto2()
    var a4 = Auto4()
    var a5 = Auto5()
}
```

#### Nested Struct Initialization

When a struct has a default constructor (compiler generated or manual), It is called automatically when initializing.

```ch
// if you omit the default value for b, this would fail
struct DefaultValues {
    var a : int = 10
    var b : int = 20
}
struct Container {
    var d : DefaultValues
}
func demo() {
    var c = Container {}
    // c.d.a is 10 and c.d.b is 20
    
    // making it explicit
    var c2 = Container { d : DefaultValues() }
}
```

Since same syntax (brace initializer) is used in constructors, so no differences

```ch
struct Container {
    var inner : InnerStruct  // Has default constructor
    @make
    func make() {
        return {
            inner : InnerStruct()
        }
    }
    @make
    func make2() {
        return {} // compiler automatically calls InnerStruct's default constructor
    }
}
```

### Methods

Methods can be inside structs, unions or variants, so we'll discuss them here once

```ch
struct Point {
    var a : int
    var b : int
 
    func sum(&self) : int {
        return a + b;
    }
}
func demo() {
    var a : Point { a : 10, b : 20 }
    var s = a.sum() // is 30
}
```

You need to have mutable implicit self argument, if you want to mutate the members of the structs
```ch
struct Point {
    var a : int
    var b : int
 
    // if you write &self, compiler will error out
    func set_both(&mut self, value : int) {
        a = value
        b = value
    }
}
func demo() {
    var a : Point { a : 10, b : 20 }
    a.set_both(0)
}
```

### Struct Inheritance
Chemical supports **single struct inheritance**. A derived struct inherits all members and functions of its base.

```ch
struct Animal {
    var a : int
    var b : int
}

struct WalkingAnimal : Animal {
    var speed : int
}

struct Dog : WalkingAnimal {
    var c : int
    var d : int
}
```

#### Inheritance Initialization Syntax

When creating an instance of a derived struct, you must explicitly initialize all levels:

```ch
func demo() {
    var d = Dog {
        WalkingAnimal : WalkingAnimal {
            Animal : Animal { a : 30, b : 40 },
            speed : 90
        },
        c : 40,
        d : 40
    }
    
    // you can omit the types
    var d2 = Dog {
        // inherited struct can be initialized like a member can be
        WalkingAnimal : {
            Animal : { a : 30, b : 40 },
            speed : 90
        },
        c : 40,
        d : 40
    }
}
```

#### Accessing Inherited Members

You can access base struct members directly

```ch
func demo() {
    var d = Dog { WalkingAnimal { Animal : Animal { a : 30, b : 40 }, speed : 90 }, c : 40, d : 40 }
    d.a      // From Animal: 30
    d.b      // From Animal: 40
    d.speed  // From WalkingAnimal: 90
    d.c      // From Dog: 40
}
```

#### Methods on Inherited Structs

Methods defined on base structs work on derived structs:

```ch
struct Animal {
    var a : int
    var b : int
    
    func sum(&self) : int {
        return a + b
    }
}

struct Dog : Animal {
    var c : int
}

var dog = Dog { Animal : Animal { a : 5, b : 10 }, c : 20 }
dog.sum()  // Returns 15 (calls Animal.sum)
```

#### Passing Derived as Base

Derived structs can be passed to functions expecting base pointers:

```ch
func get_animal(animal : *Animal) : int {
    return animal.a + animal.b
}

var dog = Dog { ... }
get_animal(&dog)  // Works!
```

## Destructors

You can define a destructor for a struct using the `@delete` annotation. This function will be called automatically when an instance goes out of scope or when `destruct` is called.

```ch
struct Resource {
    var raw_handle : *void
    
    @delete
    func destroy(&self) {
        unsafe {
             printf("Cleaning up resource...\n")
             close_handle(self.raw_handle)
        }
    }
}
```

## Destructor Lifecycle

Understanding when `@delete` is called is critical for managing resources.

### Scope Exit

Destructors are called in reverse order of declaration when a scope ends.

```ch
{
    var a = Resource { ... }
    var b = Resource { ... }
} // b.destroy() called, then a.destroy()
```

### Control Flow: `break`, `continue`, `return`

Chemical ensures destructors are called even when exiting a block prematurely.

```ch
func process() {
    var res = Resource { ... }
    if (error) {
        return // res.destroy() is called before returning
    }
}

loop {
    var res = Resource { ... }
    if (done) {
        break // res.destroy() is called before breaking
    }
}
```

### Moves and Destructors

If an object is **moved** to another variable or passed to a function by value, the original variable is considered "empty" and its destructor will **not** be called.

```ch
func take(res : Resource) { } // res.destroy() called here at end of take()

func example() {
    var a = Resource { ... }
    take(a) // a is MOVED to 'take', a.destroy() will NOT be called in example()
}
```

### Assignment to Movable Types

When you assign a new value to a variable that already holds a movable object, the **previous** object's destructor is called before the assignment happens.

```ch
var a = Resource { name: "First" }
a = Resource { name: "Second" } // a.destroy() ("First") is called here
```