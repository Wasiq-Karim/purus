///|
/// Expression code generation for the purus JS codegen.

///|
fn JsCodegen::gen_expr(self : JsCodegen, expr : Expr) -> Unit {
  match expr {
    IntLit(n) => self.write(n.to_string())
    FloatLit(f) => self.write(f.to_string())
    StrLit(s) => {
      self.write("\"")
      self.write(js_escape_str(s))
      self.write("\"")
    }
    StrInterp(parts) => {
      self.write("`")
      for part in parts {
        match part {
          Lit(s) => self.write(js_escape_template(s))
          Interp(expr) => {
            self.write("${")
            self.gen_expr(expr)
            self.write("}")
          }
        }
      }
      self.write("`")
    }
    RegexLit(pattern, flags) => {
      self.write("/")
      self.write(pattern)
      self.write("/")
      self.write(flags)
    }
    BoolLit(b) =>
      self.write(
        if b {
          "true"
        } else {
          "false"
        },
      )
    NullLit => self.write("null")
    UndefinedLit => self.write("undefined")
    ArrayLit(elems) => {
      self.write("[")
      let mut first = true
      for e in elems {
        if not(first) {
          self.write(", ")
        }
        self.gen_expr(e)
        first = false
      }
      self.write("]")
    }
    RangeArray(start, end, inclusive) => {
      // Generate: Array.from({length: end - start (+ 1 if inclusive)}, (_, i) => i + start)
      self.write("Array.from({ length: ")
      self.gen_expr_wrap(end)
      self.write(" - ")
      self.gen_expr_wrap(start)
      if inclusive {
        self.write(" + 1")
      }
      self.write(" }, (_, i) => i + ")
      self.gen_expr_wrap(start)
      self.write(")")
    }
    Slice(obj, start, end, inclusive) => {
      // arr[start..end] → arr.slice(start, end + 1) (inclusive)
      // arr[start...end] → arr.slice(start, end) (exclusive)
      self.gen_expr_wrap(obj)
      self.write(".slice(")
      self.gen_expr(start)
      self.write(", ")
      if inclusive {
        self.gen_expr_wrap(end)
        self.write(" + 1")
      } else {
        self.gen_expr(end)
      }
      self.write(")")
    }
    ObjectLit(pairs) => {
      if pairs.is_empty() {
        self.write("{}")
        return
      }
      self.write("{ ")
      let mut first = true
      for pair in pairs {
        if not(first) {
          self.write(", ")
        }
        let key = pair.0
        let value = pair.1
        // Check if key is a valid JS identifier
        if is_valid_js_ident(key) {
          self.write(key)
        } else {
          self.write("\"")
          self.write(js_escape_str(key))
          self.write("\"")
        }
        self.write(": ")
        self.gen_expr(value)
        first = false
      }
      self.write(" }")
    }
    Ident(name) => self.write(js_ident(name))
    DotAccess(obj, field) => {
      self.gen_expr_wrap(obj)
      self.write(".")
      self.write(field)
    }
    IndexAccess(obj, index) => {
      self.gen_expr_wrap(obj)
      self.write("[")
      self.write(index.to_string())
      self.write("]")
    }
    BinOp(op, left, right) => {
      self.gen_expr_wrap(left)
      self.write(" ")
      self.write(js_binop(op))
      self.write(" ")
      self.gen_expr_wrap(right)
    }
    UnaryNeg(inner) => {
      self.write("-")
      self.gen_expr_wrap(inner)
    }
    UnaryNot(inner) => {
      self.write("!")
      self.gen_expr_wrap(inner)
    }
    UnaryTypeof(inner) => {
      self.write("typeof ")
      self.gen_expr(inner)
    }
    IsCheck(expr, type_name) => {
      // is → typeof check for primitives, instanceof for classes
      match type_name {
        "string" | "number" | "boolean" | "undefined" | "function" | "symbol" |
        "bigint" => {
          self.write("typeof ")
          self.gen_expr(expr)
          self.write(" === \"")
          self.write(type_name)
          self.write("\"")
        }
        "null" => {
          self.gen_expr(expr)
          self.write(" === null")
        }
        _ => {
          self.gen_expr(expr)
          self.write(" instanceof ")
          self.write(type_name)
        }
      }
    }
    AsCast(expr, _type_name) => {
      // Type casts are erased in JS
      self.gen_expr(expr)
    }
    Instanceof(expr, type_expr) => {
      self.gen_expr(expr)
      self.write(" instanceof ")
      self.gen_expr(type_expr)
    }
    FnExpr(params, body) => {
      self.write("(")
      let mut first = true
      for p in params {
        if not(first) {
          self.write(", ")
        }
        self.write(js_ident(p))
        first = false
      }
      self.write(") => {\n")
      self.indent_level += 1
      for s in body {
        self.gen_stmt(s)
      }
      self.indent_level -= 1
      self.write_indent()
      self.write("}")
    }
    FnExprTo(params, body_expr) => {
      self.write("(")
      let mut first = true
      for p in params {
        if not(first) {
          self.write(", ")
        }
        self.write(js_ident(p))
        first = false
      }
      self.write(") => ")
      self.gen_expr(body_expr)
    }
    Call(callee, args) => {
      self.gen_expr_wrap(callee)
      self.write("(")
      let mut first = true
      for a in args {
        if not(first) {
          self.write(", ")
        }
        self.gen_expr(a)
        first = false
      }
      self.write(")")
    }
    MethodCall(obj, meth_name, args) => {
      self.gen_expr_wrap(obj)
      self.write(".")
      self.write(meth_name)
      self.write("(")
      let mut first = true
      for a in args {
        if not(first) {
          self.write(", ")
        }
        self.gen_expr(a)
        first = false
      }
      self.write(")")
    }
    NewExpr(callee, args) => {
      self.write("new ")
      self.gen_expr(callee)
      self.write("(")
      let mut first = true
      for a in args {
        if not(first) {
          self.write(", ")
        }
        self.gen_expr(a)
        first = false
      }
      self.write(")")
    }
    Pipe(left, right) => {
      // a pipe b → b(a)
      match right {
        Call(callee, args) => {
          // a pipe f(x, y) → f(a, x, y)
          self.gen_expr(callee)
          self.write("(")
          self.gen_expr(left)
          if not(args.is_empty()) {
            self.write(", ")
            let mut first = true
            for a in args {
              if not(first) {
                self.write(", ")
              }
              self.gen_expr(a)
              first = false
            }
          }
          self.write(")")
        }
        MethodCall(_, meth_name, args) => {
          // a pipe .method(x) → a.method(x)
          self.gen_expr_wrap(left)
          self.write(".")
          self.write(meth_name)
          self.write("(")
          let mut first = true
          for a in args {
            if not(first) {
              self.write(", ")
            }
            self.gen_expr(a)
            first = false
          }
          self.write(")")
        }
        Ident(_) => {
          // a pipe f → f(a)
          self.gen_expr(right)
          self.write("(")
          self.gen_expr(left)
          self.write(")")
        }
        _ => {
          // fallback: right(left)
          self.gen_expr(right)
          self.write("(")
          self.gen_expr(left)
          self.write(")")
        }
      }
    }
    IfExpr(cond, then_expr, else_expr) => {
      self.gen_expr(cond)
      self.write(" ? ")
      self.gen_expr(then_expr)
      self.write(" : ")
      self.gen_expr(else_expr)
    }
    TryExpr(try_body, catch_name, catch_body) => {
      // try expression → IIFE
      self.write("(() => { try {\n")
      self.indent_level += 1
      for s in try_body {
        self.gen_stmt(s)
      }
      self.indent_level -= 1
      self.write_indent()
      self.write("} catch (")
      self.write(js_ident(catch_name))
      self.write(") {\n")
      self.indent_level += 1
      for s in catch_body {
        self.gen_stmt(s)
      }
      self.indent_level -= 1
      self.write_indent()
      self.write("} })()")
    }
    MatchExpr(subject, arms) => {
      // match expression → IIFE with if-else chain
      self.write("(() => {\n")
      self.indent_level += 1
      // Bind subject to temp
      self.write_indent()
      self.write("const __m = ")
      self.gen_expr(subject)
      self.write(";\n")
      let mut first = true
      for arm in arms {
        self.write_indent()
        if not(first) {
          self.write("else ")
        }
        match arm.pattern {
          LitPat(lit) => {
            self.write("if (__m === ")
            self.gen_expr(lit)
            match arm.cond {
              Some(c) => {
                self.write(" && ")
                self.gen_expr(c)
              }
              None => ()
            }
            self.write(") {\n")
          }
          BindPat(name) => {
            if name == "_" {
              self.write("{\n")
            } else {
              self.write("if (true) { const ")
              self.write(js_ident(name))
              self.write(" = __m;\n")
            }
          }
        }
        self.indent_level += 1
        match arm.body {
          ExprBody(expr) => {
            self.write_indent()
            self.write("return ")
            self.gen_expr(expr)
            self.write(";\n")
          }
          BlockBody(stmts) => {
            for s in stmts {
              self.gen_stmt(s)
            }
          }
        }
        self.indent_level -= 1
        self.writeln("}")
        first = false
      }
      self.indent_level -= 1
      self.write_indent()
      self.write("})()")
    }
    AwaitExpr(inner) => {
      self.write("await ")
      self.gen_expr(inner)
    }
    DeleteExpr(inner) => {
      self.write("delete ")
      self.gen_expr(inner)
    }
    ThisExpr => self.write("this")
  }
}

///|
/// Wrap expression in parens if it's a binary op, unary, or other compound expr
fn JsCodegen::gen_expr_wrap(self : JsCodegen, expr : Expr) -> Unit {
  match expr {
    BinOp(_, _, _) | UnaryNeg(_) | UnaryNot(_) | IfExpr(_, _, _) | Pipe(_, _) => {
      self.write("(")
      self.gen_expr(expr)
      self.write(")")
    }
    _ => self.gen_expr(expr)
  }
}

///|
/// Convert a binary operator to its JS equivalent
fn js_binop(op : BinOp) -> String {
  match op {
    Add => "+"
    Sub => "-"
    Mul => "*"
    Div => "/"
    Mod => "%"
    Pow => "**"
    Eq => "==="
    Neq => "!=="
    Lt => "<"
    Gt => ">"
    Le => "<="
    Ge => ">="
    And => "&&"
    Or => "||"
    Coal => "??"
  }
}

///|
/// Convert purus identifier to valid JS identifier
/// Replaces hyphens with underscores
fn js_ident(name : String) -> String {
  name.replace_all(old="-", new="_")
}

///|
/// Escape a string for JavaScript string literals
fn js_escape_str(s : String) -> String {
  let buf = StringBuilder::new()
  let chars = s.to_array()
  for c in chars {
    match c {
      '\\' => buf.write_string("\\\\")
      '"' => buf.write_string("\\\"")
      '\n' => buf.write_string("\\n")
      '\r' => buf.write_string("\\r")
      '\t' => buf.write_string("\\t")
      _ => buf.write_char(c)
    }
  }
  buf.to_string()
}

///|
/// Escape for JS template literals (backtick strings)
fn js_escape_template(s : String) -> String {
  let buf = StringBuilder::new()
  let chars = s.to_array()
  for c in chars {
    match c {
      '\\' => buf.write_string("\\\\")
      '`' => buf.write_string("\\`")
      '$' => buf.write_string("\\$")
      _ => buf.write_char(c)
    }
  }
  buf.to_string()
}

///|
/// Check if a string is a valid JS identifier
fn is_valid_js_ident(s : String) -> Bool {
  if s.length() == 0 {
    return false
  }
  let chars = s.to_array()
  let first = chars[0]
  if not(is_alpha_codegen(first)) && first != '_' && first != '$' {
    return false
  }
  let mut i = 1
  while i < chars.length() {
    let c = chars[i]
    if not(is_alpha_codegen(c)) && not(c >= '0' && c <= '9') && c != '_' && c != '$' {
      return false
    }
    i += 1
  }
  true
}

///|
fn is_alpha_codegen(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
}
