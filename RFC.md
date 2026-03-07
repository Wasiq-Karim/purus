# Purus Language Specification

**RFC — v0.6.1**

> Purus — _/ˈpuː.rus/_ — means _pure_ in Latin.
> A beautiful, simple, and easy-to-use language that compiles to JavaScript.
> **Write code without the Shift key.**

---

## Table of Contents

1. [Design Principles](#1-design-principles)
2. [File Extensions](#2-file-extensions)
3. [Lexical Structure](#3-lexical-structure)
   - 3.1 [Comments](#31-comments)
   - 3.2 [Identifiers](#32-identifiers)
   - 3.3 [Reserved Keywords](#33-reserved-keywords)
   - 3.4 [Literals](#34-literals)
   - 3.5 [Punctuation](#35-punctuation)
   - 3.6 [Shebang](#36-shebang)
4. [Types and Literals](#4-types-and-literals)
   - 4.1 [Numbers](#41-numbers)
   - 4.2 [Strings](#42-strings)
   - 4.3 [String Interpolation](#43-string-interpolation)
   - 4.4 [Booleans](#44-booleans)
   - 4.5 [Null Family](#45-null-family)
   - 4.6 [Regular Expressions](#46-regular-expressions)
   - 4.7 [Arrays](#47-arrays)
   - 4.8 [Objects](#48-objects)
5. [Operators](#5-operators)
   - 5.1 [Operator Precedence](#51-operator-precedence)
   - 5.2 [Arithmetic](#52-arithmetic)
   - 5.3 [Comparison](#53-comparison)
   - 5.4 [Logical](#54-logical)
   - 5.5 [Nullish Coalescing](#55-nullish-coalescing)
   - 5.6 [Pipeline](#56-pipeline)
   - 5.7 [Optional Chaining](#57-optional-chaining)
   - 5.8 [Type Check and Cast](#58-type-check-and-cast)
6. [Declarations](#6-declarations)
   - 6.1 [Variable Declaration](#61-variable-declaration)
   - 6.2 [Array Destructuring](#62-array-destructuring)
   - 6.3 [Object Destructuring](#63-object-destructuring)
   - 6.4 [Assignment](#64-assignment)
   - 6.5 [Type Alias](#65-type-alias)
7. [Functions](#7-functions)
   - 7.1 [Named Functions](#71-named-functions)
   - 7.2 [No-Argument Functions](#72-no-argument-functions)
   - 7.3 [Multiple Parameters](#73-multiple-parameters)
   - 7.4 [Expression Body](#74-expression-body)
   - 7.5 [Anonymous Functions](#75-anonymous-functions)
   - 7.6 [Async Functions](#76-async-functions)
   - 7.7 [Function Calls](#77-function-calls)
   - 7.8 [Computed Access](#78-computed-access)
   - 7.9 [Async Function Expressions](#79-async-function-expressions)
   - 7.10 [Inline Callbacks](#710-inline-callbacks)
   - 7.11 [Type Annotations](#711-type-annotations)
8. [Control Flow](#8-control-flow)
   - 8.1 [If / Elif / Else](#81-if--elif--else)
   - 8.2 [Unless](#82-unless)
   - 8.3 [Inline If (Ternary)](#83-inline-if-ternary)
   - 8.4 [Postfix Modifiers](#84-postfix-modifiers)
   - 8.5 [While / Until](#85-while--until)
   - 8.6 [For-in](#86-for-in)
   - 8.7 [For-range](#87-for-range)
   - 8.8 [Match / When](#88-match--when)
   - 8.9 [Break / Continue / Return](#89-break--continue--return)
9. [Error Handling](#9-error-handling)
   - 9.1 [Try / Catch / Finally](#91-try--catch--finally)
   - 9.2 [Try as Expression](#92-try-as-expression)
   - 9.3 [Throw](#93-throw)
10. [Modules](#10-modules)
    - 10.1 [ESM Import](#101-esm-import)
    - 10.2 [Use (Dot-path Import)](#102-use-dot-path-import)
    - 10.3 [Export / Pub](#103-export--pub)
    - 10.4 [Namespace](#104-namespace)
    - 10.5 [Side-Effect Import](#105-side-effect-import)
    - 10.6 [CommonJS](#106-commonjs)
    - 10.7 [Dynamic Import](#107-dynamic-import)
11. [Array Operations](#11-array-operations)
    - 11.1 [Ranges](#111-ranges)
    - 11.2 [Slicing](#112-slicing)
    - 11.3 [Splicing](#113-splicing)
12. [Multi-line Brackets](#12-multi-line-brackets)
13. [Indentation and Block Structure](#13-indentation-and-block-structure)
14. [Code Generation](#14-code-generation)
    - 14.1 [Identifier Mapping](#141-identifier-mapping)
    - 14.2 [Type Erasure](#142-type-erasure)
    - 14.3 [Strict Mode](#143-strict-mode)
    - 14.4 [Private Fields](#144-private-fields)
15. [Classes](#15-classes)
    - 15.1 [Class Declaration](#151-class-declaration)
    - 15.2 [Constructor](#152-constructor)
    - 15.3 [Methods](#153-methods)
    - 15.4 [Static Methods](#154-static-methods)
    - 15.5 [Async Methods](#155-async-methods)
    - 15.6 [Getters and Setters](#156-getters-and-setters)
    - 15.7 [Inheritance](#157-inheritance)
    - 15.8 [Private Fields](#158-private-fields)
16. [Keyword Reference Table](#16-keyword-reference-table)
17. [Grammar Summary (EBNF-like)](#17-grammar-summary-ebnf-like)

---

## 1. Design Principles

Purus is designed with the following principles:

- **No Shift key required.** Most syntax uses lowercase keywords and `[]` brackets. No `()`, `{}`, `<>`, `!`, `@`, `#`, `$`, `%`, `^`, `&`, `*`, `+`, `=`, `|`, `:`, `"`, `'`, `?` required in Purus source.
- **Brackets only.** `[]` is the universal bracket — used for function calls, arrays, objects, grouping, and destructuring.
- **Keyword-based operators.** All operators are English words: `add`, `sub`, `eq`, `and`, `or`, etc.
- **Indentation-based blocks.** No braces. Blocks are delimited by indentation (2 spaces recommended).
- **Clean JavaScript output.** Compiles to readable, idiomatic JavaScript.
- **US/JIS keyboard layout friendly.** The entire language can be typed without modifier keys besides Shift for uppercase (which is also rarely needed).

---

## 2. File Extensions

| Extension | JS Output | Description |
|-----------|-----------|-------------|
| `.purus`  | `.js`     | Standard JavaScript |
| `.cpurus` | `.cjs`    | CommonJS module |
| `.mpurus` | `.mjs`    | ES Module |

---

## 3. Lexical Structure

### 3.1 Comments

**Line comment** — starts with `--`, extends to end of line:

```
-- this is a comment
```

**Block comment** — enclosed in `---`:

```
--- this is a
block comment ---
```

### 3.2 Identifiers

Identifiers start with a letter (`a`-`z`, `A`-`Z`) or underscore (`_`), followed by any combination of letters, digits (`0`-`9`), hyphens (`-`), and underscores (`_`).

```
valid-name
my_var
_private
camelCase
data-2
```

**Identifier normalization:** Both hyphens and underscores map to `_` in the JavaScript output. Therefore `my-var` and `my_var` reference the same JavaScript identifier `my_var`.

> **Caution:** Do not define both `my-var` and `my_var` in the same scope. They will alias to the same JavaScript variable.

### 3.3 Reserved Keywords

The following words are reserved and cannot be used as identifiers:

**Declaration:** `const`, `let`, `var`, `be`

**Function:** `fn`, `return`, `to`, `gives`, `async`, `await`

**Control:** `if`, `elif`, `else`, `unless`, `then`, `while`, `until`, `for`, `in`, `range`, `break`, `continue`, `match`, `when`

**Operator:** `add`, `sub`, `mul`, `div`, `mod`, `pow`, `neg`, `eq`, `neq`, `lt`, `gt`, `le`, `ge`, `and`, `or`, `not`, `coal`, `pipe`

**Type:** `is`, `as`, `of`, `typeof`, `instanceof`, `type`

**Module:** `import`, `from`, `export`, `default`, `require`, `use`, `namespace`, `pub`, `all`

**Value:** `true`, `false`, `null`, `nil`, `undefined`

**Constructor:** `list`, `object`

**Error handling:** `try`, `catch`, `finally`, `throw`

**Class:** `class`, `extends`, `super`, `static`, `private`, `get`, `set`

**Other:** `new`, `delete`, `this`

### 3.4 Literals

| Type | Syntax | Example |
|------|--------|---------|
| Integer | Decimal digits | `42`, `-3` |
| Float | Digits with `.` | `3.14`, `-0.5` |
| String | `///` delimiters | `///hello///` |
| Interpolated string | `///...[expr]...///` | `///Hello, [name]!///` |
| Regex | `/pattern/flags` | `/[a-z]+/gi` |
| Boolean | `true` / `false` | `true` |
| Null | `null` / `nil` | `null` |
| Undefined | `undefined` | `undefined` |

**Negative number literals** are recognized after these tokens: `[`, `,`, `;`, `be`, `\`, newline, indent, `return`, `to`, `then`, `coal`.

### 3.5 Punctuation

| Symbol | Name | Role |
|--------|------|------|
| `[` | Left bracket | Call, array, object, grouping, destructuring |
| `]` | Right bracket | Closing bracket |
| `,` | Comma | Separator (arrays, objects) |
| `;` | Semicolon | Separator (function args, params, destructuring) |
| `.` | Dot | Property access |
| `\.` | Optional dot | Optional chaining (`?.`) |
| `\` | Backslash | Computed access prefix (`[...]`) |
| `..` | Double dot | Inclusive range |
| `...` | Triple dot | Exclusive range |

### 3.6 Shebang

A `#!` line at the beginning of a file is recognized and preserved:

```
#!/usr/bin/env node
const message be ///Hello///
```

---

## 4. Types and Literals

### 4.1 Numbers

```
const i be 42      -- integer
const f be 3.14    -- float
const n be -7      -- negative integer
```

### 4.2 Strings

Strings are delimited by triple slashes `///`:

```
const greeting be ///Hello, World///
```

Compiles to:

```js
const greeting = "Hello, World";
```

**Escape sequences:**

| Escape | Result |
|--------|--------|
| `\n` | Newline |
| `\t` | Tab |
| `\\` | Backslash |
| `\/` | `/` |
| `\[` | `[` (literal bracket, prevents interpolation) |
| `\]` | `]` (literal bracket) |

### 4.3 String Interpolation

Embed expressions inside strings using `[expr]`:

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

Any valid Purus expression can appear inside brackets:

```
const result be ///[x] times 2 is [x mul 2]///
```

Nested brackets are correctly handled — the lexer tracks bracket depth:

```
const msg be ///first: [arr[0]]///
```

To include a literal `[` or `]` in a string, use `\[` and `\]`.

When a string contains no interpolated expressions, it is compiled to a regular JS string (`"..."`). When interpolation is present, it is compiled to a template literal (`` `...` ``).

### 4.4 Booleans

```
const a be true
const b be false
```

### 4.5 Null Family

```
const a be null
const b be nil         -- alias for null
const c be undefined
```

Both `null` and `nil` compile to JavaScript `null`.

### 4.6 Regular Expressions

Regex literals use `/pattern/flags` syntax:

```
const pattern be /[a-z]+/gi
```

Supported flags: `g`, `i`, `m`, `s`, `u`, `y`.

### 4.7 Arrays

**Explicit array:**

```
const arr be [1, 2, 3]
const arr2 be [1; 2; 3]     -- semicolons also work
const empty be []
```

**Explicit constructor:** `list[...]` is identical to `[...]`:

```
const items be list[1; 2; 3]
```

**Range arrays:** See [Section 11.1](#111-ranges).

### 4.8 Objects

**Bracket syntax:**

```
const obj be [name be ///Alice///, age be 30]
const empty-obj be [be]    -- empty object
```

**Explicit constructor:** `object[...]`:

```
const person be object[name be ///Alice///, age be 30]
```

**Shorthand properties:**

```
const x be 10
const y be 20
const point be object[x, y]
-- compiles to: { x, y }
```

Compiles to:

```js
const obj = { name: "Alice", age: 30 };
const emptyObj = {};
const person = { name: "Alice", age: 30 };
const point = { x, y };
```

---

## 5. Operators

### 5.1 Operator Precedence

From lowest to highest:

| Level | Operator(s) | Description |
|-------|-------------|-------------|
| 1 | `pipe` | Pipeline |
| 2 | `coal` | Nullish coalescing |
| 3 | `or` | Logical OR |
| 4 | `and` | Logical AND |
| 5 | `eq` / `neq` / `not eq` / `is` / `instanceof` | Equality / Type check |
| 6 | `lt` / `gt` / `le` (`lt eq`) / `ge` (`gt eq`) | Comparison |
| 7 | `add` / `sub` | Addition / Subtraction |
| 8 | `mul` / `div` / `mod` | Multiplication / Division / Modulo |
| 9 | `pow` | Exponentiation (right-associative) |
| 10 | `not` / `neg` / `typeof` / `await` / `delete` / `new` | Unary |
| 11 | `.` access / `\.` optional / `[args]` call / `[\expr]` access / `as` cast | Postfix |
| 12 | Literals, identifiers, brackets | Primary |

### 5.2 Arithmetic

| Purus | JS | Description |
|-------|----|-------------|
| `a add b` | `a + b` | Addition |
| `a sub b` | `a - b` | Subtraction |
| `a mul b` | `a * b` | Multiplication |
| `a div b` | `a / b` | Division |
| `a mod b` | `a % b` | Modulo |
| `a pow b` | `a ** b` | Exponentiation |
| `neg x` | `-x` | Unary negation |

`pow` is **right-associative**: `a pow b pow c` → `a ** (b ** c)`.

### 5.3 Comparison

| Purus | JS | Description |
|-------|----|-------------|
| `a eq b` | `a === b` | Strict equality |
| `a neq b` | `a !== b` | Strict inequality |
| `a not eq b` | `a !== b` | Alternative inequality |
| `a lt b` | `a < b` | Less than |
| `a gt b` | `a > b` | Greater than |
| `a le b` | `a <= b` | Less than or equal |
| `a lt eq b` | `a <= b` | Alternative LE |
| `a ge b` | `a >= b` | Greater than or equal |
| `a gt eq b` | `a >= b` | Alternative GE |

**Note:** `eq` and `is` are interchangeable. When followed by a type name, they become a type check (see [5.7](#57-type-check-and-cast)). Otherwise, they compile to `===`.

**Note:** `not eq` is an alias for `neq`, `lt eq` is an alias for `le`, and `gt eq` is an alias for `ge`. Both forms compile to the same JavaScript output.

### 5.4 Logical

| Purus | JS | Description |
|-------|----|-------------|
| `a and b` | `a && b` | Logical AND |
| `a or b` | `a \|\| b` | Logical OR |
| `not x` | `!x` | Logical NOT |

### 5.5 Nullish Coalescing

The `coal` operator returns the right-hand side when the left-hand side is `null` or `undefined`:

| Purus | JS |
|-------|----|
| `a coal b` | `a ?? b` |
| `a coal b coal c` | `a ?? b ?? c` |

Unlike `or`, which treats all falsy values (`false`, `0`, `""`) as false, `coal` only treats `null` and `undefined` as "empty":

```
const port be config.port coal 3000
-- uses 3000 only if port is null/undefined; 0 would be preserved
```

### 5.6 Pipeline

The `pipe` operator passes the left operand as the first argument to the right operand:

```
data pipe filter                     -- filter(data)
data pipe filter pipe map            -- map(filter(data))
data pipe transform[extra-arg]       -- transform(data, extraArg)
data pipe .method[arg]               -- data.method(arg)
```

Compilation rules:
- `a pipe f` → `f(a)`
- `a pipe f[x; y]` → `f(a, x, y)` (prepends `a` as first argument)
- `a pipe .method[x]` → `a.method(x)` (method call on `a`)

### 5.7 Optional Chaining

The `\.` operator provides safe property access on potentially null/undefined values. It compiles to JavaScript's optional chaining operator `?.`:

```
const name be user\.profile\.name
const result be obj\.method[arg]
```

```js
const name = user?.profile?.name;
const result = obj?.method(arg);
```

`\.` can be used for:
- **Property access:** `obj\.prop` → `obj?.prop`
- **Method calls:** `obj\.method[args]` → `obj?.method(args)`

Combine with `coal` for default values:

```
const display be user\.name coal ///anonymous///
```

### 5.8 Type Check and Cast

**Type check with `is` / `eq`:**

When `is` or `eq` is followed by a type name, it becomes a type check:

| Purus | JS |
|-------|----|
| `x is string` | `typeof x === "string"` |
| `x is number` | `typeof x === "number"` |
| `x is null` | `x === null` |
| `x is MyClass` | `x instanceof MyClass` |
| `x instanceof Y` | `x instanceof Y` |
| `typeof x` | `typeof x` |

Primitive type names: `string`, `number`, `boolean`, `undefined`, `function`, `symbol`, `bigint`, `null`, `object`.

Capitalized names are treated as class constructors and use `instanceof`.

**Type cast with `as`:**

```
x as number    -- erased in JS output (passes through x)
```

---

## 6. Declarations

### 6.1 Variable Declaration

```
const x be 42          -- const x = 42;
let y be 10            -- let y = 10;
var z be 0             -- var z = 0;  (discouraged)
```

Optional type annotation with `of` (erased in JS):

```
const x of Number be 42
```

### 6.2 Array Destructuring

```
const [a; b; c] be arr
let [first; second] be list[1; 2]
```

Compiles to:

```js
const [a, b, c] = arr;
let [first, second] = [1, 2];
```

Variable swap:

```
[a; b] be [b; a]
```

### 6.3 Object Destructuring

Use `object[...]` before `be`:

```
const object[name; age] be person
let object[host; port] be config
```

Compiles to:

```js
const { name, age } = person;
let { host, port } = config;
```

### 6.4 Assignment

Non-declaration assignment uses `be` without a declaration keyword:

```
x be 42
obj.field be ///new value///
```

Compiles to:

```js
x = 42;
obj.field = "new value";
```

### 6.5 Type Alias

```
type UserId be Number
```

Type aliases are erased in JavaScript output.

---

## 7. Functions

### 7.1 Named Functions

**Block body:**

```
fn greet name
  console.log[name]
```

```js
function greet(name) {
  console.log(name);
}
```

### 7.2 No-Argument Functions

Simply omit the parameter list:

```
fn say-hello
  console.log[///Hello!///]
```

```js
function sayHello() {
  console.log("Hello!");
}
```

With expression body:

```
fn get-timestamp to Date.now[]
```

```js
function getTimestamp() { return Date.now(); }
```

### 7.3 Multiple Parameters

Use `;` to separate parameters:

```
fn add a; b
  return a add b
```

```js
function add(a, b) {
  return a + b;
}
```

### 7.4 Expression Body

Use `to` for single-expression functions:

```
fn double x to x mul 2
```

```js
function double(x) { return x * 2; }
```

### 7.5 Anonymous Functions

**Arrow expression:**

```
const double be fn x to x mul 2
```

```js
const double = (x) => x * 2;
```

**Arrow with no arguments:**

```
const get-time be fn to Date.now[]
```

```js
const getTime = () => Date.now();
```

**Arrow with block body:**

```
const process be fn data
  console.log[data]
  return data
```

```js
const process = (data) => {
  console.log(data);
  return data;
};
```

### 7.6 Async Functions

```
async fn fetch-data url
  const res be await fetch[url]
  return res
```

```js
async function fetchData(url) {
  const res = await fetch(url);
  return res;
}
```

### 7.7 Function Calls

Use `[]` instead of `()`:

```
greet[///world///]        -- greet("world")
add[1; 2]                -- add(1, 2)
console.log[///hello///]  -- console.log("hello")
```

**Nested calls:** Use `;` to separate arguments to distinguish from nested function calls:

```
a[b[c]; d]               -- a(b(c), d)
outer[inner1[x]; inner2[y; z]]  -- outer(inner1(x), inner2(y, z))
```

### 7.8 Computed Access

To access array elements or object properties with a computed key, use `\` inside brackets to distinguish from function calls:

```
const item be arr[\index]
const value be obj[\key]
const first be arr[\0]
```

```js
const item = arr[index];
const value = obj[key];
const first = arr[0];
```

Without the `\` prefix, brackets are interpreted as a function call: `arr[index]` → `arr(index)`.

### 7.9 Async Function Expressions

Async anonymous functions can be used as expressions:

**Expression body:**

```
const fetch-data be async fn url to await fetch[url]
```

```js
const fetchData = async (url) => await fetch(url);
```

**Block body:**

```
const process be async fn data
  const result be await transform[data]
  return result
```

```js
const process = async (data) => {
  const result = await transform(data);
  return result;
};
```

### 7.10 Inline Callbacks

Anonymous functions (including async) can be passed directly as arguments in function calls, enabling method chaining with callbacks:

```
promise.then[fn result
  console.log[result]
].catch[fn err
  console.error[err]
]
```

```js
promise.then((result) => {
  console.log(result);
}).catch((err) => {
  console.error(err);
});
```

With multi-line brackets, complex callback patterns become natural:

```
app.get[///path///; async fn req; res
  const data be await fetch-data[]
  res.json[data]
]
```

### 7.11 Type Annotations

Type annotations are erased in JavaScript:

```
fn add a of Number; b of Number gives Number to a add b
```

- `of Type` — parameter type annotation
- `gives Type` — return type annotation

---

## 8. Control Flow

### 8.1 If / Elif / Else

```
if x lt 0
  console.log[///negative///]
elif x eq 0
  console.log[///zero///]
else
  console.log[///positive///]
```

`else if` is also accepted as an alternative to `elif`.

### 8.2 Unless

Negated conditional:

```
unless done
  keep-going[]
```

```js
if (!(done)) {
  keepGoing();
}
```

### 8.3 Inline If (Ternary)

```
const result be if condition then 1 else 2
```

```js
const result = condition ? 1 : 2;
```

### 8.4 Postfix Modifiers

Statements can have postfix `if`, `unless`, or `for`:

```
console.log[///debug///] if verbose
console.log[///skip///] unless done
console.log[item] for item in list
```

```js
if (verbose) console.log("debug");
if (!(done)) console.log("skip");
for (const item of list) console.log(item);
```

### 8.5 While / Until

```
while i lt 10
  i be i add 1

until finished
  do-work[]
```

`until COND` compiles to `while (!(COND))`.

### 8.6 For-in

**Basic iteration:**

```
for item in items
  console.log[item]
```

```js
for (const item of items) {
  console.log(item);
}
```

**With index:**

```
for i; item in items
  console.log[i; item]
```

```js
for (let [i, item] of items.entries()) {
  console.log(i, item);
}
```

### 8.7 For-range

```
for i in range 0; 10
  console.log[i]
```

```js
for (let i = 0; i < 10; i++) {
  console.log(i);
}
```

### 8.8 Match / When

**Statement form:**

```
match x
  when 1 then ///one///
  when 2 then ///two///
  else ///other///
```

**Block body in arms:**

```
match value
  when n if n gt 0
    console.log[///positive///]
  else
    console.log[///non-positive///]
```

**Expression form** (compiled to IIFE):

```
const label be match status
  when 200 then ///ok///
  when 404 then ///not found///
  else ///unknown///
```

Match arms support:
- **Literal patterns:** `when 1`, `when ///hello///`, `when true`
- **Binding patterns:** `when n` (binds the value to `n`)
- **Wildcard:** `else` (default arm, matches anything)
- **Guards:** `when n if n gt 0` (additional condition)
- **Body:** `then EXPR` (expression) or indented block

### 8.9 Break / Continue / Return

```
break
continue
return
return value
```

---

## 9. Error Handling

### 9.1 Try / Catch / Finally

```
try
  risky[]
catch e
  console.log[e]
finally
  cleanup[]
```

The catch variable name is optional; defaults to `e` if omitted.

### 9.2 Try as Expression

```
const result be try
  risky[]
catch e
  default-value
```

Compiles to an IIFE with try/catch.

### 9.3 Throw

```
throw new Error[///something went wrong///]
throw err if condition    -- postfix if
```

---

## 10. Modules

### 10.1 ESM Import

```
import express from ///express///
import [useState; useEffect] from ///react///
import React, [Component] from ///react///
import all as fs from ///fs///
```

```js
import express from "express";
import { useState, useEffect } from "react";
import React, { Component } from "react";
import * as fs from "fs";
```

### 10.2 Use (Dot-path Import)

```
use std.math
from std.math use sin, cos
```

```js
import * as math from "std/math";
import { sin, cos } from "std/math";
```

Dots in the path are converted to `/` in the import.

### 10.3 Export / Pub

```
pub fn helper to 42
pub const VERSION be ///1.0///
export default fn main
  console.log[///hi///]
```

```js
export function helper() { return 42; }
export const VERSION = "1.0";
export default function main() {
  console.log("hi");
}
```

### 10.4 Namespace

```
namespace utils
  fn helper to 42
```

```js
const utils = (() => {
  function helper() { return 42; }
})();
```

Compiles to an IIFE (Immediately Invoked Function Expression).

### 10.5 Side-Effect Import

Import a module purely for its side effects (e.g., polyfills, configuration):

```
import ///dotenv/config///
import ///./setup///
```

```js
import "dotenv/config";
import "./setup";
```

No bindings are introduced — the module is simply executed.

### 10.6 CommonJS

```
const fs be require[///fs///]
```

```js
const fs = require("fs");
```

### 10.7 Dynamic Import

Dynamic imports are supported through standard function call syntax:

```
const mod be await import[///./module.js///]
```

---

## 11. Array Operations

### 11.1 Ranges

Generate arrays from numeric ranges:

```
const inclusive be [0..5]     -- [0, 1, 2, 3, 4, 5]
const exclusive be [0...5]   -- [0, 1, 2, 3, 4]
```

Compiles to `Array.from`:

```js
const inclusive = Array.from({ length: 5 - 0 + 1 }, (_, i) => i + 0);
const exclusive = Array.from({ length: 5 - 0 }, (_, i) => i + 0);
```

- `..` — inclusive (both start and end included)
- `...` — exclusive (end excluded)

### 11.2 Slicing

Extract a portion of an array:

```
const middle be numbers[\2..4]     -- numbers.slice(2, 5)  — inclusive
const partial be numbers[\1...4]   -- numbers.slice(1, 4)  — exclusive
```

### 11.3 Splicing

Assign to a slice to replace elements:

```
numbers[\2..4] be [///a///; ///b///; ///c///]
```

```js
numbers.splice(2, 4 - 2 + 1, "a", "b", "c");
```

---

## 12. Multi-line Brackets

Bracket expressions (function calls, arrays, objects) can span multiple lines. Newlines, indentation, and comments inside brackets are treated as whitespace:

**Multi-line array:**

```
const items be [
  ///apple///,
  ///banana///,
  ///cherry///
]
```

**Multi-line function call:**

```
server.listen[
  port;
  fn to console.log[///started///]
]
```

**Multi-line object:**

```
const config be object[
  host be ///localhost///,
  port be 3000,
  debug be true
]
```

This enables naturally readable code for complex data structures and function calls with multiple arguments or inline callbacks.

---

## 13. Indentation and Block Structure

Purus uses **indentation-based block structure** (off-side rule):

- Blocks are introduced by keywords like `fn`, `if`, `else`, `elif`, `while`, `for`, `match`, `when`, `try`, `catch`, `finally`, `namespace`.
- The block body must be indented more than the introducing keyword.
- The block ends when indentation returns to the parent level.
- Recommended indentation: **2 spaces**.
- Tabs are treated as 2 spaces.

```
fn example x
  if x gt 0                -- block level 1
    console.log[///pos///] -- block level 2
  else
    console.log[///neg///] -- block level 2
```

---

## 14. Code Generation

### 14.1 Identifier Mapping

All hyphens in Purus identifiers are replaced with underscores in JavaScript output:

| Purus | JavaScript |
|-------|-----------|
| `my-variable` | `my_variable` |
| `my_variable` | `my_variable` |
| `get-user-name` | `get_user_name` |

### 14.2 Type Erasure

The following constructs are removed during code generation:
- `of Type` — parameter type annotations
- `gives Type` — return type annotations
- `as Type` — type casts (the expression value is preserved)
- `type Name be Type` — type alias declarations

### 14.3 Strict Mode

By default, the Purus compiler emits `"use strict";` at the top of every generated JavaScript file. This can be controlled via:

**CLI flag:**

```
purus build --strict true    -- enables strict mode (default)
purus build --strict false   -- disables strict mode
```

**Configuration file** (`config.purus`):

```
const strict be true         -- enables strict mode (default)
const strict be false        -- disables strict mode
```

When strict mode is enabled, the generated output begins with:

```js
"use strict";
```

The CLI flag takes precedence over the configuration file setting.

### 14.4 Private Fields

Inside a class body, fields declared with `private` are tracked by the compiler. When any dot access (e.g., `this.field-name`) references a private field name, the compiler automatically emits a `#` prefix in the JavaScript output:

| Purus | JavaScript |
|-------|-----------|
| `this.secret` (private) | `this.#secret` |
| `this.name` (public) | `this.name` |

This mapping is scoped to the enclosing class — private field names from one class do not affect another.

---

## 15. Classes

Purus supports JavaScript class declarations with an indentation-based syntax.

### 15.1 Class Declaration

```
class Animal
  fn new[name]
    this.name be name

  fn speak
    console.log[this.name]
```

```js
class Animal {
  constructor(name) {
    this.name = name;
  }
  speak() {
    console.log(this.name);
  }
}
```

### 15.2 Constructor

Constructors are declared with `fn new`. Parameters use `[]` brackets with `;` separators:

```
class Point
  fn new[x; y]
    this.x be x
    this.y be y
```

```js
class Point {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}
```

Expression body with `to`:

```
class Wrapper
  fn new[value] to this.value be value
```

```js
class Wrapper {
  constructor(value) { return this.value = value; }
}
```

### 15.3 Methods

Methods use the same `fn` syntax as regular functions:

```
class Calculator
  fn add a; b to a add b

  fn multiply a; b
    return a mul b
```

```js
class Calculator {
  add(a, b) { return a + b; }
  multiply(a, b) {
    return a * b;
  }
}
```

### 15.4 Static Methods

Prefix method declarations with `static`:

```
class MathUtils
  static fn square x to x mul x

  static fn cube x
    return x pow 3
```

```js
class MathUtils {
  static square(x) { return x * x; }
  static cube(x) {
    return x ** 3;
  }
}
```

### 15.5 Async Methods

Prefix method declarations with `async`:

```
class Api
  async fn fetch-data url
    const res be await fetch[url]
    return res.json[]
```

```js
class Api {
  async fetchData(url) {
    const res = await fetch(url);
    return res.json();
  }
}
```

Static async methods combine both prefixes:

```
class Service
  static async fn load to await fetch[///data///]
```

```js
class Service {
  static async load() { return await fetch("data"); }
}
```

### 15.6 Getters and Setters

Use `get fn` and `set fn` to declare accessors:

```
class Person
  fn new[name]
    this.internal-name be name

  get fn name to this.internal-name

  set fn name value
    this.internal-name be value
```

```js
class Person {
  constructor(name) {
    this.internal_name = name;
  }
  get name() { return this.internal_name; }
  set name(value) {
    this.internal_name = value;
  }
}
```

### 15.7 Inheritance

Use `extends` to inherit from a parent class. Use `super` to call the parent constructor or methods:

```
class Animal
  fn new[name]
    this.name be name

  fn speak
    console.log[this.name]

class Dog extends Animal
  fn new[name; breed]
    super[name]
    this.breed be breed

  fn speak
    super.speak[]
    console.log[///Woof!///]
```

```js
class Animal {
  constructor(name) {
    this.name = name;
  }
  speak() {
    console.log(this.name);
  }
}
class Dog extends Animal {
  constructor(name, breed) {
    super(name);
    this.breed = breed;
  }
  speak() {
    super.speak();
    console.log("Woof!");
  }
}
```

### 15.8 Private Fields

Use `private` to declare private fields. Private fields are prefixed with `#` in JavaScript output:

```
class Account
  private balance be 0

  fn new[initial]
    this.balance be initial

  fn deposit amount
    this.balance be this.balance add amount

  get fn balance to this.balance
```

```js
class Account {
  #balance = 0;
  constructor(initial) {
    this.#balance = initial;
  }
  deposit(amount) {
    this.#balance = this.#balance + amount;
  }
  get balance() { return this.#balance; }
}
```

Private fields without a default value:

```
class Secret
  private data
```

```js
class Secret {
  #data;
}
```

---

## 16. Keyword Reference Table

### Declaration

| Keyword | JS Output | Description |
|---------|-----------|-------------|
| `const` | `const` | Constant declaration |
| `let` | `let` | Variable declaration |
| `var` | `var` | Var declaration (discouraged) |
| `be` | `=` | Assignment operator |

### Functions

| Keyword | JS Output | Description |
|---------|-----------|-------------|
| `fn` | `function` / `=>` | Function declaration/expression |
| `return` | `return` | Return value |
| `to` | `=> expr` / `{ return expr; }` | Expression body |
| `gives` | _(erased)_ | Return type annotation |
| `async` | `async` | Async function modifier |
| `await` | `await` | Await expression |

### Conditional

| Keyword | JS Output | Description |
|---------|-----------|-------------|
| `if` | `if` | Conditional |
| `elif` | `else if` | Else-if branch |
| `else` | `else` | Else branch |
| `unless` | `if (!(...))` | Negated conditional |
| `then` | _(ternary)_ | Inline conditional |

### Loops

| Keyword | JS Output | Description |
|---------|-----------|-------------|
| `while` | `while` | While loop |
| `until` | `while (!(...))` | Negated while |
| `for` | `for` | For loop |
| `in` | `of` / `in` | Iterator keyword |
| `range` | _(numeric range)_ | Range-based loop |
| `break` | `break` | Break out of loop |
| `continue` | `continue` | Continue to next iteration |

### Pattern Matching

| Keyword | JS Output | Description |
|---------|-----------|-------------|
| `match` | if-else chain / IIFE | Match expression/statement |
| `when` | _(match arm)_ | Match case |

### Modules

| Keyword | JS Output | Description |
|---------|-----------|-------------|
| `import` | `import` | ESM import |
| `import ///mod///` | `import "mod"` | Side-effect import |
| `from` | `from` | Import source |
| `export` | `export` | ESM export |
| `default` | `default` | Default export |
| `require` | `require()` | CommonJS require |
| `use` | `import` | Dot-path import |
| `namespace` | IIFE | Module namespace |
| `pub` | `export` | Public export |
| `all` | `* as` | Namespace import |

### Arithmetic Operators

| Keyword | JS Output |
|---------|-----------|
| `add` | `+` |
| `sub` | `-` |
| `mul` | `*` |
| `div` | `/` |
| `mod` | `%` |
| `pow` | `**` |
| `neg` | `-` (unary) |

### Comparison Operators

| Keyword | JS Output |
|---------|-----------|
| `eq` | `===` |
| `neq` / `not eq` | `!==` |
| `lt` | `<` |
| `gt` | `>` |
| `le` / `lt eq` | `<=` |
| `ge` / `gt eq` | `>=` |

### Logical Operators

| Keyword | JS Output |
|---------|-----------|
| `and` | `&&` |
| `or` | `\|\|` |
| `not` | `!` |

### Nullish Coalescing

| Keyword | JS Output |
|---------|-----------|
| `coal` | `??` |

### Pipeline

| Keyword | JS Output |
|---------|-----------|
| `pipe` | `f(a)` |

### Type Keywords

| Keyword | JS Output | Description |
|---------|-----------|-------------|
| `is` | `typeof` / `instanceof` | Type check |
| `as` | _(erased)_ | Type cast |
| `of` | _(erased)_ | Type annotation |
| `typeof` | `typeof` | Typeof operator |
| `instanceof` | `instanceof` | Instance check |
| `type` | _(erased)_ | Type alias |

### Class

| Keyword | JS Output | Description |
|---------|-----------|-------------|
| `class` | `class` | Class declaration |
| `extends` | `extends` | Class inheritance |
| `super` | `super` | Parent class reference |
| `static` | `static` | Static method modifier |
| `private` | `#` (prefix) | Private field declaration |
| `get` | `get` | Getter accessor |
| `set` | `set` | Setter accessor |

### Other

| Keyword | JS Output | Description |
|---------|-----------|-------------|
| `new` | `new` | Constructor |
| `delete` | `delete` | Delete property |
| `this` | `this` | This reference |
| `throw` | `throw` | Throw exception |
| `try` | `try` | Try block |
| `catch` | `catch` | Catch block |
| `finally` | `finally` | Finally block |
| `list` | `[…]` | Array literal |
| `object` | `{…}` | Object literal |
| `null` | `null` | Null value |
| `nil` | `null` | Null alias |
| `undefined` | `undefined` | Undefined value |

### Punctuation

| Symbol | JS Output | Description |
|--------|-----------|-------------|
| `\.` | `?.` | Optional chaining |
| `\` | _(computed prefix)_ | Computed access marker |
| `.` | `.` | Property access |
| `..` | _(inclusive range)_ | Inclusive range |
| `...` | _(exclusive range)_ | Exclusive range |

---

## 17. Grammar Summary (EBNF-like)

```ebnf
Program       = { Statement } ;

Statement     = VarDecl | FnDecl | ClassDecl | IfStmt | UnlessStmt
              | WhileStmt | UntilStmt | ForStmt | MatchStmt
              | TryCatch | Throw | Return | Break | Continue
              | ImportDecl | UseDecl | ModDecl | ExportDecl | PubDecl
              | TypeDecl | DeleteStmt
              | Expr "be" Expr              (* assignment *)
              | Expr                         (* expression statement *)
              ;

VarDecl       = ("const" | "let" | "var")
                ( "object" "[" IdentList "]" "be" Expr   (* object destructuring *)
                | "[" IdentList "]" "be" Expr            (* array destructuring *)
                | Ident ["of" Type] "be" Expr            (* simple binding *)
                )
                [PostfixMod] ;

IdentList     = Ident { (";" | ",") Ident } ;

FnDecl        = ["async"] "fn" [Ident] ParamList ["gives" Type]
                ( "to" Expr | INDENT Block DEDENT ) ;

ParamList     = { Ident ["of" Type] ";" } [Ident ["of" Type]] ;

IfStmt        = "if" Expr (INDENT Block DEDENT | "then" Expr "else" Expr)
                { ("elif" | "else" "if") Expr INDENT Block DEDENT }
                [ "else" INDENT Block DEDENT ] ;

UnlessStmt    = "unless" Expr INDENT Block DEDENT ;

WhileStmt     = "while" Expr INDENT Block DEDENT ;

UntilStmt     = "until" Expr INDENT Block DEDENT ;

ForStmt       = "for" Ident [";" Ident] "in"
                ( "range" Primary ";" Primary
                | Expr
                ) INDENT Block DEDENT ;

MatchStmt     = "match" Expr INDENT { MatchArm } DEDENT ;

MatchArm      = "when" Pattern ["if" Expr]
                ( "then" Expr | INDENT Block DEDENT )
              | "else" ( Expr | INDENT Block DEDENT )
              ;

Pattern       = IntLit | FloatLit | StrLit | BoolLit | "null" | "nil" | Ident ;

TryCatch      = "try" INDENT Block DEDENT
                "catch" [Ident] INDENT Block DEDENT
                ["finally" INDENT Block DEDENT] ;

ImportDecl    = "import" String                          (* side-effect import *)
              | "import" ("all" "as" Ident | "[" IdentList "]" | Ident ["," "[" IdentList "]"])
                "from" String ;

UseDecl       = "use" DottedName
              | "from" DottedName "use" Ident { "," Ident } ;

ModDecl       = "namespace" Ident INDENT Block DEDENT ;

ClassDecl     = "class" Ident ["extends" Ident]
                INDENT { ClassMember } DEDENT ;

ClassMember   = "private" Ident ["be" Expr]                          (* private field *)
              | "fn" "new" ["[" ParamList "]"]
                ( "to" Expr | INDENT Block DEDENT )                  (* constructor *)
              | ["static"] ["async"] "fn" Ident ParamList ["gives" Type]
                ( "to" Expr | INDENT Block DEDENT )                  (* method *)
              | "get" "fn" Ident ["gives" Type]
                ( "to" Expr | INDENT Block DEDENT )                  (* getter *)
              | "set" "fn" Ident Ident
                ( "to" Expr | INDENT Block DEDENT )                  (* setter *)
              ;

PostfixMod    = "if" Expr | "unless" Expr | "for" Ident "in" Expr ;

Expr          = Pipe ;

Pipe          = Coal { "pipe" Coal } ;
Coal          = Or { "coal" Or } ;
Or            = And { "or" And } ;
And           = Equality { "and" Equality } ;
Equality      = Comparison { ("eq" | "neq" | "not" "eq" | "is" | "instanceof") Comparison } ;
Comparison    = Addition { ("lt" ["eq"] | "gt" ["eq"] | "le" | "ge") Addition } ;
Addition      = Multiplication { ("add" | "sub") Multiplication } ;
Multiplication = Power { ("mul" | "div" | "mod") Power } ;
Power         = Unary [ "pow" Power ] ;     (* right-associative *)
Unary         = ("not" | "neg" | "typeof" | "await" | "new") Unary | Postfix ;
Postfix       = Primary { "." Ident ["[" ArgList "]"]
              | "\." Ident ["[" ArgList "]"]
              | "[" ArgList "]"
              | "[\\" Expr "]"
              | "as" Ident } ;
Primary       = IntLit | FloatLit | StrLit | InterpStr | Regex
              | "true" | "false" | "null" | "nil" | "undefined" | "this" | "super"
              | Ident
              | "list" "[" ExprList "]"
              | "object" "[" ObjEntries "]"
              | "[" BracketExpr "]"
              | "fn" ParamList ("to" Expr | INDENT Block DEDENT)
              | "async" "fn" ParamList ("to" Expr | INDENT Block DEDENT)
              | "if" Expr "then" Expr "else" Expr
              | "match" Expr INDENT { MatchArm } DEDENT
              | "try" INDENT Block DEDENT "catch" [Ident] INDENT Block DEDENT
              ;

BracketExpr   = (* empty → empty array *)
              | "be" "]"                               (* empty object *)
              | Expr ".." Expr                          (* inclusive range *)
              | Expr "..." Expr                         (* exclusive range *)
              | Expr "be" Expr { ("," | ";") Expr "be" Expr }  (* object *)
              | Expr { "," Expr }                       (* array *)
              | Expr { ";" Expr }                       (* array / args *)
              | Expr                                    (* grouping *)
              ;

ArgList       = Expr { (";" | ",") Expr } ;
ExprList      = Expr { (";" | ",") Expr } ;
ObjEntries    = Ident ["be" Expr] { ("," | ";") Ident ["be" Expr] } ;

DottedName    = Ident { "." Ident } ;
```

---

_This document describes the Purus language as implemented in v0.6.0._
_Purus is licensed under the Apache 2.0 License._
