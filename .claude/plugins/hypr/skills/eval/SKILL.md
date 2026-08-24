---
name: eval
description: Measure whether Hypr's output is on-pattern — conformance pass-rate, an "indistinguishable from existing code" judge, and optional rules precision/recall
argument-hint: [scope]
disable-model-invocation: true
---

# Hypr Eval

You are running the Hypr eval harness — the instrument that makes "faster at
parity" and "higher signal" measurable. Full contract: `docs/evals.md`. Three
graders, run cheapest-first; each is independently useful.

> Orchestrate at this (command) level: run `/hypr:conformance` for Grader 1 and
> spawn the `output-judge` agent for Grader 2 yourself.

## Target

`$ARGUMENTS` (optional):

- empty → run every case in `evals/cases/*.md`.
- a case file or domain → run just those.
- `quick` → Grader 1 only (deterministic; no LLM judge).

If `evals/cases/` doesn't exist, you can still run an **ad-hoc Grader 1**: just
run `/hypr:conformance` on the repo and report the pass-rate as the baseline
on-pattern score. Offer to scaffold a first `output` case (see `docs/evals.md`).

## Grader 1 — Conformance pass-rate (always; deterministic)

Run `/hypr:conformance <target>` and capture the mechanized-rule pass rate (by
domain + severity). This needs no labels and is the objective floor. Record the
mechanized-vs-total split so the number is read honestly. If ast-grep isn't
installed **or `sgconfig.yml` doesn't exist** (assessment doesn't generate
checks — that's the separate `/hypr:checks <domain>` step), note Grader 1 is
unavailable, point the user at the missing step, and continue with G2/G3.

## Grader 2 — Indistinguishable-from-existing-code (per `kind: output` case)

For each `output` case (`docs/evals.md` defines the frontmatter):

1. **Hold out** the `target` file (do not show its contents to the generator).
2. **Generate** the file from the case's `task` using the project rules + the
   normal implement flow (`/hypr:implement`-style per-file loop). Write the
   candidate to a scratch path, not over the real file.
3. **Grade deterministically (G1):** run `/hypr:conformance` on the generated
   file (skip if Grader 1 is unavailable).
4. **Grade by judge (G2):** spawn the **output-judge** agent with the generated
   file, the case's `siblings`, the held-out `target` as hidden reference, and the
   relevant `.claude/rules/<domain>.md`. Capture its 1–5 `score` and mismatches.
5. Each judge `mismatch`/`unruled_gap` is a candidate correction — see Feedback.

## Grader 3 — Rules precision/recall (per `kind: rules` case; optional)

For each `rules` case with a `golden:` set: compare the generated
`.claude/rules/<domain>.md` to the golden set. Report **recall** (golden
conventions covered by ≥1 generated rule) and **precision** (generated rules that
map to a real convention; the rest are hallucinated/generic). Skip if no golden
set exists.

## Output — the scorecard

Emit the scorecard table from `docs/evals.md` (per-case G1 / G2 / G3, plus the
last recorded assessment wall-clock if available), then **append one row to
`evals/runs.md`** (create it if missing) so quality + speed are tracked over time.
State the mechanized-vs-total split and how many siblings each G2 used.

## Feedback — turn misses into corrections

When a case scores poorly because a **real convention is unruled** (judge
`unruled_gaps`, or a G3 recall miss), append an `add` `correction` block to
`.claude/rules/<domain>.corrections.md` (format in `docs/evals.md`). When a rule
is wrong or miscalibrated, append an `adjust`/`tighten`/`soften`. `/hypr:refresh`
consumes these as priors instead of regenerating from scratch.

## After eval

- Re-run after any assessment/review prompt change to catch regressions.
- `/hypr:refresh <domain>` to fold accumulated corrections into the rules.
- Add more `output` cases over time — each held-out file is a free eval.
