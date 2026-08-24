---
name: check-authoring
description: Draft and self-validate ast-grep rules that mechanically enforce structural Hypr rules. Used by /hypr:checks to turn the mechanizable subset of a rule set into machine checks.
user-invocable: false
---

# Check Authoring

Turn the **structural subset** of a project's Hypr rules into deterministic
[ast-grep](https://ast-grep.github.io) checks. The output is one ast-grep rule
file per mechanized Hypr rule at `.claude/rules/checks/<id>.yml`, with `id`
equal to the Hypr rule id. See `docs/rules-format.md` (Enforceability) for the
contract.

## What is mechanizable

Only enforce rules that map to a **syntactic/structural pattern**. Good
candidates (write them as "a match == a violation"):

- Banned constructs — `<div onClick>`, `console.log`, `any` type, `==` vs `===`.
- Required attributes/decorators — `<img>` without `alt`, controller class
  without `@Controller`.
- Naming patterns — file/identifier names that don't match a regex.
- Import rules — forbidden import sources.

Leave `check:` **empty** for architectural/semantic rules ("use DDD", "wrap
multi-write ops in a transaction", "keep handlers thin"). Don't force these —
a wrong check is worse than none.

## Rule shape

```yaml
id: <Hypr id, or Hypr id + language suffix, e.g. A11Y-001 / A11Y-001-jsx>
language: <tsx|typescript|javascript|python|...>   # ONE language per rule file
severity: <error|warning|info>        # map Hypr error->error, warn->warning, info->info
message: "<the rule statement, one line>"
rule:
  # a match here MUST mean a violation
  ...
```

**One language per file.** `language` fixes the parser, and ast-grep **rejects
duplicate ids** — so a rule that should cover several languages needs one file
per language with distinct ids sharing the Hypr-id prefix (`A11Y-001` for
`.tsx`, `A11Y-001-jsx` (`language: javascript`) for `.jsx/.js`). The Hypr block
gets `check: ast-grep` once; reports join by the `<HyprId>` prefix. Note: a
`files:` glob can NOT make a `tsx` rule scan `.jsx` (the parser is the
language). ast-grep can't parse Vue/Svelte; HTML is a separate grammar — only
claim coverage for languages you actually ship a rule for.

Key AST facts (TS/TSX, ast-grep/tree-sitter):

- JSX element tag name is the `name` field (`has: { field: name, regex: '^img$' }`).
- A JSX attribute is `kind: jsx_attribute`; its name is a `property_identifier`
  child (`has: { kind: property_identifier, regex: '^onClick$' }`).
- "Element X without attribute Y" = `kind: ...; has: {tag}; not: { has: {attribute} }`.
- Inspect unfamiliar nodes with `ast-grep run --lang tsx -p '<snippet>' --debug-query=ast <file>`.

### Worked examples (validated)

`<div>`/`<span>` with `onClick` (match = violation):

```yaml
id: A11Y-001
language: tsx
severity: error
message: "Use <button>, not <div>/<span> with onClick"
rule:
  kind: jsx_opening_element
  all:
    - has: { field: name, regex: '^(div|span)$' }
    - has: { kind: jsx_attribute, has: { kind: property_identifier, regex: '^onClick$' } }
```

`<img>` without `alt` (match = violation):

```yaml
id: A11Y-020
language: tsx
severity: error
message: "All <img> must have an alt attribute"
rule:
  any: [ { kind: jsx_self_closing_element }, { kind: jsx_opening_element } ]
  has: { field: name, regex: '^img$' }
  not:
    has: { kind: jsx_attribute, has: { kind: property_identifier, regex: '^alt$' } }
```

## Self-validation loop (MANDATORY)

Never ship an unvalidated check. For each draft, with ast-grep available
(`command -v ast-grep`, else `npx @ast-grep/cli`):

1. **Parses & runs** — `ast-grep scan -c sgconfig.yml --filter '<id>' --json`
   exits without a config/parse error.
2. **Catches the violation** — it flags a small fixture that intentionally
   violates the rule (e.g. the bad form from the rule's `statement`).
3. **No false positives on known-good code** — it does NOT flag the rule's own
   `example:` source (which is conformant) or a clean fixture of the good form.
   If a check floods existing, known-good code with matches, the matcher is
   probably inverted or too broad — **discard it**.

Only if all three pass: write `.claude/rules/checks/<id>.yml` and set
`check: ast-grep` on the Hypr block. Otherwise leave `check:` empty and report
the rule as "not mechanized (validation failed)".

## Output

- `.claude/rules/checks/<id>.yml` (and per-language variants `<id>-<lang>.yml`)
  per validated rule.
- `sgconfig.yml` at the repo root with `ruleDirs: [.claude/rules/checks]`
  (create if missing).
- `check: ast-grep` set only on the Hypr blocks whose check validated, plus a
  note of which languages the check actually covers when it's narrower than the
  rule's `scope`.
