---
name: assess-planning
description: Run the planning assessment — orchestrates a scout + parallel assessor workers to analyze how your project structures features and generate a planning rule set
disable-model-invocation: true
---

# Planning Assessment (parallel orchestrator)

You are the **orchestrator** for the Hypr planning assessment. You do NOT analyze
aspects yourself — you set up the rule file, fan out parallel `planning-assessor`
workers over aspect clusters, then assemble and quality-check their output. This
replaces the old single-agent, one-aspect-at-a-time walk (which took ~45–60 min);
the parallel design targets a fraction of that wall-clock at parity quality.

> **You must orchestrate at this (command) level.** Subagents cannot spawn
> subagents, so launch the scout, the workers, and the critic yourself with the
> Agent tool. Launch all workers **in a single message** (multiple Agent calls in
> one turn) so they run concurrently — that parallelism is the entire speedup.

## Prerequisites Check

1. Check if `.claude/rules/` exists (create if not).
2. If `.claude/rules/planning.md` already exists, warn the user it will be
   overwritten and confirm. (For an incremental update, use `/hypr:refresh planning`.)

`$ARGUMENTS`: `quick` → fewer rules per aspect (2–3) and ~5 samples per cluster;
empty → full assessment.

## Step A — Provenance + skeleton (run ONCE, before any worker)

1. `START_TS=$(date +%s)`.
2. Provenance: `git rev-parse HEAD`, `date +%Y-%m-%d`, plugin version (best
   effort from `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`, else `unknown`).
3. Create `.claude/rules/planning.md` with `paths:` frontmatter + `hypr-meta`
   header (Location Contract in `docs/rules-format.md`), `next_id: 1` for now:

````
---
paths:
  - "features/**"
---

```hypr-meta
domain: planning
base_commit: <sha>
generated_at: <date>
plugin_version: <version, or unknown>
next_id: 1
```
````

   **Keep `paths:` at `features/**`** regardless of the blocks' `scope:` values —
   planning rules are workflow-time (the feature-planner reads this file during
   `/hypr:plan`, and `paths: features/**` loads them while editing feature docs).
   A block's `scope` (often `**/*`) documents intent; the file-level `paths:` is
   what controls auto-load. (This differs from backend/frontend, where `paths:` is
   the union of block scopes — do NOT widen `paths:` here in Step D.)
4. Ensure root `AGENTS.md` exists; add/update the Planning entry:
   ``- **Planning** — `.claude/rules/planning.md` (feature breakdown)``.
5. Ensure root `CLAUDE.md` exists containing `@AGENTS.md` (append if missing).

## Step B — Scout (one fast pass)

Spawn **assessment-scout** with `domain: planning`, the cluster map below, and the
**mode** (`quick` if `$ARGUMENTS` is `quick`, else full → 5–10 samples per
cluster). For planning, samples are representative feature docs / specs (and the
dirs new features touch). It returns a per-cluster manifest and a `gaps:` note.
Pass each cluster's sample line to the matching worker in Step C.

## Aspect clusters (planning)

Spawn one `planning-assessor` worker per cluster, in parallel:

- **C1 feature-architecture** — aspects 1 (feature planning structure), 3 (FE-BE integration), 5 (page/route creation)
- **C2 data-services** — aspects 2 (DB/migration), 6 (service integration), 9 (background jobs), 10 (caching)
- **C3 quality-security** — aspects 4 (testing strategy), 11 (security/permissions), 16 (performance)
- **C4 integrations** — aspects 7 (email/notification), 8 (file upload/storage), 12 (config/env)
- **C5 delivery** — aspects 13 (documentation), 14 (deployment/release), 15 (rollback/recovery), 17 (monitoring)

## Step C — Fan out workers (PARALLEL, fragment-write)

First `mkdir -p .claude/.hypr-parts`. Then, in **one message**, launch all
five `planning-assessor` workers concurrently. Each worker **writes its own
fragment** `.claude/.hypr-parts/planning-<cluster>.md` (distinct files → no
contention) and returns only a one-line summary — it does **not** return rule
text. Each worker prompt must include:

- its cluster id, **fragment path**, and the **aspect numbers + names** it owns,
- the scout's **sample file list** for that cluster (and the `gaps:` note),
- the **rule budget**: full → 2–5 rules per aspect with evidence; `quick` → 2–3,
- its contract: write blocks with `id: PENDING` to the fragment, no external docs,
  skip aspects with no evidence, final message = one summary line.

Collect the five summary lines (rule counts + skipped aspects).

## Step D — Assemble (cheap: `cat` + deterministic renumber, no re-emit)

Do **not** retype rules. Assemble with shell:

1. `cat .claude/.hypr-parts/planning-c1.md … planning-c5.md > /tmp/pl-body.md`
2. Renumber `id: PENDING` → sequential, deterministically:

   ```
   awk 'BEGIN{n=0} /^id: PENDING$/{n++; printf "id: PL-%03d\n", n; next} {print}' /tmp/pl-body.md > /tmp/pl-num.md
   ```

   `n` = rule count; `next_id` = `n + 1`.
3. Prepend the Step A frontmatter + `hypr-meta` (with `next_id`) and write
   `.claude/rules/planning.md` (skeleton + body).
4. **Mechanical lint** (deterministic): bad severity
   `grep -nE '^severity:' … | grep -vE 'severity: (error|warn|info)$'`; multi/brace
   scope `grep -nE '^scope:.*[,{}]' …`; `check:` present on every block
   (`grep -c '^id:'` == `grep -c '^check:'`); no leftover `id: PENDING`
   (`grep -n '^id: PENDING' …` empty); no duplicate IDs
   (`grep '^id:' … | sort | uniq -d` empty); `next_id` = highest ID + 1. Fix hits,
   re-run step 2 if you add/remove a block.
5. **Do NOT widen `paths:`** — leave it at `features/**` (see Step A); planning
   rules load at plan-time, not from block scopes.

De-dupe is a judgment call — it happens in Step E (the critic), not here.

## Step E — Coverage critic (parity guard) + cleanup

Spawn **coverage-critic** with `domain: planning`, the full aspect catalog (1–17),
the scout's `gaps:` note, and the **mode**. The critic runs **lean** — it skips
the mechanical checks the Step D lint already did and only judges coverage
gaps/thin coverage, duplicates, genericness, and severity miscalibration
(spot-checking ~5 citations). For planning the `paths:`-superset check does not
apply — `paths:` stays `features/**`. Apply its fixes (fill gaps, merge/drop
duplicates, rewrite generic rules, fix miscalibrated severities); if you
add/remove a block, **re-run the Step D renumber and lint** and reset `next_id` —
first reset every ID (`sed -E 's/^id: PL-[0-9]+$/id: PENDING/'`) so the renumber
sees all blocks, not just new ones. Then `rm -rf .claude/.hypr-parts`.

## Step F — Report (single approval gate + speed metric)

1. `END_TS=$(date +%s)`; report wall-clock `END_TS - START_TS`.
2. Present one summary for approval: rule count, aspects covered (X/Y, N/A noted),
   critic verdict, elapsed time.

## After Assessment

- `/hypr:plan` to create feature plans
- `/hypr:validate planning` to verify the rule set
- `/hypr:checks planning` to mechanize any structural rules (most planning rules
  stay advisory, so expect few or none)
- `/hypr:refresh planning` to re-assess incrementally as the codebase evolves
