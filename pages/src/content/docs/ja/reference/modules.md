---
title: モジュール
description: Purusのインポート、エクスポート、モジュールシステム。
sidebar:
  order: 6
---

## ESMインポート

```purus
import express from ///express///
import [Hono] from ///hono///
import [describe, it, expect] from ///vitest///
import axios, [AxiosError] from ///axios///
import all as fs from ///fs///
```

```js
import express from "express";
import { Hono } from "hono";
import { describe, it, expect } from "vitest";
import axios, { AxiosError } from "axios";
import * as fs from "fs";
```

### 副作用インポート

バインディングなしでモジュールの副作用のみをインポートします:

```purus
import ///dotenv/config///
import ///./polyfills///
```

```js
import "dotenv/config";
import "./polyfills";
```

### インポート属性

`with` キーワードを使用してインポート属性を指定できます:

```purus
import package from ///./package.json/// with [ type be ///json/// ]
import [name; version] from ///./package.json/// with [ type be ///json/// ]
```

```js
import package from "./package.json" with { type: "json" };
import { name, version } from "./package.json" with { type: "json" };
```

## Use（ドットパスインポート）

```purus
use std.math
from std.math use sin, cos
```

```js
import * as math from "std/math";
import { sin, cos } from "std/math";
```

## エクスポート

```purus
pub fn greet name to console.log[name]
pub const VERSION be ///1.0///
export default fn main
  console.log[///hi///]
```

```js
export function greet(name) { console.log(name); }
export const VERSION = "1.0";
export default function main() {
  console.log("hi");
}
```

## モジュール名前空間

```purus
namespace utils
  fn helper
    return 42
```

```js
const utils = (() => {
  function helper() {
    return 42;
  }
})();
```

## モジュールタイプ設定

デフォルトでは `.purus` ファイルは ES Modules（ESM）としてコンパイルされます。`--type` CLIオプション、`config.purus`、`package.json` を使用してモジュールタイプを CommonJS に設定できます。

### 解決順序

1. CLI `--type` オプション（最優先）
2. `config.purus` の `type` フィールド
3. `package.json` の `type` フィールド
4. デフォルト: `module`（ESM）

### CLIオプション

```sh
purus build --type commonjs
purus build --type module
```

### config.purus

```purus
const type be ///module///
```

または

```purus
const type be ///commonjs///
```

値は `package.json` の `type` フィールドと同じです: `module`（ESM）または `commonjs`（CJS）。

### CommonJS出力

モジュールタイプが `commonjs` に設定されている場合、インポートとエクスポートは CJS 構文にコンパイルされます:

```purus
import express from ///express///
import [Hono] from ///hono///
import all as fs from ///fs///
import ///dotenv/config///
```

```js
const express = require("express");
const { Hono } = require("hono");
const fs = require("fs");
require("dotenv/config");
```

```purus
pub const VERSION be ///1.0///
export default 42
```

```js
const VERSION = "1.0";
exports.VERSION = VERSION;
module.exports = 42;
```

:::note
`.cpurus` ファイルは常に CommonJS（`.cjs`）として、`.mpurus` ファイルは常に ES Modules（`.mjs`）としてコンパイルされます。モジュールタイプ設定に関係なく適用されます。
:::

## CommonJS

```purus
const fs be require[///fs///]
```

```js
const fs = require("fs");
```