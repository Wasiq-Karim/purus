---
title: Functions
description: Function declarations and expressions in Purus.
sidebar:
  order: 5
---

## Named function (block body)

```
fn greet name
  console.log[name]
```

Compiles to:

```js
function greet(name) {
  console.log(name);
}
```

## Named function (expression body)

```
fn double x to x mul 2
```

```js
function double(x) {
  return x * 2;
}
```

## Function with no arguments

Simply omit the parameters:

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

## Multiple parameters

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

## Anonymous functions

```
const double be fn x to x mul 2
```

```js
const double = (x) => x * 2;
```

### Anonymous function with no arguments

```
const get-time be fn to Date.now[]
```

```js
const getTime = () => Date.now();
```

### Anonymous function with block body

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

## Async functions

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

## Function calls

Use `[]` instead of `()`:

```
greet[///world///]
add[1; 2]
console.log[///hello///]
```

```js
greet("world");
add(1, 2);
console.log("hello");
```

### Nested function calls

In JavaScript, nested calls like `a(b(c), d)` use `()`. In Purus, since `[]` is used for both arrays and calls, use `;` to separate arguments:

```
-- JS: a(b(c), d)
a[b[c]; d]

-- JS: a(b, c(d, e))
a[b; c[d; e]]

-- JS: console.log(Math.max(1, 2))
console.log[Math.max[1; 2]]

-- JS: fn(a(1, 2), b(3, 4), c)
fn[a[1; 2]; b[3; 4]; c]

-- JS: outer(inner1(x), inner2(y, z))
outer[inner1[x]; inner2[y; z]]
```

```js
a(b(c), d);
a(b, c(d, e));
console.log(Math.max(1, 2));
fn(a(1, 2), b(3, 4), c);
outer(inner1(x), inner2(y, z));
```

## Type annotations (erased)

```
fn add a of Number; b of Number gives Number to a add b
```

Type annotations with `of` and `gives` are erased in the JavaScript output.

## Return

```
fn get-value
  return 42
```
