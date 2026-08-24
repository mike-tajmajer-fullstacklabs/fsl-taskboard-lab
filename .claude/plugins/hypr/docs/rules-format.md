# Rule Format & Location Contract

This is the single source of truth for how Hypr rules are written and where they
live. Every generator (the `rule-extraction` skill, the assessor agents) emits
this format, and every consumer (`/hypr:validate`, `/hypr:status`, the
code-reviewer, the `pattern-validation` skill) reads it. When in doubt, this doc
wins.

## Why a structured block

A structured block gives every rule a stable identity plus the metadata that
scoping, freshness, and enforcement build on — a `severity`, a `scope` glob, an
`example` for provenance, and a `check` hook — while staying readable as plain
markdown.

## The rule block

Each rule is a fenced ` ```rule ` block. **All six fields are always present, in
this exact order**, one `key: value` per line. `check:` is empty for rules that
aren't mechanizable, or `ast-grep` for rules backed by a machine check (see the
`check` field below and the Enforceability section).

````
```rule
id: BE-001
severity: error
scope: src/**/*.controller.ts
statement: Controllers use kebab-case route names matching resource plurals (e.g. @Route('resources')).
example: src/controllers/resources/resource.controller.ts:167
check:
```
````

### Field contract

| Field | Required | Meaning |
|-------|----------|---------|
| `id` | yes | Stable identifier, **append-only, never renumbered**. Domain prefix + zero-padded 3 digits. |
| `severity` | yes | Exactly one of `error` (structural / must), `warn` (should), or `info` (preference) — written verbatim, never `warning` or a synonym. |
| `scope` | yes | A single glob the rule applies to. Use `**/*` when it genuinely applies everywhere. |
| `statement` | yes | The rule itself, written as an imperative. One sentence; include a short inline example where useful. |
| `example` | yes | Provenance: `path:line` where the pattern was observed. For shipped WCAG rules, the criterion (e.g. `WCAG 4.1.2`). |
| `check` | yes | `ast-grep` if one or more ast-grep checks exist in `.claude/rules/checks/` under this rule's id prefix (`<id>`, `<id>-<lang>`); otherwise empty (rule is advisory, not machine-checked). See Enforceability. |

**One convention per block.** Each `rule` states a single, independently-verifiable
convention. A block must not bundle several unrelated conventions (e.g. quoting +
`import type` + build command) — a compound rule can't carry one meaningful
`severity` or `check`. Split it into one block per convention.

### ID scheme

| Domain | Prefix | Example |
|--------|--------|---------|
| Backend | `BE-` | `BE-001` |
| Frontend | `FE-` | `FE-001` |
| Planning | `PL-` | `PL-001` |
| Accessibility | `A11Y-` | `A11Y-001` |

IDs are assigned sequentially within a domain at generation time and never
reused or renumbered, so a rule can be cited (`BE-005`) and tracked across
refreshes. Cite rules by `id`, never by ordinal position.

### Parallel generation: fragment files → `cat` + deterministic renumber

Assessment is parallel: an orchestrator (`/hypr:assess-{backend,frontend,planning}`)
fans out several assessor **workers**, each analyzing one cluster of aspects. A
worker has no global view of the numbering, so **every block it writes carries the
literal `id: PENDING`**.

To avoid generating the rule text twice (once on the workers, again when the
orchestrator re-emits the file — the dominant serial cost), **each worker writes
its own blocks to a per-cluster fragment file** under
`.claude/.hypr-parts/<domain>-<cluster>.md` (distinct files, so no write
contention) and returns only a one-line summary. The orchestrator then assembles
**without re-emitting any rule text**:

1. `cat` the fragments in cluster order into the file body.
2. **Renumber deterministically** with a script that replaces each `id: PENDING`
   with the next sequential ID (`BE-001`, `BE-002`, …) — no LLM tokens spent
   re-typing rules.
3. The judgment passes (de-dupe, coverage) run on the assembled file via the
   coverage-critic; if blocks are added/removed, renumber again (still pre-finalize,
   so no external citation is broken). Set the `hypr-meta` `next_id` high-water mark.

`PENDING` is a transport placeholder only — it never appears in a finalized rule
file. The `.hypr-parts/` directory is deleted after the file is written.

## The provenance header

Each rules section opens with one ` ```hypr-meta ` block recording when and
against what the rules were generated. The assessment **orchestrator** captures
these once, up front (before fanning out workers), by running `git rev-parse HEAD`,
`date +%Y-%m-%d`, and (best effort) reading `version` from the plugin's
`plugin.json`.

````
```hypr-meta
domain: backend
base_commit: a5b5bc106005eabdd1fb591e0c07ec31b169931a
generated_at: 2026-06-25
plugin_version: 1.0.0
next_id: 90
```
````

Fields:

- `base_commit` — the commit the rules were assessed against (drives freshness).
- `generated_at` — assessment date (`YYYY-MM-DD`).
- `plugin_version` — Hypr version, best effort (`unknown` if not resolvable).
- `next_id` — the per-domain ID high-water mark: the number the next new rule
  will take. New rules consume `next_id` and bump it; **as long as `next_id` is
  present, removed rules' IDs are never reused**, so a cited ID (`BE-005`) always
  means the same rule. If `next_id` is absent (legacy files), fall back to
  `max(existing id) + 1` — note this *can* re-mint the ID of a since-deleted
  top rule, so the never-reused guarantee only holds once a `next_id` exists.
  Any refresh writes `next_id`, which repairs the guarantee going forward.

## Location Contract

Generated project rules live in **per-domain, path-scoped files**:

```
.claude/rules/backend.md
.claude/rules/frontend.md
.claude/rules/planning.md
.claude/rules/accessibility.md
```

Each file carries YAML frontmatter with a `paths:` list that is a **superset of
every block's `scope`** (so no rule falls outside it), and Claude loads the file
**only when reading/editing a matching file** — editing a controller pulls in
`backend.md` and nothing else. If a block's `scope` isn't covered by `paths:`,
that rule silently never loads, so widen `paths:` to the broadest scope present.
`.claude/rules/*.md` is a Claude-native mechanism and is discovered recursively.

Two root files tie it together:

- **`AGENTS.md`** — a portable overview + per-domain index, readable by humans
  and other agentic tools. It is intentionally slim: the detailed rules live in
  `.claude/rules/`. (Other tools that read `AGENTS.md` raw get the overview and
  index, not every rule — a conscious Claude-first tradeoff.)
- **`CLAUDE.md`** — contains `@AGENTS.md` so Claude consumes the overview
  (Claude does not read `AGENTS.md` natively). The scoped rule files load on
  their own via `paths:`; custom subagents inherit them automatically.

> **Relocatable by design.** Generators and consumers refer to "the rule
> location defined in the Rule Location Contract (`docs/rules-format.md`)"
> rather than hard-coding paths, so the layout can change in one place — this
> doc plus the assessors — without editing every consumer.

Behavior (the Per-File Implementation Loop / Feature Planning Process) is **not**
generated into the project; it lives in the plugin's executor/planner agents.

## File layout

`.claude/rules/backend.md` (frontend/planning/accessibility are analogous):

````
---
paths:
  - "src/**/*.controller.ts"
  - "src/services/**/*.ts"
---

```hypr-meta
domain: backend
base_commit: <sha>
generated_at: <date>
plugin_version: <version>
next_id: <n>
```

```rule
id: BE-001
severity: error
scope: src/**/*.controller.ts
statement: ...
example: src/.../x.controller.ts:167
check:
```

```rule
id: BE-002
...
```
````

Root `AGENTS.md`:

````
# <Project> — Agent Guide

Project conventions for AI coding agents. Detailed, path-scoped rules live in
`.claude/rules/` (Claude loads each when editing matching files).

## Rule sets
- **Backend** — `.claude/rules/backend.md` (API, services, data access)
- **Frontend** — `.claude/rules/frontend.md` (components, styling, state)
- **Planning** — `.claude/rules/planning.md` (feature breakdown)
- **Accessibility** — `.claude/rules/accessibility.md` (WCAG 2.1 AA)

See `docs/rules-format.md` (in the Hypr plugin) for the rule block format.
````

Root `CLAUDE.md`:

```
@AGENTS.md
```

## Freshness

Provenance exists so staleness is *computed*, not guessed. `/hypr:status` and
`/hypr:refresh` both use this algorithm against a rule file
`.claude/rules/{domain}.md`:

1. Read `base_commit` from the file's `hypr-meta` header.
2. **Guard.** If `base_commit` is missing, or
   `git merge-base --is-ancestor <base_commit> HEAD` exits non-zero (shallow
   clone, rebased/squashed history), the incremental diff is unavailable —
   report that and recommend a full refresh; do not fabricate a diff.
3. `git diff --name-status <base_commit> HEAD` → added / modified / deleted /
   renamed files since the assessment.
4. Read the file's `paths:` globs and each block's `scope` + `example`.
5. Classify the changes:
   - **in-scope changes** — changed files matching the domain's `paths:`/`scope`
     globs (signals the domain may have drifted).
   - **likely-stale rules** — blocks whose `example:` source file was modified,
     renamed, or deleted (that specific rule may be wrong now).
6. Report signals: commits behind = `git rev-list --count <base_commit>..HEAD`;
   count of in-scope changes; list of likely-stale rule IDs.

Use file mtime for **nothing** — it is reset by any edit and says nothing about
codebase drift. When the mapping from a changed file to an aspect is ambiguous,
prefer treating the aspect as affected (re-assess) over skipping it.

## Enforceability

The **structural subset** of rules is backed by deterministic [ast-grep](https://ast-grep.github.io)
checks, so compliance is measured, not re-derived by an LLM each time.

- A rule with `check: ast-grep` is backed by one or more ast-grep rule files in
  `.claude/rules/checks/` whose `id` is the Hypr id **or the Hypr id plus a
  language suffix** (`A11Y-001`, `A11Y-001-jsx`). The **join is by the Hypr-id
  prefix**, because ast-grep forbids duplicate rule ids and `language` is
  per-rule — so covering both `.tsx` and `.jsx` takes two files. Rules that can't
  be expressed structurally keep `check:` empty — they remain advisory and are
  never counted as machine-checked.
- **Coverage may be a subset of the rule's `scope`.** A check only enforces the
  languages its rule files declare (e.g. the shipped a11y JSX checks cover
  `.tsx`/`.jsx` but not Vue/Svelte/HTML, which ast-grep can't parse the same
  way). Report what is actually scanned; don't imply the whole `scope` is
  enforced.
- The ast-grep rule is written so **a match means a violation**, with
  `severity` mapped from the Hypr block: `error` → `error` (gates CI by exiting
  non-zero), `warn` → `warning`, `info` → `info`.
- A project config `sgconfig.yml` at the repo root points ast-grep at the
  checks: `ruleDirs: [.claude/rules/checks]`.

```
sgconfig.yml
.claude/rules/checks/
  A11Y-001.yml       # enforces Hypr A11Y-001 for .tsx
  A11Y-001-jsx.yml   # ...and for .jsx (same prefix = same Hypr rule)
  BE-003.yml
  ...
```

Where checks are used:

- **`/hypr:checks <type>`** drafts and self-validates ast-grep rules for the
  mechanizable subset (a check that won't validate is dropped, not shipped).
- **PostToolUse hook** runs the applicable checks on an edited file (non-blocking
  reminder) when ast-grep is installed.
- **`/hypr:conformance`** runs all checks and reports a pass rate.
- **CI** runs `ast-grep scan -c sgconfig.yml`; `error`-severity violations fail
  the PR.

ast-grep is an external dependency (`npx @ast-grep/cli`, or brew/cargo/pip). Every
path degrades safely when it's absent — nothing in Hypr hard-fails without it.
