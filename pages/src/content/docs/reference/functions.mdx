---
title: Functions
description: Function declarations and expressions in Purus.
sidebar:
  order: 5
---

## Named function (block body)

```purus
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

The `to` form creates a one-liner function body. Named functions do not have implicit return — use `to return` for explicit return.

```purus
fn greet name to console.log[name]
```

```js
function greet(name) { console.log(name); }
```

### Explicit return with `to return`

```purus
fn double x to return x mul 2
```

```js
function double(x) { return x * 2; }
```

## Function with no arguments

Simply omit the parameters:

```purus
fn say-hello
  console.log[///Hello!///]
```

```js
function sayHello() {
  console.log("Hello!");
}
```

With expression body:

```purus
fn say-hello to console.log[///Hello!///]
```

```js
function sayHello() { console.log("Hello!"); }
```

## Multiple parameters

Use `;` to separate parameters:

```purus
fn add a; b
  return a add b
```

```js
function add(a, b) {
  return a + b;
}
```

## Anonymous functions

```purus
const double be fn x to x mul 2
```

```js
const double = (x) => x * 2;
```

### Anonymous function with no arguments

```purus
const get-time be fn to Date.now[]
```

```js
const getTime = () => Date.now();
```

### Anonymous function with block body

```purus
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

```purus
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

### Async function expressions

Async anonymous functions work like regular anonymous functions with `async` prefix:

```purus
const handler be async fn event to await process[event]

const fetcher be async fn url
  const res be await fetch[url]
  return await res.json[]
```

```js
const handler = async (event) => await process(event);

const fetcher = async (url) => {
  const res = await fetch(url);
  return await res.json();
};
```

## Inline Callbacks

With multi-line bracket support, anonymous functions can be passed as arguments in method chains:

```purus
promise.then[fn result to console.log[result]].catch[fn err to console.error[err]]
```

Multi-line form:

```purus
fetch[url].then[
  fn response
    return response.json[]
].then[
  fn data
    console.log[data]
].catch[
  fn err
    console.error[err]
]
```

```js
fetch(url).then((response) => {
  return response.json();
}).then((data) => {
  console.log(data);
}).catch((err) => {
  console.error(err);
});
```

## Function calls

Use `[]` instead of `()`:

```purus
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

```purus
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

```purus
fn add a of Number; b of Number gives Number to a add b
```

Type annotations with `of` and `gives` are erased in the JavaScript output.

## Return

```purus
fn get-value
  return 42
```
