"use strict";

const KEYWORDS = new Set([
  "const", "let", "var", "be",
  "fn", "async", "return", "to", "gives",
  "if", "elif", "else", "unless", "then",
  "while", "until", "for", "in", "range",
  "match", "when",
  "try", "catch", "finally", "throw",
  "import", "from", "export", "default", "require", "use", "namespace", "pub", "all",
  "add", "sub", "mul", "div", "mod", "neg", "pow",
  "eq", "neq", "lt", "gt", "le", "ge",
  "and", "or", "not", "pipe", "coal",
  "is", "as", "of", "typeof", "instanceof", "type",
  "new", "delete", "this", "await",
  "true", "false", "null", "nil", "undefined",
  "break", "continue",
  "list", "object",
]);

function tokenize(source) {
  const tokens = [];
  let i = 0;
  let line = 1;
  let col = 1;
  const len = source.length;

  while (i < len) {
    const startLine = line;
    const startCol = col;

    // Newline
    if (source[i] === "\n") {
      tokens.push({ type: "newline", value: "\n", line: startLine, col: startCol });
      i++; line++; col = 1;
      continue;
    }
    if (source[i] === "\r") { i++; continue; }

    // Whitespace
    if (source[i] === " " || source[i] === "\t") {
      let start = i;
      while (i < len && (source[i] === " " || source[i] === "\t")) { i++; col++; }
      tokens.push({ type: "whitespace", value: source.slice(start, i), line: startLine, col: startCol });
      continue;
    }

    // Block comment ---
    if (source[i] === "-" && source[i + 1] === "-" && source[i + 2] === "-") {
      let end = source.indexOf("---", i + 3);
      if (end === -1) end = len; else end += 3;
      const val = source.slice(i, end);
      for (const ch of val) { if (ch === "\n") { line++; col = 1; } else { col++; } }
      tokens.push({ type: "block-comment", value: val, line: startLine, col: startCol });
      i = end;
      continue;
    }

    // Line comment --
    if (source[i] === "-" && source[i + 1] === "-") {
      let end = source.indexOf("\n", i);
      if (end === -1) end = len;
      tokens.push({ type: "comment", value: source.slice(i, end), line: startLine, col: startCol });
      col += end - i; i = end;
      continue;
    }

    // String ///
    if (source[i] === "/" && source[i + 1] === "/" && source[i + 2] === "/") {
      let j = i + 3; col += 3;
      while (j < len) {
        if (source[j] === "\\" && j + 1 < len) { j += 2; col += 2; continue; }
        if (source[j] === "/" && source[j + 1] === "/" && source[j + 2] === "/") { j += 3; col += 3; break; }
        if (source[j] === "\n") { line++; col = 1; } else { col++; }
        j++;
      }
      tokens.push({ type: "string", value: source.slice(i, j), line: startLine, col: startCol });
      i = j;
      continue;
    }

    // Punctuation
    if ("[],;.".includes(source[i])) {
      tokens.push({ type: "punct", value: source[i], line: startLine, col: startCol });
      i++; col++;
      continue;
    }

    // Word
    if (/[a-zA-Z_]/.test(source[i])) {
      let start = i;
      while (i < len && /[a-zA-Z0-9_-]/.test(source[i])) { i++; col++; }
      const word = source.slice(start, i);
      tokens.push({ type: KEYWORDS.has(word) ? "keyword" : "ident", value: word, line: startLine, col: startCol });
      continue;
    }

    // Number
    if (/[0-9]/.test(source[i])) {
      let start = i;
      while (i < len && /[0-9]/.test(source[i])) { i++; col++; }
      if (i < len && source[i] === "." && i + 1 < len && /[0-9]/.test(source[i + 1])) {
        i++; col++;
        while (i < len && /[0-9]/.test(source[i])) { i++; col++; }
      }
      tokens.push({ type: "number", value: source.slice(start, i), line: startLine, col: startCol });
      continue;
    }

    // Shebang
    if (i === 0 && source[i] === "#" && source[i + 1] === "!") {
      let end = source.indexOf("\n", i);
      if (end === -1) end = len;
      tokens.push({ type: "shebang", value: source.slice(i, end), line: startLine, col: startCol });
      col += end - i; i = end;
      continue;
    }

    // Other
    tokens.push({ type: "other", value: source[i], line: startLine, col: startCol });
    i++; col++;
  }
  return tokens;
}

// --- Rules ---

const defaultRules = {
  "no-var": { severity: "warn", message: "Avoid 'var'; use 'const' or 'let' instead" },
  "no-nil": { severity: "warn", message: "Use 'null' instead of 'nil'" },
  "indent-size": { severity: "warn", size: 2 },
  "no-trailing-whitespace": { severity: "warn", message: "Trailing whitespace" },
  "no-unused-import": { severity: "warn" },
  "consistent-naming": { severity: "warn", style: "kebab-case" },
  "max-line-length": { severity: "off", max: 100 },
};

function lint(source, ruleOverrides = {}) {
  const rules = { ...defaultRules, ...ruleOverrides };
  const diagnostics = [];
  const tokens = tokenize(source);
  const lines = source.split("\n");

  function report(rule, line, col, message) {
    const sev = rules[rule]?.severity || "warn";
    if (sev === "off") return;
    diagnostics.push({ rule, severity: sev, line, col, message });
  }

  // --- Token-level rules ---
  for (let i = 0; i < tokens.length; i++) {
    const tok = tokens[i];

    // no-var
    if (rules["no-var"]?.severity !== "off" && tok.type === "keyword" && tok.value === "var") {
      report("no-var", tok.line, tok.col, rules["no-var"].message);
    }

    // no-nil
    if (rules["no-nil"]?.severity !== "off" && tok.type === "keyword" && tok.value === "nil") {
      report("no-nil", tok.line, tok.col, rules["no-nil"].message);
    }

    // consistent-naming
    if (rules["consistent-naming"]?.severity !== "off" && tok.type === "ident") {
      const style = rules["consistent-naming"].style || "kebab-case";
      if (style === "kebab-case") {
        // Identifiers should be kebab-case (lowercase with hyphens)
        // Allow PascalCase for class names (starts with uppercase)
        // Allow underscores (they are equivalent to hyphens)
        if (/[A-Z]/.test(tok.value[0])) continue; // Allow PascalCase
      }
    }
  }

  // --- Line-level rules ---
  for (let li = 0; li < lines.length; li++) {
    const line = lines[li];
    const lineNum = li + 1;

    // no-trailing-whitespace
    if (rules["no-trailing-whitespace"]?.severity !== "off") {
      if (line.length > 0 && /\s+$/.test(line) && line.trim().length > 0) {
        report("no-trailing-whitespace", lineNum, line.length,
          rules["no-trailing-whitespace"].message || "Trailing whitespace");
      }
    }

    // indent-size
    if (rules["indent-size"]?.severity !== "off") {
      const match = line.match(/^( +)/);
      if (match) {
        const size = rules["indent-size"].size || 2;
        if (match[1].length % size !== 0) {
          report("indent-size", lineNum, 1,
            `Indentation should be a multiple of ${size} spaces (found ${match[1].length})`);
        }
      }
      // Warn on tabs if indent style is spaces
      if (/^\t/.test(line)) {
        report("indent-size", lineNum, 1, "Use spaces for indentation, not tabs");
      }
    }

    // max-line-length
    if (rules["max-line-length"]?.severity !== "off") {
      const max = rules["max-line-length"].max || 100;
      if (line.length > max) {
        report("max-line-length", lineNum, max + 1,
          `Line exceeds max length of ${max} (found ${line.length})`);
      }
    }
  }

  // Sort by line, then column
  diagnostics.sort((a, b) => a.line - b.line || a.col - b.col);
  return diagnostics;
}

module.exports = { lint, tokenize, defaultRules };
