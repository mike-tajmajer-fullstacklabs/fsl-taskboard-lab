# Eval & Feedback Contract

This is the single source of truth for how Hypr **measures whether its output is
on-pattern** and how **real corrections flow back into the rules** over time.
`/hypr:eval` produces the measurements; the corrections channel (below) closes the
loop so `/hypr:refresh` improves rules instead of regenerating them from scratch.

Like `docs/rules-format.md`, everything here is LLM-emittable markdown — there is
no runtime. Deterministic measurement is delegated to `/hypr:conformance`
(ast-grep); judgment measurement is delegated to the `output-judge` agent.

## Why measure

Phase 1 (parallel assessment) and Phase 2 (review panel) claim "faster at parity"
and "higher signal." Those claims are only credible if quality is *measured*.
`/hypr:eval` is the instrument: it scores how indistinguishable Hypr-driven output
is from the project's real code, and how well an assessment captured the real
conventions.

## The three graders

Run cheapest-first; each is independently useful.

### Grader 1 — Conformance pass-rate (deterministic, free)

Reuse `/hypr:conformance`. Run it over a target (a Hypr-generated chunk, or the
whole repo) and report the **mechanized-rule pass rate**. This is the objective
floor: it needs no human labels and no LLM judge. It only covers rules with
`check: ast-grep` — state the mechanized-vs-total split (as `/hypr:conformance`
already does) so the number isn't mistaken for whole-rule-set conformance.

### Grader 2 — "Indistinguishable from existing code" (LLM judge)

The assessor agents' own success test — *"produce code indistinguishable from
existing project code"* — turned into a scored rubric. The `output-judge` agent
scores a generated file 1–5 against 2–3 real sibling files of the same kind. Used
for **held-out reconstruction** cases (below). Covers the judgment patterns that
ast-grep can't.

### Grader 3 — Rules precision/recall (optional, needs a golden set)

Measures **assessment** quality, not output quality. Against a human-curated
golden rule set (`evals/golden/<domain>.md`):

- **recall** = golden conventions covered by ≥1 generated rule ÷ total golden.
- **precision** = generated rules that map to a real convention ÷ total generated
  (the complement surfaces hallucinated/generic rules).
Skip if no golden set exists; G1+G2 stand alone.

## Eval case types

Eval cases live in `evals/cases/*.md` in the project under test (or the demo
fixture repo). Two kinds, set by `kind:` frontmatter:

### `kind: output` — held-out reconstruction

The core output-quality eval. Pick a real file that exemplifies project patterns,
**hold it out** as the gold standard, give Hypr the same task, and grade what it
generates.

```
---
kind: output
domain: backend
target: server/src/controllers/invitation.controller.ts   # the gold file, held out
siblings:                                                  # real files the judge compares against
  - server/src/controllers/project.controller.ts
  - server/src/controllers/brainstorm.controller.ts
task: >
  Implement the invitation controller: list/create/resend/revoke invitations for a
  project, following project patterns. (Paraphrase its real responsibilities — do
  NOT leak the gold file's contents.)
---
```

Run: generate the file from `task` using the rules → score with **G1**
(conformance on the generated file) + **G2** (`output-judge` vs `siblings`, with
the real `target` as the hidden reference).

### `kind: rules` — assessment quality

Grades a generated `.claude/rules/<domain>.md` against a golden set with **G3**.

```
---
kind: rules
domain: backend
golden: evals/golden/backend.md
---
```

## `/hypr:eval` output — the scorecard

```markdown
## Hypr Eval Scorecard
**Repo:** <name>@<short-sha>   **Date:** <YYYY-MM-DD>   **Cases:** N

| Case | Kind | G1 conformance | G2 indistinguishable (1–5) | G3 P / R |
|------|------|----------------|----------------------------|----------|
| invitation.controller | output | 18/20 (90%) | 4.3 | — |
| backend ruleset | rules | — | — | 0.86 / 0.79 |

**Assessment speed (from the last assess run, if recorded):** <wall-clock>
**Notes:** mechanized rules cover 22/69 backend rules; G2 judged vs 2 siblings.
```

Append each run to `evals/runs.md` (one row per run) so quality and speed are
tracked **over time**, not just once — this is how a regression after a prompt
change becomes visible.

## Feedback channel — corrections flow back

Today `/hypr:refresh` re-assesses affected aspects from scratch. The corrections
channel lets **real, observed corrections** adjust the rules instead, and turns
every correction into a future eval case.

### The corrections log

Per domain: `.claude/rules/<domain>.corrections.md`. Append-only list of
`correction` blocks:

````
```correction
date: 2026-06-29
source: review            # review | user-override | eval
target: BE-006            # an existing rule id, or "new"
kind: tighten             # add | adjust | tighten | soften | exception
note: brainstorm.controller passed the actor positionally; BE-006 (actor object) is real and was confirmed — keep error severity.
evidence: server/src/controllers/brainstorm.controller.ts:57
```
````

`kind`:

- **add** — a confirmed finding exposed a convention no rule covered → a new rule
  should exist.
- **adjust / tighten / soften** — an existing rule was wrong, too narrow, or too
  aggressive (e.g. a `warn` that should be `info`, or an `error` that over-blocks).
- **exception** — a user **overrode** a finding ("fine here") → record the
  legitimate exception so the rule (or its `scope`) stops flagging it.

### Who writes corrections

- **`/hypr:review`** — when the panel produces a **confirmed** finding that
  reveals a missing/wrong rule, OR the user overrides a finding, append a
  `correction` block (and the same item becomes a candidate `output` eval case).
- **`/hypr:eval`** — a held-out case that scores poorly because a real convention
  is unruled → append an `add` correction.

### Who consumes corrections

- **`/hypr:refresh`** — before (re-)assessing, read `<domain>.corrections.md` and
  apply each entry as a **prior**: `add` → draft the missing rule (consuming
  `next_id`), `adjust/tighten/soften` → edit the named rule in place (keeping its
  `id`), `exception` → narrow the rule's `scope` or note the exception. Then
  archive applied entries (move them under a `## Applied` heading with the refresh
  date) so they aren't re-applied. This is strictly additive to the Freshness
  algorithm in `docs/rules-format.md` — corrections are applied first, then the
  diff-driven re-assessment runs on top.

Corrections are **priors, not gospel**: if a correction contradicts what the
current code actually shows during refresh, prefer the code and note the conflict.
