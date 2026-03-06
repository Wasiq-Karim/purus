---
title: 演算子
description: Purusの演算子と優先順位。
sidebar:
  order: 3
---

## 演算子の優先順位（低い順）

1. `pipe` — パイプライン
2. `coal` — Null合体
3. `or` — 論理OR
4. `and` — 論理AND
5. `eq` / `neq` / `not eq` / `is` / `instanceof` — 等価 / 型チェック
6. `lt` / `gt` / `le`（`lt eq`） / `ge`（`gt eq`） — 比較
7. `add` / `sub` — 加算 / 減算
8. `mul` / `div` / `mod` — 乗算 / 除算 / 剰余
9. `pow` — べき乗
10. 単項: `not` / `neg` / `typeof` / `await` / `delete` / `new`
11. 後置: `.` アクセス / `[args]` 呼び出し / `as` キャスト
12. 基本: リテラル、識別子、括弧

## パイプライン

```
data pipe filter
data pipe filter pipe map
data pipe transform[extra-arg]
data pipe .method[arg]
```

コンパイル結果:

```js
filter(data)
map(filter(data))
transform(data, extraArg)
data.method(arg)
```

## 代入

```
const x be 42
let y be 10
y be 20
```

## 算術

```
a add b    -- a + b
a sub b    -- a - b
a mul b    -- a * b
a div b    -- a / b
a mod b    -- a % b
a pow b    -- a ** b
neg x      -- -x
```

## 比較

`eq` と `is` は同じように使えます。右辺が型名（`string`, `number`, `null`, 大文字始まりのクラス名など）の場合は型チェックになり、それ以外は厳密等価比較（`===`）になります。

不等価には `neq` または `not eq` を使います。以下はどちらも `le` と同じ意味です: `lt eq`。以下はどちらも `ge` と同じ意味です: `gt eq`。

```
a eq b      -- a === b
a neq b     -- a !== b
a not eq b  -- a !== b（別の書き方）
a lt b      -- a < b
a gt b      -- a > b
a le b      -- a <= b
a lt eq b   -- a <= b（別の書き方）
a ge b      -- a >= b
a gt eq b   -- a >= b（別の書き方）

-- eq と is は混同して使える
a eq b     -- a === b（値の比較）
a is b     -- a === b（値の比較）
a eq string -- typeof a === "string"（型チェック）
a is string -- typeof a === "string"（型チェック）
```

## 配列の範囲

`..`（包含）と `...`（排他）を使って数値範囲から配列を生成します:

```
const a be [0..5]     -- [0, 1, 2, 3, 4, 5]
const b be [0...5]    -- [0, 1, 2, 3, 4]
const c be [1..10]    -- [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
const d be [1...10]   -- [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

## スライス（切り出し）

`..`（包含）または `...`（排他）をブラケットアクセス内で使い、配列の一部を切り出します:

```
const numbers be [0, 1, 2, 3, 4, 5, 6]
const middle be numbers[2..4]    -- [2, 3, 4]
const partial be numbers[1...4]  -- [1, 2, 3]
```

## スプライス（部分置換）

スライスに代入することで配列の一部を置換できます:

```
numbers[2..4] be [///a///; ///b///; ///c///]
-- numbers は [0, 1, "a", "b", "c", 5, 6] になります
```

## 分割代入

配列から変数に値を取り出します:

```
const weather be [///Sunny///; ///Rainy///]
const [today; tomorrow] be weather

-- 変数の値を入れ替える
[today; tomorrow] be [tomorrow; today]
```

### オブジェクト分割代入

`object[...]` を使ってオブジェクトからプロパティを取り出します:

```
const config be [host be ///localhost///, port be 8080]
const object[host; port] be config
```

コンパイル結果:

```js
const config = { host: "localhost", port: 8080 };
const { host, port } = config;
```

## 論理

```
a and b    -- a && b
a or b     -- a || b
not x      -- !x
```

## Null合体（Nullish Coalescing）

`coal` 演算子は、左辺が `null` または `undefined` の場合に右辺の値を返します:

```
a coal b           -- a ?? b
a coal b coal c    -- a ?? b ?? c
```

コンパイル結果:

```js
a ?? b;
a ?? b ?? c;
```

`or` との違い: `or` はすべてのfalsy値（`false`, `0`, `""`, `null`, `undefined`）をfalseとして扱いますが、`coal` は `null` と `undefined` のみを「空」として扱います。`0` や `false` や `""` を保持したい場合は `coal` を使ってください。

```
const port be config.port coal 3000      -- portがnull/undefinedの場合のみ3000を使用
const name be user.name coal ///guest///  -- nameがnull/undefinedの場合のみ"guest"を使用
```

## 型チェック

`eq` と `is` はどちらも型名の前に置くと型チェックとして機能します。

```
x is string          -- typeof x === "string"
x eq string          -- typeof x === "string"
x is null            -- x === null
x is MyClass         -- x instanceof MyClass
x instanceof Y       -- x instanceof Y
typeof x             -- typeof x
```
