---
name: conformance
description: Run the project's ast-grep checks and report a measurable rule-conformance pass rate
argument-hint: [scope]
---

# Rule Conformance

> **Model-invocable by design** — `/hypr:review`, `/hypr:eval`, and
> `/hypr:build-chunk` run this skill mid-flow; `disable-model-invocation` would
> break that orchestration.

Run the machine-checkable Hypr rules (those with `check: ast-grep`) across the
codebase and report a deterministic **conformance pass rate**. This is the
measured counterpart to `/hypr:validate` (which reasons about rules) — see
`docs/rules-format.md` (Enforceability).

## Target

`$ARGUMENTS` (optional):

- A path (file or directory) to scan — defaults to the whole repo.
- `quick` — summary only (pass rate, no per-violation detail).

## Prerequisite: ast-grep

Check `command -v ast-grep` (preferred) or `npx @ast-grep/cli --version`. If
neither is available, stop and print install guidance (`npm i -g @ast-grep/cli`
/ `npx @ast-grep/cli` / `brew install ast-grep` / `cargo install ast-grep --locked`
/ `pip install ast-grep-cli`). If `sgconfig.yml` is missing, tell the user to run
`/hypr:checks <type>` first.

## Process

1. Run `ast-grep scan -c sgconfig.yml [target] --json` (use `jq` to parse). Each
   finding carries `ruleId`, `file`, line, and `severity`. Map each `ruleId`
   back to its Hypr rule by stripping any language suffix (`A11Y-001-jsx` →
   `A11Y-001`), since one Hypr rule may have per-language check files.
2. Determine the denominator: count rules with `check: ast-grep` across
   `.claude/rules/*.md` (these are the **mechanized** rules). A mechanized rule
   **passes** if it has zero violations (across all its check files) in the
   scan, **fails** otherwise.
3. Group by domain (Hypr-id prefix `BE-`/`FE-`/`PL-`/`A11Y-`) and by severity.
   Note which languages each mechanized rule's checks actually cover when it's
   narrower than the rule's `scope` (e.g. "A11Y-001: .tsx/.jsx only").

## Output

```markdown
## Rule Conformance Report

**Scope:** [target]   **Engine:** ast-grep

### Pass rate (mechanized rules only)
| Domain | Mechanized | Passing | Pass rate | Errors | Warnings |
|--------|-----------|---------|-----------|--------|----------|
| Backend | 22 | 18 | 82% | 3 | 1 |
| Accessibility | 2 | 1 | 50% | 1 | 0 |

### Violations
| Rule | Severity | File:Line | Message |
|------|----------|-----------|---------|
| A11Y-001 | error | src/Menu.tsx:42 | Use <button>, not <div>/<span> with onClick |

### Notes
- Only rules with `check: ast-grep` are measured here. Rules without a machine
  check are **advisory** (validated by `/hypr:validate`, not counted above).
- `error`-severity violations are what CI gates on; `warning`/`info` are advisory.
```

Always state the mechanized-vs-total split so the pass rate is not mistaken for
whole-rule-set conformance: e.g. "22 of 47 backend rules are machine-checked."

## Related

- `/hypr:checks <type>` — generate/refresh the checks this command runs.
- `/hypr:validate <type>` — reason about all rules (incl. non-mechanized).
- CI: `.github/workflows/hypr-conformance.yml` runs the same scan to gate PRs.
