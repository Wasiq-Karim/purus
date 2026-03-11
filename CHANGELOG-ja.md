# Changelog

Purus の構文・仕様・予約語に関する変更履歴です。

---

## v0.8.0 (2026-03-11)

### Breaking Changes

- **`pub` → `public`**: `pub` キーワードは削除されました。代わりに `public` を使用してください。
- **型名自動検出の削除**: `eq`/`is` と型名（例: `x is string`、`x eq number`）を併用した際の `typeof` 自動生成を削除。型名は通常の識別子として扱われます。
  ```purus
  -- 変更前 (v0.7.x):  x is string → typeof x === "string"
  -- 変更後 (v0.8.0):  x is string → x === string（識別子比較）
  -- 移行方法:      typeof x eq ///string///
  ```

### Deprecations

- **`match` / `when` 非推奨化**: `match` / `when` 構文は引き続き動作しますが、`witch` / `case` / `default` の使用を推奨。

- **`use` / `from...use` 非推奨化**: ドットパスインポート（`use std.math`、`from std.math use sin, cos`）は非推奨です。代わりに `import...from` または `from...import` を文字列パスで使用してください。

### New Features

- **`witch` / `case` / `default` 構文追加**: `match` / `when` / `else` の推奨代替として新しいパターンマッチング構文を追加。
  ```purus
  witch x
    case 1 then ///one///
    case 2 then ///two///
    default ///other///
  ```
  `match` と同様にif-elseチェーンにコンパイル。ガードもサポート: `case n if n gt 0`。

- **`to return` による明示的リターン**: 式本体の関数に明示的なreturnを付ける `to return` 構文を追加。
  ```purus
  fn double x to return x mul 2
  -- コンパイル結果: function double(x) { return x * 2; }
  ```
  名前付き関数、クラスメソッド、`static fn`、`get fn`、`set fn`、コンストラクタで使用可能。

- **モジュールタイプ設定**: `.purus` ファイルを ES Modules の代わりに CommonJS としてコンパイルできるようになりました。
  - CLIオプション: `purus build --type commonjs`
  - `config.purus`: `const type be ///commonjs///`
  - 解決順序: CLI `--type` > `config.purus` の `type` > `package.json` の `type` > デフォルト（`module`）
  - CJSモードでは `import`/`export` が `require()`/`module.exports`/`exports.*` に変換
  - `.cpurus` → 常にCJS、`.mpurus` → 常にESM（従来通り）

- **`purus new` 改善**: 生成される `config.purus` に `type` フィールドを追加。生成される `package.json` の `main` を `"dist/main.js"` に、`type` を `"module"` に設定。

- **TypeScript型定義追加**: `purus` npmパッケージに `index.d.ts` を追加。TypeScriptユーザーが `compile()`、`check()`、`version` の型情報を利用可能に。

- **`public` キーワード**: 名前付きエクスポートの `pub` を `public` に変更。
  ```purus
  public fn greet name to console.log[name]
  public const VERSION be ///1.0///
  ```

- **`from...import` 構文追加**: モジュールパスを先に書くインポート構文を追加。
  ```purus
  from ///express/// import express
  from ///react/// import [useState, useEffect]
  from ///fs/// import all as fs
  ```

### Tooling

- Linter: `0.6.0` → `0.7.0` — `witch`、`case` キーワード追加
- Prettier Plugin: `0.6.0` → `0.7.0` — `witch`、`case` キーワード追加
- VS Code Extension: `0.5.0` → `0.6.0` — `witch`、`case` シンタックスハイライト追加

### Docs

- [コミュニティプロジェクト](https://purus.work/ja/community-projects/)ページを追加（非公式のコミュニティ製プロジェクト一覧）

---

## v0.7.0 (2026-03-08)

### Breaking Changes

- **名前付き関数の暗黙リターン廃止**: `fn name args to expr` が `{ return expr; }` ではなく `{ expr; }` にコンパイルされるように変更。値を返す場合はブロック本体 + 明示的 `return` が必要。無名関数 (`fn args to expr` → `(args) => expr`) には影響なし。

  ```purus
  -- 変更前 (v0.6.x): 暗黙リターン
  fn double x to x mul 2
  -- コンパイル結果: function double(x) { return x * 2; }

  -- 変更後 (v0.7.0): 暗黙リターンなし
  fn double x to x mul 2
  -- コンパイル結果: function double(x) { x * 2; }

  -- 移行方法: ブロック本体 + 明示的 return を使用
  fn double x
    return x mul 2
  -- コンパイル結果: function double(x) { return x * 2; }
  ```

  これはクラスメソッド、`static fn` / `get fn` / `set fn` にも適用されます。

### New Features

- **`nan` キーワード追加**: JavaScript の `NaN` に対応するリテラルキーワード `nan` を追加。
  ```purus
  const value be nan          -- const value = NaN;
  x eq nan                    -- x === NaN
  ```
- **`with` キーワード追加（Import Attributes）**: `import ... from ... with [ key be value ]` 構文によるインポート属性を追加。JavaScript の `import ... from "..." with { key: value }` にコンパイル。
  ```purus
  import data from ///./data.json/// with [ type be ///json/// ]
  -- import data from "./data.json" with { type: "json" };

  import [name; version] from ///./package.json/// with [ type be ///json/// ]
  -- import { name, version } from "./package.json" with { type: "json" };

  import ///./styles.css/// with [ type be ///css/// ]
  -- import "./styles.css" with { type: "css" };
  ```

### Bug Fixes

- **`match` ガード + `BindPat` 修正**: `when n if cond` パターンで `n` がバインド変数の場合、コード生成時にスコープエラーが発生していた問題を修正。変数 `n` が `if` ブロック内で宣言されていたがガード条件で参照されていた問題を、事前宣言方式に変更して解決。
  ```purus
  match value
    when n if n gt 0
      console.log[///positive///]
    when _
      console.log[///other///]
  ```
  ```js
  // 修正前 (不具合): n がガード条件のスコープ外
  // 修正後: const n = value; が事前宣言される
  {
    const n = value;
    if (n > 0) { console.log("positive"); }
    else { console.log("other"); }
  }
  ```

### Keywords Added

| キーワード | 用途 |
|---|---|
| `nan` | NaN リテラル |
| `with` | Import Attributes |

---

## v0.6.1 (2026-03-07)

### Changes

- パッケージメタデータ修正（npm publish 向け）。
- 構文・予約語の変更なし。

---

## v0.6.0 (2026-03-07)

### New Features

- **クラス構文**: `class` / `extends` / `super` / `static` / `private` / `get` / `set` キーワードを追加。JavaScript の ES6 クラスにコンパイル。
  ```purus
  class Animal
    private name
    fn constructor name
      this.name be name
    fn speak
      console.log[this.name]
    static fn create name
      return new Animal[name]
    get fn value
      return this.name
    set fn value v
      this.name be v
  ```
  ```js
  class Animal {
    #name;
    constructor(name) { this.#name = name; }
    speak() { console.log(this.#name); }
    static create(name) { return new Animal(name); }
    get value() { return this.#name; }
    set value(v) { this.#name = v; }
  }
  ```
- **`super` 式**: 親クラスのコンストラクタやメソッドを呼び出すための `super` 式を追加。
  ```purus
  class Dog extends Animal
    fn constructor name
      super[name]
  ```
- **継承**: `class Child extends Parent` が JavaScript の `class Child extends Parent` にコンパイル。

### Keywords Added

| キーワード | JS出力 | 用途 |
|---|---|---|
| `class` | `class` | クラス宣言 |
| `extends` | `extends` | 継承 |
| `super` | `super` | 親クラス参照 |
| `static` | `static` | 静的メソッド |
| `private` | `#` (private field) | プライベートフィールド |
| `get` | `get` | ゲッター |
| `set` | `set` | セッター |

---

## v0.5.0 (2026-03-07)

### New Features

- **`coal` （Nullish Coalescing）**: `a coal b` → `a ?? b` にコンパイル。
  ```purus
  const name be user.name coal ///anonymous///
  -- const name = user.name ?? "anonymous";
  ```
- **オプショナルチェイニング**: `obj\.field` → `obj?.field`、`obj\.method[args]` → `obj?.method(args)` にコンパイル。
  ```purus
  const name be user\.profile\.name
  -- const name = user?.profile?.name;
  user\.greet[///hello///]
  -- user?.greet("hello");
  ```
- **計算プロパティアクセス**: `obj[\key]` → `obj[key]` にコンパイル。
  ```purus
  const val be obj[\key]
  -- const val = obj[key];
  ```
- **文字列補間**: `///Hello [name]!///` → テンプレートリテラルにコンパイル。トリプルスラッシュ文字列内の角括弧 `[expr]` が補間される。
  ```purus
  const msg be ///Hello [name]! You are [age] years old.///
  -- const msg = `Hello ${name}! You are ${age} years old.`;
  ```
- **副作用インポート**: `import ///module///` → `import "module"` 副作用のみのインポート。
  ```purus
  import ///./polyfill.js///
  -- import "./polyfill.js";
  ```
- **`async fn` 式**: `async fn x to expr` および `async fn` ブロック本体を式として使用可能（変数割り当てなど）。
  ```purus
  const fetchData be async fn url to await fetch[url]
  -- const fetchData = async (url) => await fetch(url);
  ```
- **オブジェクト分割代入**: `const object[a; b] be expr` → `const { a, b } = expr`。配列分割代入と区別するため `object` キーワードプレフィックスを使用。
  ```purus
  const object[name; age] be person
  -- const { name, age } = person;
  ```
- **アンダースコア識別子**: `_variable`、`_private`、`__internal` のようなアンダースコア開始の識別子をサポート。

### Punctuation Added

| 記号 | 用途 |
|---|---|
| `\` | 計算プロパティアクセスプレフィックス |
| `\.` | オプショナルチェイニング |

### Keywords Added

| キーワード | JS出力 | 用途 |
|---|---|---|
| `coal` | `??` | Nullish Coalescing |

---

## v0.4.1 (2026-03-06)

### Changes

- パッケージ間のバージョンを統一するための同期スクリプトを追加。
- 構文・予約語の変更なし。

---

## v0.4.0 (2026-03-06)

### Breaking Changes

- **`ne` → `neq` に改名**: 不等価演算子のキーワードを `ne` から `neq` に変更。既存の `ne` を使用しているコードはすべて `neq` に更新が必要。
  ```purus
  -- 変更前 (v0.3.x)
  x ne y           -- x !== y

  -- 変更後 (v0.4.0)
  x neq y          -- x !== y
  x not eq y       -- x !== y (代替表記)
  ```

### New Features

- **`pow` 演算子**: `a pow b` → `a ** b` にコンパイル。右結合、`mul`/`div`/`mod` より高い優先順位。
  ```purus
  2 pow 10         -- 2 ** 10
  x pow y pow z    -- x ** (y ** z)  (右結合)
  ```
- **`not eq` 演算子合成**: `not eq` は `neq` (`!==`) として解析される。同様に `lt eq` → `le` (`<=`)、`gt eq` → `ge` (`>=`)。
  ```purus
  x not eq y       -- x !== y
  x lt eq y        -- x <= y
  x gt eq y        -- x >= y
  ```
- **範囲配列**: `[start..end]`（inclusive）/ `[start...end]`（exclusive）が `Array.from()` を使って配列を生成。
  ```purus
  [1..5]           -- Array.from({ length: 5 - 1 + 1 }, (_, i) => i + 1)  → [1,2,3,4,5]
  [0...5]          -- Array.from({ length: 5 - 0 }, (_, i) => i + 0)      → [0,1,2,3,4]
  ```
- **スライス**: `arr[start..end]` / `arr[start...end]` が `.slice()` にコンパイル。スライスへの代入は `.splice()` にコンパイル。
  ```purus
  arr[1..3]        -- arr.slice(1, 3 + 1)
  arr[1...3]       -- arr.slice(1, 3)
  arr[1..3] be [7; 8; 9]  -- arr.splice(1, 3 - 1 + 1, 7, 8, 9)
  ```
- **配列分割代入**: `const [a; b] be arr` → `const [a, b] = arr`。
  ```purus
  const [first; second] be arr
  -- const [first, second] = arr;
  ```
- **`namespace` キーワード**: `namespace name` ブロックが IIFE（即時実行関数式）にコンパイル。
  ```purus
  namespace Utils
    pub fn helper
      return 42
  ```
- **`purus check` コマンド**: 出力ファイルを生成せずに構文チェックを行う CLI コマンドを追加。

### Punctuation Added

| 記号 | 用途 |
|---|---|
| `..` | 包含範囲 (inclusive range) |
| `...` | 排他範囲 (exclusive range) |

### Keywords Added / Changed

| キーワード | 変更 |
|---|---|
| `pow` | 新規追加（べき乗演算子） |
| `neq` | `ne` から改名 |
| `namespace` | 新規追加（モジュール名前空間、`use` のエイリアス） |

---

## v0.3.0 (2026-03-06)

### Changes

- **`purus version` コマンド**: `version` / `--version` / `-v` CLI コマンドを追加。
- **ビルドリファクタリング**: 単一ファイルのビルドが MoonBit コンパイラに委譲する代わりにコンパイル API を直接使用するように変更。ヘッダーコメント生成を JS ラッパーレイヤーに移動。
- **`purus new` プロンプト変更**: "Install dependencies?" のデフォルト回答を No から Yes に変更。
- 構文・予約語の変更なし。

---

## v0.2.1 (2026-03-06)

### Changes

- パッケージメタデータ修正（README リンク）。
- 構文・予約語の変更なし。

---

## v0.2.0 (2026-03-06)

### New Features

- **CLI ツール**: 以下のコマンドを含む完全な CLI インターフェースを追加:
  - `purus build [file]` — JavaScript にコンパイル
  - `purus build --directory <dir>` — ディレクトリ内の全ファイルをコンパイル
  - `purus build --output <dir>` — 出力ディレクトリを指定
  - `purus build --no-header` — ヘッダーコメントなしでコンパイル
  - `purus build --stdout` — 標準出力に出力
  - `purus run [file]` — ファイルを生成せずに実行
  - `purus new [name] [-y]` / `purus create` — 新規プロジェクトを作成
  - `purus init` — 現在のディレクトリでプロジェクトを初期化
  - `purus help` — ヘルプを表示
- **設定ファイル**: プロジェクトレベルのビルド設定用 `config.purus` 設定ファイルサポートを追加。
- **ファイル拡張子マッピング**: `.purus` → `.js`、`.cpurus` → `.cjs`（CommonJS）、`.mpurus` → `.mjs`（ES Module）。
- `purus.json` プロジェクトファイルを削除（`config.purus` に置き換え）。

### Changes

- 構文・予約語の変更なし。

---

## v0.1.0 (2026-03-06)

### Bug Fixes

- **`eq` / `is` のパース修正**: 以前は `eq` と `is` で別々のパースパスがあり、`eq` は常にバイナリ等価演算（`===`）を生成し、`is` は `typeof` チェックを生成していた。`eq` も次のトークンが型名の場合に型チェック（`IsCheck`）を生成するよう修正。`eq` と `is` が同一の動作に統一。
  ```purus
  -- 修正前 (v0.0.x): eq は常に === を生成
  x eq string      -- x === string  (誤り — 変数と比較)

  -- 修正後 (v0.1.0): eq が型名を検出
  x eq string      -- typeof x === "string"  (型チェック)
  x is string      -- typeof x === "string"  (同じ動作)
  ```
  認識される型名: `string`、`number`、`boolean`、`undefined`、`function`、`symbol`、`bigint`、`null`、`object`、および PascalCase の識別子（例: `Array`、`Date`）。

### Changes

- 構文・予約語の変更なし。

---

## v0.0.3 (2026-03-06)

### Changes

- パッケージバージョン修正。
- 構文・予約語の変更なし。

---

## v0.0.2 (2026-03-06)

### Changes

- README リンク修正、パッケージファイル設定修正。
- 構文・予約語の変更なし。

---

## v0.0.1 (2026-03-06)

### Initial Release

Purus 言語の最初のリリース。

#### リテラル

- 整数、浮動小数点数、文字列（`///...///`）、正規表現（`///regex///`）、`true` / `false`、`null` / `nil` / `undefined`
- 配列 `[1; 2; 3]`、オブジェクト `[key be value]`

#### 変数宣言

- `const` / `let` / `var` + `be`（代入キーワード）
  ```purus
  const name be ///Purus///    -- const name = "Purus";
  let count be 0               -- let count = 0;
  ```

#### 演算子（キーワード形式）

| キーワード | JS出力 | 用途 |
|---|---|---|
| `add` | `+` | 加算 / 文字列結合 |
| `sub` | `-` | 減算 |
| `mul` | `*` | 乗算 |
| `div` | `/` | 除算 |
| `mod` | `%` | 剰余 |
| `neg` | `-` (単項) | 符号反転 |
| `eq` | `===` | 等価 |
| `ne` | `!==` | 不等価 |
| `lt` | `<` | 未満 |
| `gt` | `>` | 超過 |
| `le` | `<=` | 以下 |
| `ge` | `>=` | 以上 |
| `and` | `&&` | 論理 AND |
| `or` | `\|\|` | 論理 OR |
| `not` | `!` | 論理 NOT |

#### 関数

- `fn` / `return` / `to`（式本体） / `gives`（型注釈） / `async` / `await`
  ```purus
  fn greet name to console.log[name]
  -- function greet(name) { return console.log(name); }

  fn add a b
    return a add b
  -- function add(a, b) { return a + b; }
  ```

#### 制御フロー

- `if` / `elif` / `else` / `unless` / `then`（インライン）
- `while` / `until` / `for` / `in` / `range`
- `break` / `continue`
- `match` / `when`（パターンマッチ）
- `pipe`（パイプ演算子 `|>`）

#### 後置修飾

- `stmt if cond` / `stmt unless cond` / `stmt for x in arr`
  ```purus
  console.log[x] if x gt 0
  -- if (x > 0) { console.log(x); }
  ```

#### エラー処理

- `try` / `catch` / `finally` / `throw`

#### 型関連

- `is` / `as` / `of`（型注釈） / `typeof` / `instanceof` / `type`（型エイリアス）

#### オブジェクト

- `new` / `delete` / `this`

#### モジュール

- `import` / `from` / `export` / `default` / `require`
- `use`（ドットパスインポート）
- `pub`（公開エクスポート修飾子）
- `all`（名前空間インポート: `import all as name from ...`）

#### セパレータ

- `;`（セミコロン）と `,`（カンマ）はセパレータとして互換的に使用可能

#### 予約キーワード

- `list` / `object`（明示的コンストラクタ用に予約）

#### その他

- Shebang サポート（`#!` 行は保持される）
- `// comment` スタイルのコメントは `-- comment` で記述

#### 区切り文字

| 記号 | 用途 |
|---|---|
| `[` / `]` | 関数呼び出し / 配列 / オブジェクト |
| `,` | 配列 / オブジェクト区切り |
| `;` | 引数 / パラメータ / 分割代入区切り |
| `.` | プロパティアクセス |
