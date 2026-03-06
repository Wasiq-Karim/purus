///|
/// Expression parsing for purus parser.
/// Operator precedence (low to high):
///   pipe
///   or
///   and
///   eq/neq/is/instanceof
///   lt/gt/le/ge
///   add/sub
///   mul/div/mod
///   pow
///   unary (not/neg/typeof/await/delete/new)
///   postfix (dot access, index access, method call, function call)
///   primary

///|
fn Parser::parse_expr(self : Parser) -> Expr {
  self.parse_pipe()
}

///|
fn Parser::parse_pipe(self : Parser) -> Expr {
  let mut left = self.parse_coal()
  while self.peek() == Pipe_ {
    self.pos += 1
    let right = self.parse_coal()
    left = Pipe(left, right)
  }
  left
}

///|
fn Parser::parse_coal(self : Parser) -> Expr {
  let mut left = self.parse_or()
  while self.peek() == Coal {
    self.pos += 1
    let right = self.parse_or()
    left = BinOp(Coal, left, right)
  }
  left
}

///|
fn Parser::parse_or(self : Parser) -> Expr {
  let mut left = self.parse_and()
  while self.peek() == Or {
    self.pos += 1
    let right = self.parse_and()
    left = BinOp(Or, left, right)
  }
  left
}

///|
fn Parser::parse_and(self : Parser) -> Expr {
  let mut left = self.parse_equality()
  while self.peek() == And {
    self.pos += 1
    let right = self.parse_equality()
    left = BinOp(And, left, right)
  }
  left
}

///|
fn Parser::parse_equality(self : Parser) -> Expr {
  let mut left = self.parse_comparison()
  while self.pos < self.tokens.length() {
    match self.peek() {
      Eq | Is => {
        self.pos += 1
        if self.is_type_name() {
          let type_name = self.parse_ident_name()
          left = IsCheck(left, type_name)
        } else {
          let right = self.parse_comparison()
          left = BinOp(Eq, left, right)
        }
      }
      Neq => {
        self.pos += 1
        let right = self.parse_comparison()
        left = BinOp(Neq, left, right)
      }
      Not => {
        // "not eq" → Neq
        if self.pos + 1 < self.tokens.length() {
          match self.tokens[self.pos + 1].kind {
            Eq => {
              self.pos += 2
              let right = self.parse_comparison()
              left = BinOp(Neq, left, right)
            }
            _ => break
          }
        } else {
          break
        }
      }
      Instanceof_ => {
        self.pos += 1
        let right = self.parse_comparison()
        left = Instanceof(left, right)
      }
      _ => break
    }
  }
  left
}

///|
fn Parser::is_type_name(self : Parser) -> Bool {
  match self.peek() {
    Ident(s) =>
      match s {
        "string" | "number" | "boolean" | "undefined" | "function" | "symbol" |
        "bigint" | "null" | "object" => true
        _ => s.length() > 0 && s[0] >= 'A' && s[0] <= 'Z'
      }
    _ => false
  }
}

///|
fn Parser::parse_comparison(self : Parser) -> Expr {
  let mut left = self.parse_addition()
  while self.pos < self.tokens.length() {
    match self.peek() {
      Lt => {
        // Check for "lt eq" → Le
        if self.pos + 1 < self.tokens.length() {
          match self.tokens[self.pos + 1].kind {
            Eq => {
              self.pos += 2
              let right = self.parse_addition()
              left = BinOp(Le, left, right)
              continue
            }
            _ => ()
          }
        }
        self.pos += 1
        let right = self.parse_addition()
        left = BinOp(Lt, left, right)
      }
      Gt => {
        // Check for "gt eq" → Ge
        if self.pos + 1 < self.tokens.length() {
          match self.tokens[self.pos + 1].kind {
            Eq => {
              self.pos += 2
              let right = self.parse_addition()
              left = BinOp(Ge, left, right)
              continue
            }
            _ => ()
          }
        }
        self.pos += 1
        let right = self.parse_addition()
        left = BinOp(Gt, left, right)
      }
      Le => {
        self.pos += 1
        let right = self.parse_addition()
        left = BinOp(Le, left, right)
      }
      Ge => {
        self.pos += 1
        let right = self.parse_addition()
        left = BinOp(Ge, left, right)
      }
      _ => break
    }
  }
  left
}

///|
fn Parser::parse_addition(self : Parser) -> Expr {
  let mut left = self.parse_multiplication()
  while self.pos < self.tokens.length() {
    match self.peek() {
      Add => {
        self.pos += 1
        let right = self.parse_multiplication()
        left = BinOp(Add, left, right)
      }
      Sub => {
        self.pos += 1
        let right = self.parse_multiplication()
        left = BinOp(Sub, left, right)
      }
      _ => break
    }
  }
  left
}

///|
fn Parser::parse_multiplication(self : Parser) -> Expr {
  let mut left = self.parse_power()
  while self.pos < self.tokens.length() {
    match self.peek() {
      Mul => {
        self.pos += 1
        let right = self.parse_power()
        left = BinOp(Mul, left, right)
      }
      Div => {
        self.pos += 1
        let right = self.parse_power()
        left = BinOp(Div, left, right)
      }
      Mod => {
        self.pos += 1
        let right = self.parse_power()
        left = BinOp(Mod, left, right)
      }
      _ => break
    }
  }
  left
}

///|
fn Parser::parse_power(self : Parser) -> Expr {
  let left = self.parse_unary()
  // pow is right-associative
  if self.pos < self.tokens.length() && self.peek() == Pow {
    self.pos += 1
    let right = self.parse_power()
    return BinOp(Pow, left, right)
  }
  left
}

///|
fn Parser::parse_unary(self : Parser) -> Expr {
  match self.peek() {
    Not => {
      self.pos += 1
      UnaryNot(self.parse_unary())
    }
    Neg => {
      self.pos += 1
      UnaryNeg(self.parse_unary())
    }
    Typeof_ => {
      self.pos += 1
      UnaryTypeof(self.parse_unary())
    }
    Await_ => {
      self.pos += 1
      AwaitExpr(self.parse_unary())
    }
    New_ => {
      self.pos += 1
      let callee = self.parse_primary()
      // Parse args if present
      if self.peek() == LBracket {
        let args = self.parse_args()
        NewExpr(callee, args)
      } else {
        NewExpr(callee, [])
      }
    }
    _ => self.parse_postfix()
  }
}

///|
fn Parser::parse_postfix(self : Parser) -> Expr {
  let mut expr = self.parse_primary()
  while self.pos < self.tokens.length() {
    match self.peek() {
      Dot => {
        self.pos += 1
        let field = self.parse_ident_name()
        // Check if it's a method call or slice: expr.field[args] or expr.field[start..end]
        if self.peek() == LBracket {
          let saved_dot = self.pos
          self.pos += 1 // skip [
          let start_expr = self.parse_expr()
          match self.peek() {
            DotDot => {
              self.pos += 1
              let end_expr = self.parse_expr()
              if self.peek() == RBracket {
                self.pos += 1
              }
              expr = Slice(DotAccess(expr, field), start_expr, end_expr, true)
            }
            DotDotDot => {
              self.pos += 1
              let end_expr = self.parse_expr()
              if self.peek() == RBracket {
                self.pos += 1
              }
              expr = Slice(DotAccess(expr, field), start_expr, end_expr, false)
            }
            _ => {
              // Not a slice, backtrack and parse as method call
              self.pos = saved_dot
              let args = self.parse_args()
              expr = MethodCall(expr, field, args)
            }
          }
        } else {
          expr = DotAccess(expr, field)
        }
      }
      LBracket => {
        // Could be function call args, index access, or slice
        let saved = self.pos
        self.pos += 1
        match expr {
          Ident(_) | DotAccess(_, _) | MethodCall(_, _, _) | Call(_, _) | IndexAccess(_, _) => {
            // Try slice first: expr[start..end] or expr[start...end]
            let slice_saved = self.pos
            let start_expr = self.parse_expr()
            match self.peek() {
              DotDot => {
                self.pos += 1
                let end_expr = self.parse_expr()
                if self.peek() == RBracket {
                  self.pos += 1
                }
                expr = Slice(expr, start_expr, end_expr, true)
              }
              DotDotDot => {
                self.pos += 1
                let end_expr = self.parse_expr()
                if self.peek() == RBracket {
                  self.pos += 1
                }
                expr = Slice(expr, start_expr, end_expr, false)
              }
              _ => {
                // Not a slice, backtrack and parse as function call
                let _ = slice_saved
                self.pos = saved
                let args = self.parse_args()
                expr = Call(expr, args)
              }
            }
          }
          _ => {
            // Treat as index access - parse integer index
            let index_expr = self.parse_expr()
            if self.peek() == RBracket {
              self.pos += 1
            }
            // For computed access, wrap as method call "get"
            expr = MethodCall(expr, "get", [index_expr])
          }
        }
      }
      As => {
        self.pos += 1
        let type_name = self.parse_ident_name()
        expr = AsCast(expr, type_name)
      }
      _ => break
    }
  }
  expr
}

///|
fn Parser::parse_args(self : Parser) -> Array[Expr] {
  let args : Array[Expr] = []
  if self.peek() != LBracket {
    return args
  }
  self.pos += 1 // skip [
  let mut depth = 1
  while self.pos < self.tokens.length() && depth > 0 {
    if self.peek() == RBracket {
      depth -= 1
      if depth == 0 {
        self.pos += 1
        break
      }
    }
    if self.peek() == LBracket {
      depth += 1
    }
    args.push(self.parse_expr())
    // Skip semicolons between args
    if self.peek() == Semicolon {
      self.pos += 1
    }
    // Also skip commas (for array-like contexts)
    if self.peek() == Comma {
      self.pos += 1
    }
  }
  args
}

///|
fn Parser::parse_primary(self : Parser) -> Expr {
  match self.peek() {
    Int(n) => { self.pos += 1; IntLit(n) }
    Float(n) => { self.pos += 1; FloatLit(n) }
    Str(s) => { self.pos += 1; StrLit(s) }
    InterpStr(segments) => {
      self.pos += 1
      let parts : Array[StrPart] = []
      let mut i = 0
      while i < segments.length() {
        if i % 2 == 0 {
          // Literal part
          if segments[i].length() > 0 {
            parts.push(Lit(segments[i]))
          }
        } else {
          // Expression part - lex and parse it
          let expr_tokens = Lexer::new(segments[i]).tokenize()
          let sub_parser = Parser::new(expr_tokens)
          sub_parser.skip_newlines_and_indent() |> ignore
          let expr = sub_parser.parse_expr()
          parts.push(Interp(expr))
        }
        i += 1
      }
      StrInterp(parts)
    }
    Regex(pattern, flags) => { self.pos += 1; RegexLit(pattern, flags) }
    True_ => { self.pos += 1; BoolLit(true) }
    False_ => { self.pos += 1; BoolLit(false) }
    Null_ | Nil_ => { self.pos += 1; NullLit }
    Undefined_ => { self.pos += 1; UndefinedLit }
    This_ => { self.pos += 1; ThisExpr }
    Ident(s) => {
      self.pos += 1
      Ident(s)
    }
    List_ => {
      // list[...]
      self.pos += 1
      self.parse_list_literal()
    }
    Object_ => {
      // object[...]
      self.pos += 1
      self.parse_object_literal()
    }
    LBracket => {
      // Disambiguate: [] empty array, [be] empty object,
      // [k be v, ...] object, [expr, ...] array, [expr] grouping
      self.parse_bracket_expr()
    }
    Fn => {
      // Anonymous function expression
      self.parse_fn_expr()
    }
    If_ => {
      // Ternary: if COND then EXPR else EXPR
      self.pos += 1
      let cond = self.parse_expr()
      self.expect(Then_)
      let then_expr = self.parse_expr()
      self.expect(Else_)
      let else_expr = self.parse_expr()
      IfExpr(cond, then_expr, else_expr)
    }
    Match_ => {
      // Match expression
      self.pos += 1
      let subject = self.parse_expr()
      let saved = self.pos
      let indent = self.skip_newlines_and_indent()
      let _ = saved
      let arms = self.parse_match_arms(indent)
      MatchExpr(subject, arms)
    }
    Try_ => {
      // Try expression
      self.pos += 1
      let saved_tr = self.pos
      let tr_indent = self.skip_newlines_and_indent()
      let _ = saved_tr
      let try_body = self.parse_block(tr_indent)
      let saved_ca = self.pos
      let _ = self.skip_newlines_and_indent()
      let catch_name : String = match self.peek() {
        Catch_ => {
          self.pos += 1
          match self.peek() {
            Ident(s) => { self.pos += 1; s }
            _ => "e"
          }
        }
        _ => { self.pos = saved_ca; "e" }
      }
      let ca_indent = self.skip_newlines_and_indent()
      let catch_body = self.parse_block(ca_indent)
      TryExpr(try_body, catch_name, catch_body)
    }
    _ => {
      // Unknown token - advance and return undefined
      self.pos += 1
      UndefinedLit
    }
  }
}

///|
fn Parser::parse_list_literal(self : Parser) -> Expr {
  if self.peek() != LBracket {
    return ArrayLit([])
  }
  self.pos += 1 // skip [
  let elements : Array[Expr] = []
  while self.pos < self.tokens.length() && self.peek() != RBracket {
    elements.push(self.parse_expr())
    if self.peek() == Comma {
      self.pos += 1
    }
    if self.peek() == Semicolon {
      self.pos += 1
    }
  }
  if self.peek() == RBracket {
    self.pos += 1
  }
  ArrayLit(elements)
}

///|
fn Parser::parse_object_literal(self : Parser) -> Expr {
  if self.peek() != LBracket {
    return ObjectLit([])
  }
  self.pos += 1 // skip [
  let pairs : Array[(String, Expr)] = []
  while self.pos < self.tokens.length() && self.peek() != RBracket {
    let key = self.parse_ident_name()
    if self.peek() == Be {
      self.pos += 1
      let value = self.parse_expr()
      pairs.push((key, value))
    } else {
      // shorthand: key only → key be key
      pairs.push((key, Ident(key)))
    }
    if self.peek() == Comma {
      self.pos += 1
    }
    if self.peek() == Semicolon {
      self.pos += 1
    }
  }
  if self.peek() == RBracket {
    self.pos += 1
  }
  ObjectLit(pairs)
}

///|
fn Parser::parse_bracket_expr(self : Parser) -> Expr {
  self.pos += 1 // skip [
  // Empty: [] → empty array
  if self.peek() == RBracket {
    self.pos += 1
    return ArrayLit([])
  }
  // [be] → empty object
  if self.peek() == Be {
    self.pos += 1
    if self.peek() == RBracket {
      self.pos += 1
      return ObjectLit([])
    }
    // If not ], put it back
    self.pos -= 1
  }
  // Parse first expression
  let first = self.parse_expr()
  // Check what follows
  match self.peek() {
    DotDot => {
      // Inclusive range: [start .. end]
      self.pos += 1
      let end_expr = self.parse_expr()
      if self.peek() == RBracket {
        self.pos += 1
      }
      RangeArray(first, end_expr, true)
    }
    DotDotDot => {
      // Exclusive range: [start ... end]
      self.pos += 1
      let end_expr = self.parse_expr()
      if self.peek() == RBracket {
        self.pos += 1
      }
      RangeArray(first, end_expr, false)
    }
    Be => {
      // Object literal: [key be value, ...]
      // Need to extract key name from first expr
      let key_name : String = match first {
        Ident(s) => s
        StrLit(s) => s
        _ => "unknown"
      }
      self.pos += 1
      let value = self.parse_expr()
      let pairs : Array[(String, Expr)] = [(key_name, value)]
      while self.peek() == Comma || self.peek() == Semicolon {
        self.pos += 1
        if self.peek() == RBracket { break }
        let k = self.parse_ident_name()
        self.expect(Be)
        let v = self.parse_expr()
        pairs.push((k, v))
      }
      if self.peek() == RBracket {
        self.pos += 1
      }
      ObjectLit(pairs)
    }
    Comma => {
      // Array literal: [a, b, ...]
      let elements : Array[Expr] = [first]
      while self.peek() == Comma {
        self.pos += 1
        if self.peek() == RBracket { break }
        elements.push(self.parse_expr())
      }
      if self.peek() == RBracket {
        self.pos += 1
      }
      ArrayLit(elements)
    }
    Semicolon => {
      // Function call args or array: [a; b; ...]
      let elements : Array[Expr] = [first]
      while self.peek() == Semicolon {
        self.pos += 1
        if self.peek() == RBracket { break }
        elements.push(self.parse_expr())
      }
      if self.peek() == RBracket {
        self.pos += 1
      }
      ArrayLit(elements)
    }
    RBracket => {
      // Single expression in brackets: grouping [expr]
      self.pos += 1
      first
    }
    _ => {
      // Likely just a grouping expression
      if self.peek() == RBracket {
        self.pos += 1
      }
      first
    }
  }
}

///|
fn Parser::parse_fn_expr(self : Parser) -> Expr {
  self.pos += 1 // skip fn
  let params = self.parse_param_list()
  if self.peek() == Gives {
    self.pos += 1
    self.skip_type_annotation()
  }
  if self.peek() == To {
    self.pos += 1
    let body = self.parse_expr()
    FnExprTo(params, body)
  } else {
    let saved = self.pos
    let indent = self.skip_newlines_and_indent()
    let _ = saved
    let stmts = self.parse_block(indent)
    FnExpr(params, stmts)
  }
}
