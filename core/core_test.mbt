// Blackbox tests run against the package's public API. Use `@core` to import.
// Prefer high-level behaviors over implementation details.
// Run `moon test` to execute and `moon test --update` to refresh snapshots.

// Integration tests: full source ↁElex ↁEparse pipeline

test "integration: hello world" {
  let src = "console.log[///Hello, World///]"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: variable + arithmetic" {
  let src =
    #|const x be 10
    #|const y be 20
    #|const z be x add y
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 3)
}

test "integration: function definition" {
  let src =
    #|fn add a; b
    #|  return a add b
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: arrow function with to" {
  let src = "fn double x to x mul 2"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: if-elif-else" {
  let src =
    #|if x lt 0
    #|  console.log[///negative///]
    #|elif x eq 0
    #|  console.log[///zero///]
    #|else
    #|  console.log[///positive///]
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: while loop" {
  let src =
    #|let i be 0
    #|while i lt 10
    #|  i be i add 1
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 2)
}

test "integration: for-in loop" {
  let src =
    #|for item in items
    #|  console.log[item]
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: array and object" {
  let src =
    #|const arr be [1, 2, 3]
    #|const obj be [name be ///alice///, age be 30]
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 2)
}

test "integration: pipe" {
  let src = "const result be data pipe filter pipe map"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: try-catch" {
  let src =
    #|try
    #|  risky[]
    #|catch e
    #|  console.log[e]
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: postfix if" {
  let src = "console.log[///debug///] if verbose"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: import" {
  let src = "import express from ///express///"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "integration: match" {
  let src =
    #|match x
    #|  when 1 then ///one///
    #|  when 2 then ///two///
    #|  else ///other///
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

// ===== Codegen tests: purus source → JavaScript output =====

fn compile(src : String) -> String {
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  @core.JsCodegen::new().generate(stmts, strict=false)
}

test "codegen: const declaration" {
  let js = compile("const x be 42")
  assert_eq(js, "const x = 42;\n")
}

test "codegen: let declaration" {
  let js = compile("let name be ///hello///")
  assert_eq(js, "let name = \"hello\";\n")
}

test "codegen: var declaration" {
  let js = compile("var count be 0")
  assert_eq(js, "var count = 0;\n")
}

test "codegen: arithmetic operators" {
  let js = compile("const z be x add y")
  assert_eq(js, "const z = x + y;\n")
}

test "codegen: comparison operators" {
  let js = compile("const r be a lt b")
  assert_eq(js, "const r = a < b;\n")
}

test "codegen: function call" {
  let js = compile("console.log[///Hello, World///]")
  assert_eq(js, "console.log(\"Hello, World\");\n")
}

test "codegen: named function" {
  let src =
    #|fn greet a; b
    #|  return a add b
  let js = compile(src)
  assert_true(js.contains("function greet"))
  assert_true(js.contains("return a + b;"))
}

test "codegen: arrow function with to" {
  let js = compile("fn double x to x mul 2")
  assert_true(js.contains("function double(x) { x * 2; }"))
}

test "codegen: if-else" {
  let src =
    #|if x gt 0
    #|  console.log[///positive///]
    #|else
    #|  console.log[///negative///]
  let js = compile(src)
  assert_true(js.contains("if (x > 0)"))
  assert_true(js.contains("} else {"))
}

test "codegen: while loop" {
  let src =
    #|while i lt 10
    #|  i be i add 1
  let js = compile(src)
  assert_true(js.contains("while (i < 10)"))
}

test "codegen: for-in loop" {
  let src =
    #|for item in items
    #|  console.log[item]
  let js = compile(src)
  assert_true(js.contains("for (const item of items)"))
}

test "codegen: pipe" {
  let js = compile("const result be data pipe filter")
  assert_eq(js, "const result = filter(data);\n")
}

test "codegen: try-catch" {
  let src =
    #|try
    #|  risky[]
    #|catch e
    #|  console.log[e]
  let js = compile(src)
  assert_true(js.contains("try {"))
  assert_true(js.contains("} catch (e) {"))
}

test "codegen: postfix if" {
  let js = compile("console.log[///debug///] if verbose")
  assert_true(js.contains("if (verbose)"))
  assert_true(js.contains("console.log(\"debug\")"))
}

test "codegen: import default" {
  let js = compile("import express from ///express///")
  assert_eq(js, "import express from \"express\";\n")
}

test "codegen: import with attributes" {
  let js = compile("import pkg from ///./package.json/// with [ type be ///json/// ]")
  assert_eq(js, "import pkg from \"./package.json\" with { type: \"json\" };\n")
}

test "codegen: named import with attributes" {
  let js = compile("import [name; version] from ///./package.json/// with [ type be ///json/// ]")
  assert_eq(js, "import { name, version } from \"./package.json\" with { type: \"json\" };\n")
}

test "codegen: array literal" {
  let js = compile("const arr be [1, 2, 3]")
  assert_eq(js, "const arr = [1, 2, 3];\n")
}

test "codegen: object literal" {
  let js = compile("const obj be [name be ///alice///, age be 30]")
  assert_true(js.contains("name: \"alice\""))
  assert_true(js.contains("age: 30"))
}

test "codegen: boolean and null" {
  let js = compile("const a be true")
  assert_eq(js, "const a = true;\n")
  let js2 = compile("const b be null")
  assert_eq(js2, "const b = null;\n")
}

test "codegen: nan literal" {
  let js = compile("const x be nan")
  assert_eq(js, "const x = NaN;\n")
}

test "codegen: return statement" {
  let src =
    #|fn foo
    #|  return 42
  let js = compile(src)
  assert_true(js.contains("return 42;"))
}

test "codegen: hyphenated ident becomes underscore" {
  let js = compile("const my-var be 10")
  assert_eq(js, "const my_var = 10;\n")
}

test "codegen: assignment" {
  let js = compile("x be 42")
  assert_eq(js, "x = 42;\n")
}

test "codegen: unary not" {
  let js = compile("const r be not x")
  assert_eq(js, "const r = !x;\n")
}

test "codegen: unary neg" {
  let js = compile("const r be neg x")
  assert_eq(js, "const r = -x;\n")
}

test "lexer: shebang at start of file" {
  let src = "#!/usr/bin/env node\nconst x be 1"
  let tokens = @core.Lexer::new(src).tokenize()
  match tokens[0].kind {
    @core.Shebang(s) => assert_eq(s, "#!/usr/bin/env node")
    _ => fail("expected Shebang token")
  }
}

test "lexer: no shebang without #!" {
  let src = "const x be 1"
  let tokens = @core.Lexer::new(src).tokenize()
  match tokens[0].kind {
    @core.Shebang(_) => fail("should not have shebang")
    _ => () // ok
  }
}

test "codegen: header comment" {
  let stmts = @core.Parser::new(
    @core.Lexer::new("const x be 1").tokenize(),
  ).parse()
  let js = @core.JsCodegen::new().generate(
    stmts,
    header="// Generated by Purus 0.1.0",
  )
  assert_true(js.has_prefix("// Generated by Purus 0.1.0\n\"use strict\";\n"))
  assert_true(js.contains("const x = 1;"))
}

test "codegen: shebang before header" {
  let stmts = @core.Parser::new(
    @core.Lexer::new("const x be 1").tokenize(),
  ).parse()
  let js = @core.JsCodegen::new().generate(
    stmts,
    header="// Generated by Purus 0.1.0",
    shebang="#!/usr/bin/env node",
  )
  assert_true(js.has_prefix("#!/usr/bin/env node\n// Generated by Purus 0.1.0\n\"use strict\";\n"))
}

test "codegen: no header when empty" {
  let js = compile("const x be 1")
  assert_eq(js, "const x = 1;\n")
}

// ===== New feature codegen tests =====

test "codegen: neq operator" {
  let js = compile("const r be x neq y")
  assert_eq(js, "const r = x !== y;\n")
}

test "codegen: not eq operator" {
  let js = compile("const r be x not eq y")
  assert_eq(js, "const r = x !== y;\n")
}

test "codegen: pow operator" {
  let js = compile("const r be 2 pow 3")
  assert_eq(js, "const r = 2 ** 3;\n")
}

test "codegen: inclusive range" {
  let js = compile("const r be [0..5]")
  assert_true(js.contains("Array.from"))
  assert_true(js.contains("+ 1"))
}

test "codegen: exclusive range" {
  let js = compile("const r be [0...5]")
  assert_true(js.contains("Array.from"))
  assert_true(not(js.contains("+ 1")))
}

test "codegen: lt eq operator" {
  let js = compile("const r be x lt eq y")
  assert_eq(js, "const r = x <= y;\n")
}

test "codegen: gt eq operator" {
  let js = compile("const r be x gt eq y")
  assert_eq(js, "const r = x >= y;\n")
}

test "codegen: namespace declaration" {
  let src =
    #|namespace utils
    #|  const x be 1
  let js = compile(src)
  assert_true(js.contains("const utils = (() => {"))
}

// ===== Slice tests =====

test "codegen: inclusive slice" {
  let js = compile("const mid be numbers[\\2..4]")
  assert_true(js.contains("numbers.slice(2, 4 + 1)"))
}

test "codegen: exclusive slice" {
  let js = compile("const mid be numbers[\\2...4]")
  assert_true(js.contains("numbers.slice(2, 4)"))
}

test "codegen: splice with array literal" {
  let js = compile("numbers[\\2..4] be [///a///; ///b///; ///c///]")
  assert_true(js.contains("numbers.splice(2, 4 - 2 + 1, \"a\", \"b\", \"c\")"))
}

test "codegen: splice exclusive" {
  let js = compile("numbers[\\2...4] be [///a///; ///b///]")
  assert_true(js.contains("numbers.splice(2, 4 - 2, \"a\", \"b\")"))
}

test "codegen: splice with variable" {
  let js = compile("numbers[\\2..4] be replacement")
  assert_true(js.contains("numbers.splice(2, 4 - 2 + 1, ...replacement)"))
}

// ===== Destructuring tests =====

test "codegen: const destructuring" {
  let js = compile("const [today; tomorrow] be weather")
  assert_true(js.contains("const [today, tomorrow] = weather"))
}

test "codegen: let destructuring" {
  let js = compile("let [x; y; z] be arr")
  assert_true(js.contains("let [x, y, z] = arr"))
}

test "codegen: destructuring swap" {
  let js = compile("[a; b] be [b; a]")
  assert_true(js.contains("[a, b] = [b, a]"))
}

test "codegen: destructuring from array" {
  let js = compile("const [first; second] be [1; 2]")
  assert_true(js.contains("const [first, second] = [1, 2]"))
}

// ===== Optional chaining tests =====

test "codegen: optional dot access" {
  let js = compile("const val be obj\\.name")
  assert_true(js.contains("obj?.name"))
}

test "codegen: optional method call" {
  let js = compile("const val be obj\\.method[1; 2]")
  assert_true(js.contains("obj?.method(1, 2)"))
}

// ===== Computed access tests =====

test "codegen: computed access" {
  let js = compile("const val be arr[\\i]")
  assert_true(js.contains("arr[i]"))
}

test "codegen: computed access string key" {
  let js = compile("const val be obj[\\///key///]")
  assert_true(js.contains("obj[\"key\"]"))
}

// ===== Side-effect import tests =====

test "codegen: side-effect import" {
  let js = compile("import ///dotenv/config///")
  assert_eq(js, "import \"dotenv/config\";\n")
}

// ===== Async fn expression tests =====

test "codegen: async fn expression to" {
  let js = compile("const handler be async fn x to x add 1")
  assert_true(js.contains("async (x) => x + 1"))
}

test "codegen: async fn expression block" {
  let src =
    #|const handler be async fn x
    #|  return x add 1
  let js = compile(src)
  assert_true(js.contains("async (x) => {"))
  assert_true(js.contains("return x + 1;"))
}

// ===== Class declaration tests =====

test "integration: class declaration" {
  let src =
    #|class Animal
    #|  private name
    #|  fn new name
    #|    this.name be name
    #|  fn speak
    #|    console.log[this.name]
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "codegen: basic class" {
  let src =
    #|class Animal
    #|  fn speak
    #|    console.log[///hello///]
  let js = compile(src)
  assert_true(js.contains("class Animal {"))
  assert_true(js.contains("speak()"))
  assert_true(js.contains("console.log(\"hello\")"))
}

test "codegen: class with constructor" {
  let src =
    #|class Animal
    #|  fn new name
    #|    this.name be name
  let js = compile(src)
  assert_true(js.contains("class Animal {"))
  assert_true(js.contains("constructor(name)"))
  assert_true(js.contains("this.name = name"))
}

test "codegen: class with private fields" {
  let src =
    #|class Counter
    #|  private count be 0
    #|  fn increment
    #|    this.count be this.count add 1
    #|  fn get-count to this.count
  let js = compile(src)
  assert_true(js.contains("class Counter {"))
  assert_true(js.contains("#count = 0"))
  assert_true(js.contains("this.#count = this.#count + 1"))
  assert_true(js.contains("get_count()"))
}

test "codegen: class with extends" {
  let src =
    #|class Dog extends Animal
    #|  fn new name
    #|    super[name]
    #|  fn speak
    #|    console.log[///woof///]
  let js = compile(src)
  assert_true(js.contains("class Dog extends Animal {"))
  assert_true(js.contains("constructor(name)"))
  assert_true(js.contains("super(name)"))
  assert_true(js.contains("speak()"))
}

test "codegen: class with static method" {
  let src =
    #|class MathUtil
    #|  static fn sum a; b to a add b
  let js = compile(src)
  assert_true(js.contains("class MathUtil {"))
  assert_true(js.contains("static sum(a, b)"))
}

test "codegen: class with getter and setter" {
  let src =
    #|class Person
    #|  private name
    #|  fn new name
    #|    this.name be name
    #|  get fn name to this.name
    #|  set fn name value
    #|    this.name be value
  let js = compile(src)
  assert_true(js.contains("class Person {"))
  assert_true(js.contains("#name;"))
  assert_true(js.contains("get name()"))
  assert_true(js.contains("this.#name"))
  assert_true(js.contains("set name(value)"))
  assert_true(js.contains("this.#name = value"))
}

test "codegen: class with async method" {
  let src =
    #|class Api
    #|  async fn fetch-data url
    #|    const res be await fetch[url]
    #|    return res.json[]
  let js = compile(src)
  assert_true(js.contains("class Api {"))
  assert_true(js.contains("async fetch_data(url)"))
}

test "codegen: class super expression" {
  let js = compile("const x be super.method[]")
  assert_true(js.contains("super.method()"))
}

// ===== Strict mode tests =====

test "codegen: strict mode default" {
  let src = "const x be 42"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  let js = @core.JsCodegen::new().generate(stmts)
  assert_true(js.contains("\"use strict\";"))
}

test "codegen: strict mode disabled" {
  let src = "const x be 42"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  let js = @core.JsCodegen::new().generate(stmts, strict=false)
  assert_false(js.contains("use strict"))
}

test "codegen: strict mode with header" {
  let src = "const x be 42"
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  let js = @core.JsCodegen::new().generate(stmts, header="// Generated by Purus")
  assert_true(js.contains("// Generated by Purus"))
  assert_true(js.contains("\"use strict\";"))
}

// ===== Lexer class keyword tests =====

// ===== CJS module type tests =====

fn compile_cjs(src : String) -> String {
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  @core.JsCodegen::new(cjs=true).generate(stmts, strict=false)
}

test "cjs: default import" {
  let js = compile_cjs("import express from ///express///")
  assert_eq(js, "const express = require(\"express\");\n")
}

test "cjs: named import" {
  let js = compile_cjs("import [Hono] from ///hono///")
  assert_eq(js, "const { Hono } = require(\"hono\");\n")
}

test "cjs: default + named import" {
  let js = compile_cjs("import axios, [AxiosError] from ///axios///")
  assert_eq(js, "const axios = require(\"axios\");\nconst { AxiosError } = axios;\n")
}

test "cjs: namespace import" {
  let js = compile_cjs("import all as fs from ///fs///")
  assert_eq(js, "const fs = require(\"fs\");\n")
}

test "cjs: side-effect import" {
  let js = compile_cjs("import ///dotenv/config///")
  assert_eq(js, "require(\"dotenv/config\");\n")
}

test "cjs: export default expression" {
  let js = compile_cjs("export default 42")
  assert_eq(js, "module.exports = 42;\n")
}

test "cjs: public const" {
  let js = compile_cjs("public const name be ///hello///")
  assert_eq(js, "const name = \"hello\";\nexports.name = name;\n")
}

test "cjs: public fn" {
  let js = compile_cjs("public fn greet x to console.log[x]")
  assert_eq(js, "function greet(x) { console.log(x); }\nexports.greet = greet;\n")
}

test "cjs: require keyword unchanged" {
  // CjsRequire is a direct AST variant - test via codegen directly
  let stmts : Array[@core.Stmt] = [@core.ImportDecl(@core.CjsRequire("lodash", "lodash"))]
  let js = @core.JsCodegen::new(cjs=true).generate(stmts, strict=false)
  assert_eq(js, "const lodash = require(\"lodash\");\n")
}

test "lexer: class keyword" {
  let lexer = @core.Lexer::new("class")
  let tokens = lexer.tokenize()
  assert_eq(tokens[1].kind, @core.Class_)
}

test "lexer: extends keyword" {
  let lexer = @core.Lexer::new("extends")
  let tokens = lexer.tokenize()
  assert_eq(tokens[1].kind, @core.Extends_)
}

test "lexer: super keyword" {
  let lexer = @core.Lexer::new("super")
  let tokens = lexer.tokenize()
  assert_eq(tokens[1].kind, @core.Super_)
}

test "lexer: static keyword" {
  let lexer = @core.Lexer::new("static")
  let tokens = lexer.tokenize()
  assert_eq(tokens[1].kind, @core.Static_)
}

test "lexer: private keyword" {
  let lexer = @core.Lexer::new("private")
  let tokens = lexer.tokenize()
  assert_eq(tokens[1].kind, @core.Private_)
}

test "lexer: get keyword" {
  let lexer = @core.Lexer::new("get")
  let tokens = lexer.tokenize()
  assert_eq(tokens[1].kind, @core.Get_)
}

test "lexer: set keyword" {
  let lexer = @core.Lexer::new("set")
  let tokens = lexer.tokenize()
  assert_eq(tokens[1].kind, @core.Set_)
}

// ===== witch/case/default tests =====

test "lexer: witch keyword" {
  let lexer = @core.Lexer::new("witch")
  let tokens = lexer.tokenize()
  assert_eq(tokens[1].kind, @core.Witch_)
}

test "lexer: case keyword" {
  let lexer = @core.Lexer::new("case")
  let tokens = lexer.tokenize()
  assert_eq(tokens[1].kind, @core.Case_)
}

test "integration: witch" {
  let src =
    #|witch x
    #|  case 1 then ///one///
    #|  case 2 then ///two///
    #|  default ///other///
  let tokens = @core.Lexer::new(src).tokenize()
  let stmts = @core.Parser::new(tokens).parse()
  assert_eq(stmts.length(), 1)
}

test "codegen: witch/case/default" {
  let src =
    #|witch x
    #|  case 1 then ///one///
    #|  case 2 then ///two///
    #|  default ///other///
  let js = compile(src)
  assert_true(js.contains("if (x === 1)"))
  assert_true(js.contains("\"one\""))
  assert_true(js.contains("\"two\""))
  assert_true(js.contains("\"other\""))
}

test "codegen: witch with block body" {
  let src =
    #|witch status
    #|  case ///ok///
    #|    console.log[///success///]
    #|  case ///error///
    #|    console.log[///failure///]
    #|  default
    #|    console.log[///unknown///]
  let js = compile(src)
  assert_true(js.contains("if (status === \"ok\")"))
  assert_true(js.contains("console.log(\"success\")"))
  assert_true(js.contains("console.log(\"unknown\")"))
}

// ===== to return tests =====

test "codegen: fn to return" {
  let js = compile("fn double x to return x mul 2")
  assert_true(js.contains("function double(x) { return x * 2; }"))
}

test "codegen: class method to return" {
  let src =
    #|class Calc
    #|  fn sum a; b to return a add b
  let js = compile(src)
  assert_true(js.contains("sum(a, b) { return a + b; }"))
}

// ===== public keyword tests =====

test "lexer: public keyword" {
  let lexer = @core.Lexer::new("public")
  let tokens = lexer.tokenize()
  assert_eq(tokens[1].kind, @core.Public_)
}

test "codegen: public const" {
  let js = compile("public const name be ///hello///")
  assert_true(js.contains("export const name = \"hello\";"))
}

test "codegen: public fn" {
  let js = compile("public fn greet x to console.log[x]")
  assert_true(js.contains("export function greet(x)"))
}

// ===== from...import tests =====

test "codegen: from import default" {
  let js = compile("from ///express/// import express")
  assert_true(js.contains("import express from \"express\";"))
}

test "codegen: from import named" {
  let js = compile("from ///react/// import [useState, useEffect]")
  assert_true(js.contains("import { useState, useEffect } from \"react\";"))
}

test "codegen: from import namespace" {
  let js = compile("from ///fs/// import all as fs")
  assert_true(js.contains("import * as fs from \"fs\";"))
}

test "codegen: from import default and named" {
  let js = compile("from ///react/// import React, [useState]")
  assert_true(js.contains("import React, { useState } from \"react\";"))
}

test "cjs: from import default" {
  let js = compile_cjs("from ///express/// import express")
  assert_eq(js, "const express = require(\"express\");\n")
}

test "codegen: from import with attributes" {
  let js = compile("from ///./data.json/// import data with [ type be ///json/// ]")
  assert_true(js.contains("import data from \"./data.json\" with { type: \"json\" };"))
}

test "codegen: from import named with attributes" {
  let js = compile("from ///./package.json/// import [name, version] with [ type be ///json/// ]")
  assert_true(js.contains("import { name, version } from \"./package.json\" with { type: \"json\" };"))
}

// ===== type check with typeof =====

test "codegen: typeof type check" {
  let js = compile("if typeof x eq ///string/// then console.log[x]")
  assert_true(js.contains("typeof x === \"string\""))
}
