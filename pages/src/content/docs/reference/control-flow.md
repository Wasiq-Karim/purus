---
title: Control Flow
description: Conditionals, loops, and pattern matching in Purus.
sidebar:
  order: 4
---

## If / Elif / Else

Purus uses indentation to define blocks — no curly braces `{}` needed.

```purus
if x lt 0
  console.log[///negative///]
elif x eq 0
  console.log[///zero///]
else
  console.log[///positive///]
```

```js
if (x < 0) {
  console.log("negative");
} else if (x === 0) {
  console.log("zero");
} else {
  console.log("positive");
}
```

:::tip
`elif` is an alias for `else if`. Both work identically:

```purus
if x lt 0
  console.log[///negative///]
else if x eq 0
  console.log[///zero///]
else
  console.log[///positive///]
```

This compiles to the same JavaScript as `elif`.
:::

### Multi-line blocks

Any statements indented under `if`, `elif`, or `else` belong to that block:

```purus
if logged-in
  const user be get-user[]
  console.log[///Welcome, [user.name]///]
  show-dashboard[]
else
  console.log[///Please log in///]
  redirect[///login///]
```

```js
if (loggedIn) {
  const user = getUser();
  console.log(`Welcome, ${user.name}`);
  showDashboard();
} else {
  console.log("Please log in");
  redirect("login");
}
```

## Unless

Negated `if`:

```purus
unless done
  keep-going[]
```

```js
if (!(done)) {
  keepGoing();
}
```

## Inline if (ternary)

```purus
const result be if condition then 1 else 2
```

```js
const result = condition ? 1 : 2;
```

## Postfix modifiers

Write short conditionals and loops on a single line:

```purus
console.log[///debug///] if verbose
console.log[///skip///] unless done
console.log[item] for item in list
```

```js
if (verbose) {
  console.log("debug");
}
if (!(done)) {
  console.log("skip");
}
for (const item of list) {
  console.log(item);
}
```

## While / Until

```purus
while i lt 10
  i be i add 1

until finished
  do-work[]
```

```js
while (i < 10) {
  i = i + 1;
}
while (!(finished)) {
  doWork();
}
```

## For-in

```purus
for item in items
  console.log[item]
```

```js
for (const item of items) {
  console.log(item);
}
```

With index:

```purus
for i; item in items
  console.log[i; item]
```

```js
for (let [i, item] of items.entries()) {
  console.log(i, item);
}
```

## For-range

```purus
for i in range 0; 10
  console.log[i]
```

```js
for (let i = 0; i < 10; i++) {
  console.log(i);
}
```

## Witch / Case / Default

```purus
witch x
  case 1 then ///one///
  case 2 then ///two///
  default ///other///
```

```js
if (x === 1) {
  "one";
} else if (x === 2) {
  "two";
} else {
  "other";
}
```

With guards:

In `case n if ...`, the variable `n` is bound to the witch subject (`value`), allowing the guard condition to reference it.

```purus
witch value
  case n if n gt 0
    console.log[///positive///]
  default
    console.log[///non-positive///]
```

```js
{
  const n = value;
  if (n > 0) {
    console.log("positive");
  } else {
    console.log("non-positive");
  }
}
```

## Match / When

:::caution[Deprecated]
`match` / `when` is deprecated. Use `witch` / `case` / `default` instead.
:::

```purus
match x
  when 1 then ///one///
  when 2 then ///two///
  else ///other///
```

```js
if (x === 1) {
  "one";
} else if (x === 2) {
  "two";
} else {
  "other";
}
```

With guards:

In `when n if ...`, the variable `n` is bound to the match subject (`value`), allowing the guard condition to reference it.

```purus
match value
  when n if n gt 0
    console.log[///positive///]
  else
    console.log[///non-positive///]
```

```js
{
  const n = value;
  if (n > 0) {
    console.log("positive");
  } else {
    console.log("non-positive");
  }
}
```

## try / catch / finally

```purus
try
  risky[]
catch e
  console.log[e]
finally
  cleanup[]
```

```js
try {
  risky();
} catch (e) {
  console.log(e);
} finally {
  cleanup();
}
```

### Try as expression

```purus
const result be try
  risky[]
catch e
  default-value
```

```js
let result;
try {
  result = risky();
} catch (e) {
  result = defaultValue;
}
```

## Throw

```purus
throw new Error[///something went wrong///]
throw err if condition
```

```js
throw new Error("something went wrong");
if (condition) {
  throw err;
}
```
