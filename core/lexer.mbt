///|
/// Lexer for the purus language.
/// Converts source text into a stream of tokens.
pub(all) struct Lexer {
  chars : Array[Char]
  mut pos : Int
  mut line : Int
  mut col : Int
  mut tokens : Array[Token]
}

///|
pub fn Lexer::new(source : String) -> Lexer {
  let chars = source.to_array()
  { chars, pos: 0, line: 1, col: 1, tokens: [] }
}

///|
fn Lexer::peek(self : Lexer) -> Char {
  if self.pos >= self.chars.length() {
    '\u0000'
  } else {
    self.chars[self.pos]
  }
}

///|
fn Lexer::peek_at(self : Lexer, offset : Int) -> Char {
  let i = self.pos + offset
  if i >= self.chars.length() {
    '\u0000'
  } else {
    self.chars[i]
  }
}

///|
fn Lexer::advance(self : Lexer) -> Char {
  let ch = self.peek()
  self.pos += 1
  if ch == '\n' {
    self.line += 1
    self.col = 1
  } else {
    self.col += 1
  }
  ch
}

///|
fn Lexer::emit(self : Lexer, kind : TokenKind, line : Int, col : Int) -> Unit {
  self.tokens.push({ kind, line, col })
}

///|
fn is_ident_start(ch : Char) -> Bool {
  (ch >= 'a' && ch <= 'z') ||
    (ch >= 'A' && ch <= 'Z') ||
    ch == '-' || // purus allows hyphens in idents
    ch == '_' // purus allows underscores in idents
}

///|
fn is_ident_char(ch : Char) -> Bool {
  is_ident_start(ch) || (ch >= '0' && ch <= '9')
}

///|
fn is_digit(ch : Char) -> Bool {
  ch >= '0' && ch <= '9'
}

///|
fn parse_int(s : String) -> Int {
  let chars = s.to_array()
  let mut result = 0
  let mut i = 0
  let negative = chars.length() > 0 && chars[0] == '-'
  if negative {
    i = 1
  }
  while i < chars.length() {
    result = result * 10 + (chars[i].to_int() - '0'.to_int())
    i += 1
  }
  if negative { -result } else { result }
}

///|
fn parse_double(s : String) -> Double {
  let chars = s.to_array()
  let mut integer_part = 0.0
  let mut i = 0
  let negative = chars.length() > 0 && chars[0] == '-'
  if negative {
    i = 1
  }
  while i < chars.length() && chars[i] != '.' {
    integer_part = integer_part * 10.0 + (chars[i].to_int() - '0'.to_int()).to_double()
    i += 1
  }
  let mut frac_part = 0.0
  if i < chars.length() && chars[i] == '.' {
    i += 1
    let mut divisor = 10.0
    while i < chars.length() {
      frac_part = frac_part + (chars[i].to_int() - '0'.to_int()).to_double() / divisor
      divisor = divisor * 10.0
      i += 1
    }
  }
  let result = integer_part + frac_part
  if negative { -result } else { result }
}

///|
/// Tokenize the entire source into a list of tokens.
pub fn Lexer::tokenize(self : Lexer) -> Array[Token] {
  // Handle shebang at very start of file
  if self.pos == 0 && self.peek() == '#' && self.peek_at(1) == '!' {
    self.scan_shebang()
  }
  // Process leading indentation on the first line
  self.scan_line_start()
  while self.pos < self.chars.length() {
    let ch = self.peek()
    if ch == '\n' {
      let line = self.line
      let col = self.col
      self.advance() |> ignore
      self.emit(Newline, line, col)
      self.scan_line_start()
      continue
    }
    if ch == ' ' || ch == '\t' || ch == '\r' {
      self.advance() |> ignore
      continue
    }
    // Line comment --
    if ch == '-' && self.peek_at(1) == '-' && self.peek_at(2) == '-' {
      self.scan_block_comment()
      continue
    }
    if ch == '-' && self.peek_at(1) == '-' {
      self.scan_line_comment()
      continue
    }
    // String ///...///
    if ch == '/' && self.peek_at(1) == '/' && self.peek_at(2) == '/' {
      self.scan_string()
      continue
    }
    // Regex /.../ but not //
    if ch == '/' && self.peek_at(1) != '/' {
      self.scan_regex()
      continue
    }
    // Numbers (and negative literals)
    if is_digit(ch) {
      self.scan_number()
      continue
    }
    if ch == '-' && is_digit(self.peek_at(1)) {
      // Check if this is a negative number literal (not subtraction)
      // It's a negative literal if it's at start, or after certain tokens
      if self.is_neg_literal_context() {
        self.scan_number()
        continue
      }
    }
    // Punctuation
    if ch == '[' {
      let line = self.line
      let col = self.col
      self.advance() |> ignore
      self.emit(LBracket, line, col)
      continue
    }
    if ch == ']' {
      let line = self.line
      let col = self.col
      self.advance() |> ignore
      self.emit(RBracket, line, col)
      continue
    }
    if ch == ',' {
      let line = self.line
      let col = self.col
      self.advance() |> ignore
      self.emit(Comma, line, col)
      continue
    }
    if ch == ';' {
      let line = self.line
      let col = self.col
      self.advance() |> ignore
      self.emit(Semicolon, line, col)
      continue
    }
    if ch == '.' {
      let line = self.line
      let col = self.col
      self.advance() |> ignore
      // Check for .. (inclusive range) and ... (exclusive range)
      if self.peek() == '.' {
        self.advance() |> ignore
        if self.peek() == '.' {
          self.advance() |> ignore
          self.emit(DotDotDot, line, col)
        } else {
          self.emit(DotDot, line, col)
        }
      } else {
        self.emit(Dot, line, col)
      }
      continue
    }
    // Identifiers and keywords
    if is_ident_start(ch) && ch != '-' && ch != '_' {
      self.scan_ident()
      continue
    }
    // Underscored identifiers
    if ch == '_' {
      self.scan_ident()
      continue
    }
    // Skip unknown characters
    self.advance() |> ignore
  }
  self.emit(Eof, self.line, self.col)
  self.tokens
}

///|
fn Lexer::scan_shebang(self : Lexer) -> Unit {
  let line = self.line
  let col = self.col
  let buf = StringBuilder::new()
  while self.pos < self.chars.length() && self.peek() != '\n' {
    buf.write_char(self.advance())
  }
  self.emit(Shebang(buf.to_string()), line, col)
  // Consume the newline after shebang
  if self.pos < self.chars.length() && self.peek() == '\n' {
    self.advance() |> ignore
    self.emit(Newline, self.line - 1, self.col)
  }
}

///|
fn Lexer::scan_line_start(self : Lexer) -> Unit {
  let mut spaces = 0
  while self.pos < self.chars.length() {
    let ch = self.peek()
    if ch == ' ' {
      spaces += 1
      self.advance() |> ignore
    } else if ch == '\t' {
      spaces += 2 // treat tab as 2 spaces
      self.advance() |> ignore
    } else {
      break
    }
  }
  if self.pos < self.chars.length() && self.peek() != '\n' {
    self.emit(Indent(spaces), self.line, 1)
  }
}

///|
fn Lexer::scan_line_comment(self : Lexer) -> Unit {
  let line = self.line
  let col = self.col
  self.advance() |> ignore // -
  self.advance() |> ignore // -
  let buf = StringBuilder::new()
  while self.pos < self.chars.length() && self.peek() != '\n' {
    buf.write_char(self.advance())
  }
  self.emit(Comment(buf.to_string()), line, col)
}

///|
fn Lexer::scan_block_comment(self : Lexer) -> Unit {
  let line = self.line
  let col = self.col
  // skip opening ---
  self.advance() |> ignore
  self.advance() |> ignore
  self.advance() |> ignore
  let buf = StringBuilder::new()
  while self.pos < self.chars.length() {
    if self.peek() == '-' && self.peek_at(1) == '-' && self.peek_at(2) == '-' {
      self.advance() |> ignore
      self.advance() |> ignore
      self.advance() |> ignore
      break
    }
    buf.write_char(self.advance())
  }
  self.emit(BlockComment(buf.to_string()), line, col)
}

///|
fn Lexer::scan_string(self : Lexer) -> Unit {
  let line = self.line
  let col = self.col
  // skip opening ///
  self.advance() |> ignore
  self.advance() |> ignore
  self.advance() |> ignore
  let segments : Array[String] = []
  let mut buf = StringBuilder::new()
  let mut has_interp = false
  while self.pos < self.chars.length() {
    if self.peek() == '/' && self.peek_at(1) == '/' && self.peek_at(2) == '/' {
      self.advance() |> ignore
      self.advance() |> ignore
      self.advance() |> ignore
      break
    }
    if self.peek() == '\\' {
      self.advance() |> ignore // skip backslash
      let esc = self.advance()
      match esc {
        'n' => buf.write_char('\n')
        't' => buf.write_char('\t')
        '\\' => buf.write_char('\\')
        '/' => buf.write_char('/')
        '[' => buf.write_char('[')
        ']' => buf.write_char(']')
        _ => {
          buf.write_char('\\')
          buf.write_char(esc)
        }
      }
      continue
    }
    if self.peek() == '[' {
      has_interp = true
      segments.push(buf.to_string())
      buf = StringBuilder::new()
      self.advance() |> ignore // skip [
      let expr_buf = StringBuilder::new()
      let mut depth = 1
      while self.pos < self.chars.length() && depth > 0 {
        let ch = self.peek()
        if ch == '[' {
          depth += 1
        }
        if ch == ']' {
          depth -= 1
          if depth == 0 {
            self.advance() |> ignore
            break
          }
        }
        expr_buf.write_char(self.advance())
      }
      segments.push(expr_buf.to_string())
      continue
    }
    buf.write_char(self.advance())
  }
  if has_interp {
    segments.push(buf.to_string())
    self.emit(InterpStr(segments), line, col)
  } else {
    self.emit(Str(buf.to_string()), line, col)
  }
}

///|
fn Lexer::scan_regex(self : Lexer) -> Unit {
  let line = self.line
  let col = self.col
  self.advance() |> ignore // skip opening /
  let pattern = StringBuilder::new()
  while self.pos < self.chars.length() && self.peek() != '/' {
    if self.peek() == '\\' {
      pattern.write_char(self.advance()) // backslash
      if self.pos < self.chars.length() {
        pattern.write_char(self.advance()) // escaped char
      }
      continue
    }
    pattern.write_char(self.advance())
  }
  if self.pos < self.chars.length() {
    self.advance() |> ignore // skip closing /
  }
  // Read flags
  let flags = StringBuilder::new()
  while self.pos < self.chars.length() {
    let ch = self.peek()
    if ch == 'g' || ch == 'i' || ch == 'm' || ch == 's' || ch == 'u' || ch == 'y' {
      flags.write_char(self.advance())
    } else {
      break
    }
  }
  self.emit(Regex(pattern.to_string(), flags.to_string()), line, col)
}

///|
fn Lexer::scan_number(self : Lexer) -> Unit {
  let line = self.line
  let col = self.col
  let buf = StringBuilder::new()
  if self.peek() == '-' {
    buf.write_char(self.advance())
  }
  while self.pos < self.chars.length() && is_digit(self.peek()) {
    buf.write_char(self.advance())
  }
  if self.pos < self.chars.length() && self.peek() == '.' && is_digit(self.peek_at(1)) {
    buf.write_char(self.advance()) // .
    while self.pos < self.chars.length() && is_digit(self.peek()) {
      buf.write_char(self.advance())
    }
    let s = buf.to_string()
    self.emit(Float(parse_double(s)), line, col)
  } else {
    let s = buf.to_string()
    self.emit(Int(parse_int(s)), line, col)
  }
}

///|
fn Lexer::is_neg_literal_context(self : Lexer) -> Bool {
  if self.tokens.is_empty() {
    return true
  }
  let last = self.tokens[self.tokens.length() - 1]
  match last.kind {
    LBracket | Comma | Semicolon | Be | Newline | Indent(_) | Return_ | To | Then_ | Coal => true
    _ => false
  }
}

///|
fn Lexer::scan_ident(self : Lexer) -> Unit {
  let line = self.line
  let col = self.col
  let buf = StringBuilder::new()
  buf.write_char(self.advance())
  while self.pos < self.chars.length() && is_ident_char(self.peek()) {
    buf.write_char(self.advance())
  }
  let word = buf.to_string()
  let kind : TokenKind = match word {
    "const" => Const_
    "let" => Let_
    "var" => Var_
    "be" => Be
    "add" => Add
    "sub" => Sub
    "mul" => Mul
    "div" => Div
    "mod" => Mod
    "neg" => Neg
    "pow" => Pow
    "eq" => Eq
    "neq" => Neq
    "lt" => Lt
    "gt" => Gt
    "le" => Le
    "ge" => Ge
    "and" => And
    "or" => Or
    "not" => Not
    "fn" => Fn
    "return" => Return_
    "to" => To
    "if" => If_
    "elif" => Elif
    "else" => Else_
    "unless" => Unless
    "then" => Then_
    "while" => While_
    "until" => Until
    "for" => For_
    "in" => In_
    "range" => Range_
    "break" => Break_
    "continue" => Continue_
    "match" => Match_
    "when" => When_
    "pipe" => Pipe_
    "is" => Is
    "as" => As
    "of" => Of
    "gives" => Gives
    "typeof" => Typeof_
    "instanceof" => Instanceof_
    "new" => New_
    "delete" => Delete_
    "this" => This_
    "async" => Async_
    "await" => Await_
    "try" => Try_
    "catch" => Catch_
    "finally" => Finally_
    "throw" => Throw_
    "import" => Import_
    "from" => From_
    "export" => Export_
    "default" => Default_
    "require" => Require_
    "use" => Use_
    "namespace" => Mod_
    "pub" => Pub_
    "all" => All_
    "type" => Type_
    "true" => True_
    "false" => False_
    "null" => Null_
    "nil" => Nil_
    "undefined" => Undefined_
    "coal" => Coal
    "list" => List_
    "object" => Object_
    _ => Ident(word)
  }
  self.emit(kind, line, col)
}
