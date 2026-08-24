---
name: checks
description: Generate and self-validate ast-grep checks for the mechanizable rules in a rule set
argument-hint: planning | frontend | backend | accessibility
disable-model-invocation: true
---

# Generate Machine Checks

Turn the structural subset of a Hypr rule set into deterministic ast-grep
checks, so compliance can be measured (`/hypr:conformance`) and enforced (CI +
the edit hook). Uses the **check-authoring** skill; see `docs/rules-format.md`
(Enforceability) for the contract.

## Target

The rule set is provided in `$ARGUMENTS`:

- `backend` / `frontend` / `planning` / `accessibility` — one rule set
- `all` — every rule set present in `.claude/rules/`

If `$ARGUMENTS` is empty, ask which to mechanize.

## Prerequisite: ast-grep

Check availability: `command -v ast-grep` (preferred) or `npx @ast-grep/cli --version`.
If neither works, stop and tell the user how to install it:

- Node: `npm i -g @ast-grep/cli` (or run via `npx @ast-grep/cli`)
- macOS: `brew install ast-grep` · Rust: `cargo install ast-grep --locked` · Python: `pip install ast-grep-cli`

Do not write `check: ast-grep` on any rule you could not validate.

## Process

### Step 1: Read the rule set

Read `.claude/rules/<type>.md` and list its `rule` blocks (id, statement, scope,
severity).

### Step 2: Select the mechanizable subset

Per the check-authoring skill, keep only rules expressible as a structural
pattern where **a match means a violation** (banned constructs, required
attributes/decorators, naming/import patterns). Skip architectural/semantic
rules — they stay `check:` empty.

### Step 3: Draft + self-validate each check

For each candidate, draft an ast-grep rule file (`severity` mapped error→error/
warn→warning/info→info, `message` = the statement, `rule:` so a match = a
violation). `language` is per-file, and ast-grep forbids duplicate ids — so to
cover several of the rule's `scope` languages, emit **one file per language**
with ids sharing the Hypr-id prefix: `.claude/rules/checks/<id>.yml` (e.g.
`language: tsx`) and `.claude/rules/checks/<id>-<lang>.yml` (e.g.
`A11Y-001-jsx`, `language: javascript`). Then run the **mandatory
self-validation loop** from the skill: each must parse, flag a violating
fixture in its language, and NOT flag clean/known-good code. Discard any that
fail. (ast-grep can't parse Vue/Svelte; only claim languages you ship a rule
for.)

### Step 4: Wire it up

- Write each validated rule to `.claude/rules/checks/<id>.yml`.
- Create/update `sgconfig.yml` at the repo root:

  ```yaml
  ruleDirs:
    - .claude/rules/checks
  ```

- Set `check: ast-grep` on the corresponding Hypr blocks in `.claude/rules/<type>.md`
  (only the ones that validated).

### Step 5: Offer the CI gate

Ask whether to add `.github/workflows/hypr-conformance.yml`. If yes, write:

```yaml
name: Hypr Conformance
on: [pull_request]
jobs:
  conformance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: "20" }
      - name: Run ast-grep checks
        run: npx --yes @ast-grep/cli scan -c sgconfig.yml
```

`ast-grep scan` exits non-zero when any `error`-severity rule matches, so the PR
fails on those; `warning`/`info` violations are reported but don't gate.

### Step 6: Report

Summarize: rules mechanized (with ids), rules skipped as not mechanizable, and
any drafts discarded for failing validation. Suggest `/hypr:conformance` to see
the pass rate.

## Notes

- Re-running is safe and idempotent: it refreshes existing checks and adds new
  ones; it never invents a check it can't validate.
- The accessibility rule set ships with pre-validated checks (e.g. `A11Y-001`,
  `A11Y-020`) installed by `/hypr:a11y`, so it may already be partly mechanized.
