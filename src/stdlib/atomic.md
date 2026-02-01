# Atomic Operations

The `atomic` module provides low-level synchronization primitives. These functions are implemented as bare top-level functions (no namespace wrapping) for maximum efficiency.

## Getting Started

To use atomics, simply import the module.

```ch
import atomic
```

## Atomic Functions

Chemical provides atomic operations for `u64`, `u32`, `u16`, and `u8`. 

### Load & Store

```ch
var value : u64 = 0
atomic_store_u64(&mut value, 42)

var current = atomic_load_u64(&value)
```

### Compare and Exchange (CAS)

CAS operations are the building blocks of lock-free data structures.

```ch
var state : u32 = 0
var expected : u32 = 0
var desired : u32 = 1

if (atomic_compare_exchange_strong_u32(&mut state, &mut expected, desired)) {
    // Successfully changed state from 0 to 1
}
```

### Fetch and Modify

Operations like `add`, `sub`, `and`, `or`, and `xor` return the **previous** value.

```ch
var counter : u64 = 10
var previous = atomic_fetch_add_u64(&mut counter, 5)
// counter is now 15, previous is 10
```

## Memory Orders

You can optionally specify a `memory_order`. If omitted, `seq_cst` (Sequentially Consistent) is used.

- `memory_order.relaxed`
- `memory_order.consume`
- `memory_order.acquire`
- `memory_order.release`
- `memory_order.acq_rel`
- `memory_order.seq_cst`

```ch
atomic_store_u64(&mut value, 100, memory_order.release)
```

## Fences

Use `atomic_fence` to enforce memory ordering without a specific atomic variable.

```ch
atomic_fence(memory_order.acquire)
```

## Available Types Reference

The following functions are available for `u64`, `u32`, `u16`, and `u8`:

- `atomic_load_[type]`
- `atomic_store_[type]`
- `atomic_exchange_[type]`
- `atomic_compare_exchange_weak_[type]`
- `atomic_compare_exchange_strong_[type]`
- `atomic_fetch_add_[type]`
- `atomic_fetch_sub_[type]`
- `atomic_fetch_and_[type]`
- `atomic_fetch_or_[type]`
- `atomic_fetch_xor_[type]`

> [!NOTE]
> These functions operate on raw pointers (`*u64`, etc.). Ensure the memory is properly aligned for your target architecture.
