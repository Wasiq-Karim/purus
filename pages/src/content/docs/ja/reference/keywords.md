---
title: 予約語
description: Purusの予約語一覧。
sidebar:
  order: 2
---

## 宣言

| キーワード | JS出力 | 説明 |
|---|---|---|
| `const` | `const` | 定数宣言 |
| `let` | `let` | 変数宣言 |
| `var` | `var` | var宣言（非推奨） |
| `be` | `=` | 代入 |

## 関数

| キーワード | JS出力 | 説明 |
|---|---|---|
| `fn` | `function` | 関数宣言/式 |
| `return` | `return` | 戻り値を返す |
| `to` | `=> expr` | 式本体 |
| `gives` | _(消去)_ | 戻り値の型注釈 |
| `async` | `async` | 非同期関数 |
| `await` | `await` | await式 |

## 条件分岐

| キーワード | JS出力 | 説明 |
|---|---|---|
| `if` | `if` | 条件分岐 |
| `elif` | `else if` | else-if分岐 |
| `else` | `else` | else分岐 |
| `unless` | `if (!(...))` | 否定条件分岐 |
| `then` | _(三項/インライン)_ | インライン条件 |

## ループ

| キーワード | JS出力 | 説明 |
|---|---|---|
| `while` | `while` | whileループ |
| `until` | `while (!(...))` | 否定whileループ |
| `for` | `for` | forループ |
| `in` | `of` / `in` | イテレータ |
| `range` | _(数値範囲)_ | 範囲ベースのループ |
| `break` | `break` | break |
| `continue` | `continue` | continue |

## パターンマッチ

| キーワード | JS出力 | 説明 |
|---|---|---|
| `match` | if-elseチェーン | マッチ式 |
| `when` | _(マッチアーム)_ | マッチケース |

## モジュール

| キーワード | JS出力 | 説明 |
|---|---|---|
| `import` | `import` | ESMインポート |
| `from` | `from` | インポート元 |
| `export` | `export` | ESMエクスポート |
| `default` | `default` | デフォルトエクスポート |
| `require` | `require()` | CJS require |
| `use` | `import` | ドットパスインポート |
| `namespace` | IIFE | モジュール名前空間 |
| `pub` | `export` | 公開エクスポート |
| `all` | `* as` | 名前空間インポート |

## 演算子

### 算術

| キーワード | JS出力 |
|---|---|
| `add` | `+` |
| `sub` | `-` |
| `mul` | `*` |
| `div` | `/` |
| `mod` | `%` |
| `pow` | `**` |
| `neg` | `-`（単項） |

### 比較

| キーワード | JS出力 |
|---|---|
| `eq` | `===` |
| `neq` / `not eq` | `!==` |
| `lt` | `<` |
| `gt` | `>` |
| `le` / `lt eq` | `<=` |
| `ge` / `gt eq` | `>=` |

### 論理

| キーワード | JS出力 |
|---|---|
| `and` | `&&` |
| `or` | `\|\|` |
| `not` | `!` |

### Null合体

| キーワード | JS出力 |
|---|---|
| `coal` | `??` |

### パイプライン

| キーワード | JS出力 |
|---|---|
| `pipe` | `b(a)` |

## 型キーワード

| キーワード | JS出力 | 説明 |
|---|---|---|
| `is` | `typeof` / `instanceof` | 型チェック |
| `as` | _(消去)_ | 型キャスト |
| `of` | _(消去)_ | 型注釈 |
| `typeof` | `typeof` | typeof演算子 |
| `instanceof` | `instanceof` | インスタンスチェック |
| `type` | _(消去)_ | 型エイリアス |

## その他

| キーワード | JS出力 |
|---|---|
| `new` | `new` |
| `delete` | `delete` |
| `this` | `this` |
| `throw` | `throw` |
| `try` | `try` |
| `catch` | `catch` |
| `finally` | `finally` |
| `pipe` | パイプライン演算子 |
| `list` | 配列リテラル |
| `object` | オブジェクトリテラル |
