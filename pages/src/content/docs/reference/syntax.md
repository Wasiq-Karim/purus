---
title: Syntax Overview
description: Overview of Purus syntax.
sidebar:
  order: 1
---

## File Extensions

| Extension | Output | Description |
|---|---|---|
| `.purus` | `.js` | Standard JavaScript |
| `.cpurus` | `.cjs` | CommonJS module |
| `.mpurus` | `.mjs` | ES Module |

## Comments

```
-- This is a line comment

--- This is a
block comment ---
```

## Strings

Strings use triple slashes `///`:

```
const greeting be ///Hello, World///
```

### Escape sequences

| Escape | Result |
|---|---|
| `\n` | Newline |
| `\t` | Tab |
| `\\` | Backslash |
| `\/` | `/` |
| `\[` | `[` (literal bracket) |
| `\]` | `]` (literal bracket) |

### String interpolation

Use `[expr]` inside a string to embed expressions:

```
const name be ///Alice///
const age be 30
const msg be ///Hello, [name]! You are [age] years old.///
```

Compiles to:

```js
const name = "Alice";
const age = 30;
const msg = `Hello, ${name}! You are ${age} years old.`;
```

You can use any expression inside the brackets:

```
const x be 10
const result be ///[x] times 2 is [x mul 2]///
```

Compiles to:

```js
const x = 10;
const result = `${x} times 2 is ${x * 2}`;
```

To include a literal `[` or `]` in a string, use the escape sequences `\[` and `\]`.

## Numbers

```
const i be 42
const f be 3.14
```

## Booleans and null

```
const a be true
const b be false
const c be null
const d be nil       -- alias for null
const e be undefined
```

## Arrays

```
const arr be [1, 2, 3]
const arr2 be [1; 2; 3]   -- semicolons also work
const empty be []
```

### Array ranges

```
const inclusive be [0..5]   -- [0, 1, 2, 3, 4, 5]
const exclusive be [0...5]  -- [0, 1, 2, 3, 4]
```

### Slicing

Extract a portion of an array using `..` (inclusive) or `...` (exclusive):

```
const numbers be [0, 1, 2, 3, 4, 5, 6]
const middle be numbers[2..4]    -- [2, 3, 4]
const partial be numbers[1...4]  -- [1, 2, 3]
```

Compiles to:

```js
const middle = numbers.slice(2, 4 + 1);
const partial = numbers.slice(1, 4);
```

### Splicing

Replace a portion of an array by assigning to a slice:

```
numbers[2..4] be [///a///; ///b///; ///c///]
-- numbers is now [0, 1, "a", "b", "c", 5, 6]
```

Compiles to:

```js
numbers.splice(2, 4 - 2 + 1, "a", "b", "c");
```

### Destructuring

Extract values from arrays into variables:

```
const weather be [///Sunny///; ///Rainy///]
const [today; tomorrow] be weather

-- Swap variables
[today; tomorrow] be [tomorrow; today]
```

Compiles to:

```js
const [today, tomorrow] = weather;
[today, tomorrow] = [tomorrow, today];
```

## Objects

```
const obj be [name be ///Alice///, age be 30]
const empty-obj be [be]    -- empty object
```

### Object destructuring

Use `object[...]` to destructure properties from an object:

```
const person be [name be ///Alice///, age be 30]
const object[name; age] be person
```

Compiles to:

```js
const person = { name: "Alice", age: 30 };
const { name, age } = person;
```

## Brackets only

Purus uses `[]` for everything — function calls, arrays, objects, and grouping. No `()` or `{}`.

## Indentation

Blocks are defined by indentation (2 spaces recommended):

```
if x gt 0
  console.log[///positive///]
else
  console.log[///non-positive///]
```

## Identifiers

Identifiers can contain hyphens (`-`) and underscores (`_`), which are both converted to underscores in JavaScript output:

```
const my-variable be 42
-- compiles to: const my_variable = 42;

const my_variable2 be 43
-- compiles to: const my_variable2 = 43;
```

Hyphens and underscores are interchangeable — `my-var` and `my_var` refer to the same JavaScript variable (`my_var`). If you need to work with JS libraries that use underscores, you can use either form in Purus.

:::caution
Since `a-b` and `a_b` both compile to `a_b`, avoid defining both forms in the same scope. They will refer to the same variable.
:::
