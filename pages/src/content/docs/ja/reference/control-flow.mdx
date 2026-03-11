---
title: 制御フロー
description: Purusの条件分岐、ループ、パターンマッチング。
sidebar:
  order: 4
---

## If / Elif / Else

Purusはインデントでブロックを定義します。波括弧 `{}` は不要です。

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
`elif` は `else if` のエイリアスです。どちらも同じように動作します:

```purus
if x lt 0
  console.log[///negative///]
else if x eq 0
  console.log[///zero///]
else
  console.log[///positive///]
```

これは `elif` と同じJavaScriptにコンパイルされます。
:::

### 複数行ブロック

`if`、`elif`、`else` の下にインデントされた文はそのブロックに属します:

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

否定の `if`:

```purus
unless done
  keep-going[]
```

```js
if (!(done)) {
  keepGoing();
}
```

## インラインif（三項演算子）

```purus
const result be if condition then 1 else 2
```

```js
const result = condition ? 1 : 2;
```

## 後置修飾子

短い条件分岐やループを1行で書けます:

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

インデックス付き:

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

ガード付き:

`case n if ...` において、変数 `n` はwitchの対象（`value`）にバインドされ、ガード条件でその値を参照できます。

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

:::caution[非推奨]
`match` / `when` は非推奨です。代わりに `witch` / `case` / `default` を使用してください。
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

ガード付き:

`when n if ...` において、変数 `n` はmatchの対象（`value`）にバインドされ、ガード条件でその値を参照できます。

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

### 式としてのtry

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