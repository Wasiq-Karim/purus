---
title: 関数
description: Purusの関数宣言と式。
sidebar:
  order: 5
---

## 名前付き関数（ブロック本体）

```
fn greet name
  console.log[name]
```

コンパイル結果:

```js
function greet(name) {
  console.log(name);
}
```

## 名前付き関数（式本体）

```
fn double x to x mul 2
```

```js
function double(x) {
  return x * 2;
}
```

## 引数なし関数

パラメータを省略するだけです:

```
fn say-hello
  console.log[///Hello!///]
```

```js
function sayHello() {
  console.log("Hello!");
}
```

式本体の場合:

```
fn get-timestamp to Date.now[]
```

```js
function getTimestamp() { return Date.now(); }
```

## 複数パラメータ

パラメータの区切りには `;` を使います:

```
fn add a; b
  return a add b
```

```js
function add(a, b) {
  return a + b;
}
```

## 無名関数

```
const double be fn x to x mul 2
```

```js
const double = (x) => x * 2;
```

### 引数なし無名関数

```
const get-time be fn to Date.now[]
```

```js
const getTime = () => Date.now();
```

### ブロック本体付き無名関数

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

## 非同期関数

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

## 関数呼び出し

`()` の代わりに `[]` を使います:

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

### ネストされた関数呼び出し

JavaScriptでは `a(b(c), d)` のようにネストした呼び出しには `()` を使います。Purusでは `[]` を配列と呼び出しの両方に使うため、引数の区切りに `;` を使います:

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

## 型注釈（消去される）

```
fn add a of Number; b of Number gives Number to a add b
```

`of` と `gives` による型注釈はJavaScript出力では消去されます。

## return

```
fn get-value
  return 42
```
