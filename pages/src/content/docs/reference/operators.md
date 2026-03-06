---
title: Operators
description: Purus operators and precedence.
sidebar:
  order: 3
---

## Operator Precedence (low to high)

1. `pipe` — Pipeline
2. `coal` — Nullish coalescing
3. `or` — Logical OR
4. `and` — Logical AND
5. `eq` / `neq` / `not eq` / `is` / `instanceof` — Equality / Type check
6. `lt` / `gt` / `le` (`lt eq`) / `ge` (`gt eq`) — Comparison
7. `add` / `sub` — Addition / Subtraction
8. `mul` / `div` / `mod` — Multiplication / Division / Modulo
9. `pow` — Exponentiation
10. Unary: `not` / `neg` / `typeof` / `await` / `delete` / `new`
11. Postfix: `.` access / `[args]` call / `as` cast
12. Primary: literals, identifiers, brackets

## Pipeline

```
data pipe filter
data pipe filter pipe map
data pipe transform[extra-arg]
data pipe .method[arg]
```

Compiles to:

```js
filter(data)
map(filter(data))
transform(data, extraArg)
data.method(arg)
```

## Assignment

```
const x be 42
let y be 10
y be 20
```

## Arithmetic

```
a add b    -- a + b
a sub b    -- a - b
a mul b    -- a * b
a div b    -- a / b
a mod b    -- a % b
a pow b    -- a ** b
neg x      -- -x
```

## Comparison

`eq` and `is` are interchangeable. When the right side is a type name (e.g., `string`, `number`, `null`, or a capitalized class name), it becomes a type check. Otherwise, it becomes a strict equality comparison (`===`).

For not-equal, use `neq` or `not eq`. For less-than-or-equal, both `le` and `lt eq` work. For greater-than-or-equal, both `ge` and `gt eq` work.

```
a eq b      -- a === b
a neq b     -- a !== b
a not eq b  -- a !== b (alternative)
a lt b      -- a < b
a gt b      -- a > b
a le b      -- a <= b
a lt eq b   -- a <= b (alternative)
a ge b      -- a >= b
a gt eq b   -- a >= b (alternative)

-- eq and is can be used interchangeably
a eq b     -- a === b (value comparison)
a is b     -- a === b (value comparison)
a eq string -- typeof a === "string" (type check)
a is string -- typeof a === "string" (type check)
```

## Array Ranges

Generate arrays from numeric ranges using `..` (inclusive) and `...` (exclusive):

```
const a be [0..5]     -- [0, 1, 2, 3, 4, 5]
const b be [0...5]    -- [0, 1, 2, 3, 4]
const c be [1..10]    -- [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
const d be [1...10]   -- [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

## Slicing

Extract a portion of an array using `..` (inclusive) or `...` (exclusive) inside bracket access:

```
const numbers be [0, 1, 2, 3, 4, 5, 6]
const middle be numbers[2..4]    -- [2, 3, 4]
const partial be numbers[1...4]  -- [1, 2, 3]
```

## Splicing

Replace a portion of an array by assigning to a slice:

```
numbers[2..4] be [///a///; ///b///; ///c///]
-- numbers is now [0, 1, "a", "b", "c", 5, 6]
```

## Destructuring

Extract values from arrays into variables:

```
const weather be [///Sunny///; ///Rainy///]
const [today; tomorrow] be weather

-- Swap variables
[today; tomorrow] be [tomorrow; today]
```

### Object destructuring

Use `object[...]` to destructure properties from an object:

```
const config be [host be ///localhost///, port be 8080]
const object[host; port] be config
```

Compiles to:

```js
const config = { host: "localhost", port: 8080 };
const { host, port } = config;
```

## Logical

```
a and b    -- a && b
a or b     -- a || b
not x      -- !x
```

## Nullish Coalescing

The `coal` operator returns the right-hand side when the left-hand side is `null` or `undefined`:

```
a coal b           -- a ?? b
a coal b coal c    -- a ?? b ?? c
```

Compiles to:

```js
a ?? b;
a ?? b ?? c;
```

This is different from `or`: `or` treats all falsy values (`false`, `0`, `""`, `null`, `undefined`) as false, while `coal` only treats `null` and `undefined` as "empty". Use `coal` when you want to preserve values like `0`, `false`, or `""`.

```
const port be config.port coal 3000      -- uses 3000 only if port is null/undefined
const name be user.name coal ///guest///  -- uses "guest" only if name is null/undefined
```

## Type Checks

`eq` and `is` both work for type checks when followed by a type name.

```
x is string          -- typeof x === "string"
x eq string          -- typeof x === "string"
x is null            -- x === null
x is MyClass         -- x instanceof MyClass
x instanceof Y       -- x instanceof Y
typeof x             -- typeof x
```
