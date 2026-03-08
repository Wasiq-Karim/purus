# Changelog

Change history for Purus syntax, specifications, and reserved keywords.

---

## v0.7.0 (2026-03-08)

### Breaking Changes

- **Removed implicit return from named functions**: `fn name args to expr` now compiles to `{ expr; }` instead of `{ return expr; }`. Use block body + explicit `return` to return values. Anonymous functions (`fn args to expr` → `(args) => expr`) are not affected.

  ```purus
  -- Before (v0.6.x): implicit return
  fn double x to x mul 2
  -- Compiled: function double(x) { return x * 2; }

  -- After (v0.7.0): no implicit return
  fn double x to x mul 2
  -- Compiled: function double(x) { x * 2; }

  -- Migration: use block body + explicit return
  fn double x
    return x mul 2
  -- Compiled: function double(x) { return x * 2; }
  ```

  This also applies to class methods and `static fn` / `get fn` / `set fn`.

### New Features

- **`nan` keyword**: Added the `nan` literal keyword, which compiles to JavaScript's `NaN`.
  ```purus
  const value be nan          -- const value = NaN;
  x eq nan                    -- x === NaN
  ```
- **`with` keyword (Import Attributes)**: Added import attributes via `import ... from ... with [ key be value ]` syntax. Compiles to JavaScript's `import ... from "..." with { key: value }`.
  ```purus
  import data from ///./data.json/// with [ type be ///json/// ]
  -- import data from "./data.json" with { type: "json" };

  import [name; version] from ///./package.json/// with [ type be ///json/// ]
  -- import { name, version } from "./package.json" with { type: "json" };

  import ///./styles.css/// with [ type be ///css/// ]
  -- import "./styles.css" with { type: "css" };
  ```

### Bug Fixes

- **`match` guard + `BindPat` fix**: Fixed a scoping error in code generation when `when n if cond` pattern used `n` as a binding variable. The variable `n` was being declared inside the `if` block but referenced in the guard condition. Changed to pre-declaration approach: binding variables are declared before the `if-else` chain.
  ```purus
  match value
    when n if n gt 0
      console.log[///positive///]
    when _
      console.log[///other///]
  ```
  ```js
  // Before (broken): n was not in scope for the guard
  // After (fixed): const n = value; is pre-declared
  {
    const n = value;
    if (n > 0) { console.log("positive"); }
    else { console.log("other"); }
  }
  ```

### Keywords Added

| Keyword | Purpose |
|---|---|
| `nan` | NaN literal |
| `with` | Import Attributes |

---

## v0.6.1 (2026-03-07)

### Changes

- Package metadata fix (for npm publish).
- No syntax or keyword changes.

---

## v0.6.0 (2026-03-07)

### New Features

- **Class syntax**: Added `class` / `extends` / `super` / `static` / `private` / `get` / `set` keywords. Compiles to JavaScript ES6 classes.
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
- **`super` expression**: Added `super` as an expression for calling parent class constructors and methods.
  ```purus
  class Dog extends Animal
    fn constructor name
      super[name]
  ```
- **Inheritance**: `class Child extends Parent` compiles to JavaScript's `class Child extends Parent`.

### Keywords Added

| Keyword | JS Output | Purpose |
|---|---|---|
| `class` | `class` | Class declaration |
| `extends` | `extends` | Inheritance |
| `super` | `super` | Parent class reference |
| `static` | `static` | Static method |
| `private` | `#` (private field) | Private field |
| `get` | `get` | Getter |
| `set` | `set` | Setter |

---

## v0.5.0 (2026-03-07)

### New Features

- **`coal` (Nullish Coalescing)**: `a coal b` compiles to `a ?? b`.
  ```purus
  const name be user.name coal ///anonymous///
  -- const name = user.name ?? "anonymous";
  ```
- **Optional chaining**: `obj\.field` → `obj?.field`, `obj\.method[args]` → `obj?.method(args)`.
  ```purus
  const name be user\.profile\.name
  -- const name = user?.profile?.name;
  user\.greet[///hello///]
  -- user?.greet("hello");
  ```
- **Computed property access**: `obj[\key]` → `obj[key]`.
  ```purus
  const val be obj[\key]
  -- const val = obj[key];
  ```
- **String interpolation**: `///Hello [name]!///` compiles to template literals. Square brackets `[expr]` inside triple-slash strings are interpolated.
  ```purus
  const msg be ///Hello [name]! You are [age] years old.///
  -- const msg = `Hello ${name}! You are ${age} years old.`;
  ```
- **Side-effect import**: `import ///module///` → `import "module"` for imports that only execute side effects.
  ```purus
  import ///./polyfill.js///
  -- import "./polyfill.js";
  ```
- **`async fn` expression**: Support for `async fn x to expr` and `async fn` block body as expressions (e.g., in variable assignment).
  ```purus
  const fetchData be async fn url to await fetch[url]
  -- const fetchData = async (url) => await fetch(url);
  ```
- **Object destructuring**: `const object[a; b] be expr` → `const { a, b } = expr`. Uses the `object` keyword prefix to distinguish from array destructuring.
  ```purus
  const object[name; age] be person
  -- const { name, age } = person;
  ```
- **Underscore identifiers**: Support for identifiers starting with underscore like `_variable`, `_private`, `__internal`.

### Punctuation Added

| Symbol | Purpose |
|---|---|
| `\` | Computed property access prefix |
| `\.` | Optional chaining |

### Keywords Added

| Keyword | JS Output | Purpose |
|---|---|---|
| `coal` | `??` | Nullish Coalescing |

---

## v0.4.1 (2026-03-06)

### Changes

- Added version sync script for consistent versioning across packages.
- No syntax or keyword changes.

---

## v0.4.0 (2026-03-06)

### Breaking Changes

- **`ne` → `neq` renamed**: The inequality operator keyword was renamed from `ne` to `neq`. All existing code using `ne` must be updated to `neq`.
  ```purus
  -- Before (v0.3.x)
  x ne y           -- x !== y

  -- After (v0.4.0)
  x neq y          -- x !== y
  x not eq y       -- x !== y (alternative)
  ```

### New Features

- **`pow` operator**: `a pow b` compiles to `a ** b`. Right-associative precedence, higher than `mul`/`div`/`mod`.
  ```purus
  2 pow 10         -- 2 ** 10
  x pow y pow z    -- x ** (y ** z)  (right-associative)
  ```
- **`not eq` operator composition**: `not eq` is parsed as `neq` (`!==`). Similarly, `lt eq` → `le` (`<=`) and `gt eq` → `ge` (`>=`).
  ```purus
  x not eq y       -- x !== y
  x lt eq y        -- x <= y
  x gt eq y        -- x >= y
  ```
- **Range arrays**: `[start..end]` (inclusive) / `[start...end]` (exclusive) generates arrays using `Array.from()`.
  ```purus
  [1..5]           -- Array.from({ length: 5 - 1 + 1 }, (_, i) => i + 1)  → [1,2,3,4,5]
  [0...5]          -- Array.from({ length: 5 - 0 }, (_, i) => i + 0)      → [0,1,2,3,4]
  ```
- **Slicing**: `arr[start..end]` / `arr[start...end]` compiles to `.slice()`. Slice assignment compiles to `.splice()`.
  ```purus
  arr[1..3]        -- arr.slice(1, 3 + 1)
  arr[1...3]       -- arr.slice(1, 3)
  arr[1..3] be [7; 8; 9]  -- arr.splice(1, 3 - 1 + 1, 7, 8, 9)
  ```
- **Array destructuring**: `const [a; b] be arr` → `const [a, b] = arr`.
  ```purus
  const [first; second] be arr
  -- const [first, second] = arr;
  ```
- **`namespace` keyword**: `namespace name` block compiles to an IIFE (Immediately Invoked Function Expression).
  ```purus
  namespace Utils
    pub fn helper
      return 42
  ```
- **`purus check` command**: Added CLI command for syntax checking without generating output files.

### Punctuation Added

| Symbol | Purpose |
|---|---|
| `..` | Inclusive range |
| `...` | Exclusive range |

### Keywords Added / Changed

| Keyword | Change |
|---|---|
| `pow` | Added (exponentiation operator) |
| `neq` | Renamed from `ne` |
| `namespace` | Added (module namespace, alias for `use`) |

---

## v0.3.0 (2026-03-06)

### Changes

- **`purus version` command**: Added `version` / `--version` / `-v` CLI commands.
- **Build refactoring**: Single-file build now uses the compile API directly instead of delegating to the MoonBit compiler. Header comment generation moved to the JS wrapper layer.
- **`purus new` prompt change**: Default answer for "Install dependencies?" changed from No to Yes.
- No syntax or keyword changes.

---

## v0.2.1 (2026-03-06)

### Changes

- Package metadata fix (README links).
- No syntax or keyword changes.

---

## v0.2.0 (2026-03-06)

### New Features

- **CLI tools**: Added full CLI interface with the following commands:
  - `purus build [file]` — Compile to JavaScript
  - `purus build --directory <dir>` — Compile all files in a directory
  - `purus build --output <dir>` — Specify output directory
  - `purus build --no-header` — Compile without header comment
  - `purus build --stdout` — Output to stdout
  - `purus run [file]` — Run without generating files
  - `purus new [name] [-y]` / `purus create` — Create a new project
  - `purus init` — Initialize project in current directory
  - `purus help` — Show help
- **Config file**: Added `config.purus` configuration file support for project-level build settings.
- **File extension mapping**: `.purus` → `.js`, `.cpurus` → `.cjs` (CommonJS), `.mpurus` → `.mjs` (ES Module).
- Removed `purus.json` project file (replaced by `config.purus`).

### Changes

- No syntax or keyword changes.

---

## v0.1.0 (2026-03-06)

### Bug Fixes

- **`eq` / `is` parse fix**: Previously, `eq` and `is` had separate parse paths — `eq` always produced a binary equality (`===`), while `is` produced a `typeof` check. Fixed `eq` to also generate a type check (`IsCheck`) when the next token is a recognized type name. Both `eq` and `is` now behave identically.
  ```purus
  -- Before (v0.0.x): eq always produced ===
  x eq string      -- x === string  (wrong — compared to variable)

  -- After (v0.1.0): eq detects type names
  x eq string      -- typeof x === "string"  (type check)
  x is string      -- typeof x === "string"  (same behavior)
  ```
  Recognized type names: `string`, `number`, `boolean`, `undefined`, `function`, `symbol`, `bigint`, `null`, `object`, and PascalCase identifiers (e.g., `Array`, `Date`).

### Changes

- No syntax or keyword changes.

---

## v0.0.3 (2026-03-06)

### Changes

- Package version fix.
- No syntax or keyword changes.

---

## v0.0.2 (2026-03-06)

### Changes

- README link fix, package file configuration fix.
- No syntax or keyword changes.

---

## v0.0.1 (2026-03-06)

### Initial Release

First release of the Purus language.

#### Literals

- Integer, float, string (`///...///`), regex (`///regex///`), `true` / `false`, `null` / `nil` / `undefined`
- Array `[1; 2; 3]`, object `[key be value]`

#### Variable Declaration

- `const` / `let` / `var` + `be` (assignment keyword)
  ```purus
  const name be ///Purus///    -- const name = "Purus";
  let count be 0               -- let count = 0;
  ```

#### Operators (keyword-style)

| Keyword | JS Output | Purpose |
|---|---|---|
| `add` | `+` | Addition / string concatenation |
| `sub` | `-` | Subtraction |
| `mul` | `*` | Multiplication |
| `div` | `/` | Division |
| `mod` | `%` | Modulo |
| `neg` | `-` (unary) | Negation |
| `eq` | `===` | Equality |
| `ne` | `!==` | Inequality |
| `lt` | `<` | Less than |
| `gt` | `>` | Greater than |
| `le` | `<=` | Less than or equal |
| `ge` | `>=` | Greater than or equal |
| `and` | `&&` | Logical AND |
| `or` | `\|\|` | Logical OR |
| `not` | `!` | Logical NOT |

#### Functions

- `fn` / `return` / `to` (expression body) / `gives` (type annotation) / `async` / `await`
  ```purus
  fn greet name to console.log[name]
  -- function greet(name) { return console.log(name); }

  fn add a b
    return a add b
  -- function add(a, b) { return a + b; }
  ```

#### Control Flow

- `if` / `elif` / `else` / `unless` / `then` (inline)
- `while` / `until` / `for` / `in` / `range`
- `break` / `continue`
- `match` / `when` (pattern matching)
- `pipe` (pipe operator `|>`)

#### Postfix Modifiers

- `stmt if cond` / `stmt unless cond` / `stmt for x in arr`
  ```purus
  console.log[x] if x gt 0
  -- if (x > 0) { console.log(x); }
  ```

#### Error Handling

- `try` / `catch` / `finally` / `throw`

#### Type-related

- `is` / `as` / `of` (type annotation) / `typeof` / `instanceof` / `type` (type alias)

#### Objects

- `new` / `delete` / `this`

#### Modules

- `import` / `from` / `export` / `default` / `require`
- `use` (dot-path import)
- `pub` (public export modifier)
- `all` (namespace import: `import all as name from ...`)

#### Separators

- `;` (semicolon) and `,` (comma) are interchangeable as separators

#### Reserved Keywords

- `list` / `object` (reserved for explicit constructors)

#### Other

- Shebang support (`#!` line is preserved)
- `// comment` style comments via `-- comment`

#### Separators

| Symbol | Purpose |
|---|---|
| `[` / `]` | Function calls / arrays / objects |
| `,` | Array / object separator |
| `;` | Arguments / parameters / destructuring separator |
| `.` | Property access |
