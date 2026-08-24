---
name: review
description: Review implemented code with a multi-lens panel — independent reviewers, adversarially verified, confidence-scored findings
argument-hint: <target>
---

# Code Review (panel orchestrator)

> **Model-invocable by design** — `/hypr:build-chunk` runs this skill mid-flow;
> `disable-model-invocation` would break that orchestration.

You are the **orchestrator** for a Hypr code review. Instead of one reviewer doing
a single pass, you run a **panel of independent lenses in parallel**, then
**adversarially verify** each finding before it can gate the chunk. This raises
signal (more caught) while cutting false positives (each finding must survive a
refutation attempt).

> **Orchestrate at this (command) level** — subagents can't spawn subagents, so
> you launch the lens workers and the verifiers yourself with the Agent tool, each
> batch **in a single message** so they run concurrently.

## Prerequisites Check

1. `.claude/rules/frontend.md` and/or `.claude/rules/backend.md` exist (else tell
   the user to run the relevant assessment first).

## Review Target

`$ARGUMENTS`: a feature file path, a `feature-NNN chunk N` reference, or explicit
files. If empty, ask what to review. Resolve the target to a concrete **file list**
and (if a chunk) its **acceptance criteria** from the feature document.

## Step 1 — Mechanical rules first (`/hypr:conformance`)

Run `/hypr:conformance <target>`. When it runs, it deterministically covers the
machine-checkable rules, so the panel can focus on **judgment** rules and real
defects. Carry its violations into the final report; **tell the panel not to
re-flag** machine-checkable rules. If it can't run (no ast-grep, or no
`sgconfig.yml` yet), note that in the report and **tell the `conformance` lens to
review all rules, machine-checkable included** — otherwise `check:`-bearing rules
are reviewed by nobody.

## Step 2 — Fan out the lens panel (PARALLEL)

In **one message**, launch the **code-reviewer** agent once per lens, concurrently:

- **`conformance`** — judgment rules (empty `check:`) in the relevant
  `.claude/rules/*.md`.
- **`criteria`** — the chunk's acceptance criteria.
- **`correctness`** — logic bugs, null/undefined, error paths, security/perf.
- **`tests`** — test existence, pattern-match, and real coverage.

Each worker prompt includes its lens, the file list, and the inputs that lens needs
(rules for `conformance`, acceptance criteria for `criteria`). Always launch all
four, even for a tiny chunk — workers are single-lens by contract and ignore
issues belonging to other lenses, so a merged worker silently drops a lens.
Collect each worker's `finding` blocks (or `no-findings`).

## Step 3 — Dedupe, then verify (PARALLEL)

1. **Dedupe** findings across lenses by `file:line` + substance (two lenses may
   surface the same issue) — keep the richest, note both lenses.
2. In **one message**, launch a **review-verifier** for each surviving finding,
   passing the finding, the cited file(s), and (for `conformance`) the rule's full
   text. Each returns `confirmed | refuted | uncertain` + `adjusted_confidence`.
3. **Drop `refuted`** findings (optionally list them under "Refuted" for
   transparency). Keep `confirmed`; keep `uncertain` as advisory only.

## Step 4 — Gate the outcome (confidence × severity)

Use the **rule's own `severity`** (`docs/rules-format.md`) crossed with the
verified confidence:

- **BLOCKED** — any `confirmed` finding with `severity: error` at `high`/`med`
  confidence (broken behavior, unmet critical criterion, or hard rule violation).
- **CHANGES REQUESTED** — `confirmed` `warn` findings, or `confirmed` `error`
  findings at `low` confidence; no blocking finding.
- **APPROVED** — nothing confirmed above `info`; remaining items are `info` /
  `uncertain` advisories only.

`info` and `uncertain` findings are **advisory** — reported, never gating.

## Step 5 — Report

```markdown
## Code Review Report
**Target:** [...]   **Files:** [n]   **Outcome:** APPROVED / CHANGES REQUESTED / BLOCKED

### Conformance (ast-grep)
[pass rate + any error-severity violations, or "not run — ast-grep unavailable"]

### Confirmed findings
| # | Lens | Rule | Sev | Conf | File:Line | Issue | Fix |
|---|------|------|-----|------|-----------|-------|-----|
| 1 | conformance | BE-012 | error | high | x.ts:42 | ... | ... |

### Advisory (info / uncertain — not gating)
| Lens | File:Line | Issue | Why advisory |

### Refuted (verifier knocked these down)
| Lens | File:Line | Claim | Why refuted |

### Recommended actions
1. ...
```

Always show the confirmed / advisory / refuted split — it's the signal that this
panel beats a single pass.

## Step 6 — Update the feature document

Same as before, driven by the gated outcome:

- **APPROVED** — chunk **Status** → "Reviewed", **Review Status** → "Approved";
  Progress Log: `| [date] | [chunk] | Reviewed | Approved | [notes] |`. If all
  chunks reviewed, feature **Status** → "Completed".
- **CHANGES REQUESTED** — **Status** stays "Implemented", **Review Status** →
  "Changes Requested"; log a one-line summary.
- **BLOCKED** — **Status** → "Blocked", **Review Status** → "Changes Requested";
  log the reason and escalate to the user.

## Step 7 — Feed corrections back (close the loop)

The review just learned something about the rules — capture it so `/hypr:refresh`
can act on it instead of regenerating from scratch. Append a `correction` block to
`.claude/rules/<domain>.corrections.md` (format in `docs/evals.md`) when:

- a **confirmed** finding exposes a convention **no rule covers** → `add`;
- a confirmed finding shows an existing rule is wrong/too narrow → `adjust`/`tighten`;
- the user **overrides** a finding ("fine here") → `exception` (and don't re-gate on it);
- a rule's `error` severity over-blocked a mere consistency issue → `soften`.

Only log corrections backed by a verifier-confirmed finding or an explicit user
override — never from refuted or low-confidence advisory items. Each logged
correction is also a candidate `/hypr:eval` case.

## Critical Rules

- **DO NOT modify code** — review and report only.
- **Verify before you gate** — a finding only blocks if a verifier confirmed it.
- **Be specific** — every confirmed finding has `file:line`, evidence, and a fix;
  cite the rule `id` for conformance findings.
- **Don't double-count** — machine-checkable rules come from Step 1, not the panel.
