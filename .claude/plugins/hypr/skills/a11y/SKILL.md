---
name: a11y
description: Add WCAG accessibility rules to your existing agents
disable-model-invocation: true
---

# Enable Accessibility

Adds WCAG 2.1 AA accessibility rules to your project as a scoped rule set, so AI
agents generate accessible UI code. See the Location Contract in
`docs/rules-format.md`.

## What This Does

1. Installs the WCAG rules as `.claude/rules/accessibility.md` (a path-scoped rule file)
2. Installs the pre-validated ast-grep checks that back some of those rules
3. Indexes it in the root `AGENTS.md`
4. Ensures `CLAUDE.md` imports `AGENTS.md`

## Process

### Step 1: Install the Accessibility Rule Set

Copy the plugin's accessibility rules into the project's scoped-rules directory:

```
Source: [hypr-plugin]/rules/accessibility.md   (already in rule-block format)
Target: .claude/rules/accessibility.md
```

The file already carries `paths:` frontmatter (UI file globs) and `A11Y-###`
rule blocks, so Claude loads it only when editing matching files. If the target
already exists, ask the user before overwriting.

### Step 1b: Install the shipped machine checks

A few a11y rules ship with pre-validated ast-grep checks (e.g. `A11Y-001`,
`A11Y-020` — the blocks marked `check: ast-grep`). Copy them so those rules are
actually enforced:

```
Source: [hypr-plugin]/rules/checks/*.yml
Target: .claude/rules/checks/
```

Ensure `sgconfig.yml` exists at the repo root with
`ruleDirs:\n  - .claude/rules/checks` (create or merge the entry). These checks
then run in the edit hook (if ast-grep is installed), via `/hypr:conformance`,
and in CI. To mechanize more a11y rules later, run `/hypr:checks accessibility`.

### Step 2: Index it in AGENTS.md

Ensure the root `AGENTS.md` exists (create with an overview + "## Rule sets"
index if missing) and add/update the entry:
``- **Accessibility** — `.claude/rules/accessibility.md` (WCAG 2.1 AA)``.

### Step 3: Ensure Claude consumes it

Ensure a root `CLAUDE.md` exists containing the line `@AGENTS.md` (append it if a
`CLAUDE.md` already exists without it). The scoped rule file loads on its own via
`paths:`.

### Step 4: Report

Tell the user the rule set was installed and indexed, and remind them to run
`/hypr:a11y-audit` to check existing code.

## Example Output

```
Accessibility enabled!

Created:
  .claude/rules/accessibility.md   (42 WCAG 2.1 AA rule blocks, path-scoped)
Indexed in:
  AGENTS.md  -> ## Rule sets -> Accessibility

Next steps:
  - Run /hypr:a11y-audit src/ to check existing code
  - New UI code will follow WCAG 2.1 AA standards
```

## The three "accessibility" artifacts (don't confuse them)

Hypr has three distinct accessibility pieces:

| Artifact | What it is | Role |
|----------|-----------|------|
| `rules/accessibility.md` (in this plugin) | The canonical WCAG 2.1 AA ruleset, shipped with Hypr | Source copied by this command |
| `.claude/rules/accessibility.md` (in your project) | The path-scoped copy this command installs | Makes *generated* code accessible |
| `accessibility-analyzer` agent | The bundled audit agent run by `/hypr:a11y-audit` | Audits *existing* code for a conformance rating |

`/hypr:a11y` (this command) handles the first two; `/hypr:a11y-audit` uses the third.

## Notes

- The rules load only for UI files (per the file's `paths:` frontmatter), so
  they add no context cost when editing non-UI code.
- Rules are WCAG 2.1 AA standards - not project-specific.
- To update rules later, run this command again with `--force`.
