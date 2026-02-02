# Concurrency: ThreadPool & Tasks

Chemical provides a robust set of concurrency primitives in the `std::concurrent` namespace, ranging from low-level thread management to high-level task pools.

## Thread Management

You can spawn native threads using `std::concurrent::spawn`.

```ch
import std

func worker(arg : *void) : *void {
    printf("Thread running!\n")
    return null
}

public func main() {
    var thread = std::concurrent::spawn(worker, null)
    thread.join()
}
```

## ThreadPool

The `ThreadPool` is the recommended way to handle multiple tasks efficiently without the overhead of creating and destroying threads repeatedly.

### Creating a Pool

```ch
// Create a pool with 4 worker threads
var pool = std::concurrent::create_pool(4u)
```

### Submitting Tasks

You can submit tasks that return a value using `submit`, which returns a `Future`, or fire-and-forget tasks using `submit_void`.

```ch
// Submit a task with a return value
var future = pool.submit<int>(|x| () => {
    return 42
})

// Wait for result
var result = future.get()
printf("Result: %d\n", result)

// Submit a void task
pool.submit_void(() => {
    printf("Background task done\n")
})
```

## Futures and Promises

Futures and Promises allow for safe communication between threads.
- A **Promise** is the "write" end: the producer sets the value.
- A **Future** is the "read" end: the consumer waits for the value.

```ch
// Futures are automatically handled by the ThreadPool,
// but can be used manually for custom synchronization patterns.
```

## Utilities

- **`hardware_threads()`**: Returns the number of logical processors on the system.
- **`sleep_ms(ms : ulong)`**: Pauses the current thread for the specified duration.

```ch
var cores = std::concurrent::hardware_threads()
printf("System has %d cores\n", cores)
```

> [!TIP]
> Use `ThreadPool` for CPU-bound tasks to maximize performance while keeping your main thread responsive.

---
