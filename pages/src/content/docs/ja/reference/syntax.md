---
title: 構文の概要
description: Purusの構文の概要。
sidebar:
  order: 1
---

## ファイル拡張子

| 拡張子 | 出力 | 説明 |
|---|---|---|
| `.purus` | `.js` | 標準JavaScript |
| `.cpurus` | `.cjs` | CommonJSモジュール |
| `.mpurus` | `.mjs` | ESモジュール |

## コメント

```
-- これは行コメントです

--- これはブロック
コメントです ---
```

## 文字列

文字列はトリプルスラッシュ `///` で囲みます:

```
const greeting be ///Hello, World///
```

### エスケープシーケンス

| エスケープ | 結果 |
|---|---|
| `\n` | 改行 |
| `\t` | タブ |
| `\\` | バックスラッシュ |
| `\/` | `/` |
| `\[` | `[`（リテラルブラケット） |
| `\]` | `]`（リテラルブラケット） |

### 文字列補間（テンプレートリテラル）

文字列内で `[式]` を使うと、式を埋め込むことができます:

```
const name be ///Alice///
const age be 30
const msg be ///Hello, [name]! You are [age] years old.///
```

コンパイル結果:

```js
const name = "Alice";
const age = 30;
const msg = `Hello, ${name}! You are ${age} years old.`;
```

ブラケット内では任意の式を使えます:

```
const x be 10
const result be ///[x] times 2 is [x mul 2]///
```

コンパイル結果:

```js
const x = 10;
const result = `${x} times 2 is ${x * 2}`;
```

文字列内にリテラルの `[` や `]` を含めたい場合は、エスケープシーケンス `\[` と `\]` を使います。

## 数値

```
const i be 42
const f be 3.14
```

## 真偽値とnull

```
const a be true
const b be false
const c be null
const d be nil       -- nullのエイリアス
const e be undefined
```

## 配列

```
const arr be [1, 2, 3]
const arr2 be [1; 2; 3]   -- セミコロンも使用可能
const empty be []
```

### 配列の範囲

```
const inclusive be [0..5]   -- [0, 1, 2, 3, 4, 5]
const exclusive be [0...5]  -- [0, 1, 2, 3, 4]
```

### スライス（切り出し）

`..`（包含）または `...`（排他）を使って配列の一部を切り出します:

```
const numbers be [0, 1, 2, 3, 4, 5, 6]
const middle be numbers[2..4]    -- [2, 3, 4]
const partial be numbers[1...4]  -- [1, 2, 3]
```

コンパイル結果:

```js
const middle = numbers.slice(2, 4 + 1);
const partial = numbers.slice(1, 4);
```

### スプライス（部分置換）

スライスに代入することで配列の一部を置換できます:

```
numbers[2..4] be [///a///; ///b///; ///c///]
-- numbers は [0, 1, "a", "b", "c", 5, 6] になります
```

コンパイル結果:

```js
numbers.splice(2, 4 - 2 + 1, "a", "b", "c");
```

### 分割代入

配列から変数に値を取り出します:

```
const weather be [///Sunny///; ///Rainy///]
const [today; tomorrow] be weather

-- 変数の値を入れ替える
[today; tomorrow] be [tomorrow; today]
```

コンパイル結果:

```js
const [today, tomorrow] = weather;
[today, tomorrow] = [tomorrow, today];
```

## オブジェクト

```
const obj be [name be ///Alice///, age be 30]
const empty-obj be [be]    -- 空のオブジェクト
```

### オブジェクト分割代入

`object[...]` を使ってオブジェクトからプロパティを取り出します:

```
const person be [name be ///Alice///, age be 30]
const object[name; age] be person
```

コンパイル結果:

```js
const person = { name: "Alice", age: 30 };
const { name, age } = person;
```

## 括弧は`[]`のみ

Purusでは関数呼び出し、配列、オブジェクト、グループ化のすべてに `[]` を使用します。`()` や `{}` は使いません。

## インデント

ブロックはインデントで定義されます（2スペース推奨）:

```
if x gt 0
  console.log[///positive///]
else
  console.log[///non-positive///]
```

## 識別子

識別子にはハイフン（`-`）とアンダースコア（`_`）を含めることができ、JavaScript出力ではどちらもアンダースコアに変換されます:

```
const my-variable be 42
-- コンパイル結果: const my_variable = 42;

const my_variable2 be 43
-- コンパイル結果: const my_variable2 = 43;
```

ハイフンとアンダースコアは互換性があります — `my-var` と `my_var` は同じJavaScript変数（`my_var`）を参照します。JSライブラリとの互換性のため、どちらの形式でも使用できます。

:::caution
`a-b` と `a_b` はどちらも `a_b` にコンパイルされるため、同じスコープで両方を定義しないでください。同じ変数を参照します。
:::
