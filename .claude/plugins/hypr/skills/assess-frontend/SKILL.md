---
name: assess-frontend
description: Run the frontend assessment — orchestrates a scout + parallel assessor workers to analyze your component patterns and generate a frontend rule set
disable-model-invocation: true
---

# Frontend Assessment (parallel orchestrator)

You are the **orchestrator** for the Hypr frontend assessment. You do NOT analyze
aspects yourself — you set up the rule file, fan out parallel `frontend-assessor`
workers over aspect clusters, then assemble and quality-check their output. This
replaces the old single-agent, one-aspect-at-a-time walk (which took ~45–60 min);
the parallel design targets a fraction of that wall-clock at parity quality.

> **You must orchestrate at this (command) level.** Subagents cannot spawn
> subagents, so launch the scout, the workers, and the critic yourself with the
> Agent tool. Launch all workers **in a single message** (multiple Agent calls in
> one turn) so they run concurrently — that parallelism is the entire speedup.

## Prerequisites Check

1. Check if `.claude/rules/` exists (create if not).
2. If `.claude/rules/frontend.md` already exists, warn the user it will be
   overwritten and confirm. (For an incremental update, use `/hypr:refresh frontend`.)

`$ARGUMENTS`: `quick` → fewer rules per aspect (2–3) and ~5 samples per cluster;
empty → full assessment.

## Step A — Provenance + skeleton (run ONCE, before any worker)

1. `START_TS=$(date +%s)`.
2. Provenance: `git rev-parse HEAD`, `date +%Y-%m-%d`, plugin version (best
   effort from `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`, else `unknown`).
3. Create `.claude/rules/frontend.md` with `paths:` frontmatter + `hypr-meta`
   header (Location Contract in `docs/rules-format.md`), `next_id: 1` for now:

````
---
paths:
  - "src/components/**/*.tsx"
  - "src/**/*.tsx"
---

```hypr-meta
domain: frontend
base_commit: <sha>
generated_at: <date>
plugin_version: <version, or unknown>
next_id: 1
```
````

   Seed `paths:` from the frontend source dirs you can see; widen it in Step D.
4. Ensure root `AGENTS.md` exists; add/update the Frontend entry:
   ``- **Frontend** — `.claude/rules/frontend.md` (components, styling, state)``.
5. Ensure root `CLAUDE.md` exists containing `@AGENTS.md` (append if missing).

## Step B — Scout (one fast pass)

Spawn **assessment-scout** with `domain: frontend`, the cluster map below, and the
**mode** (`quick` if `$ARGUMENTS` is `quick`, else full → 5–10 samples per
cluster). It returns a per-cluster sample-file manifest and a `gaps:` note. Pass
each cluster's sample line to the matching worker in Step C.

## Aspect clusters (frontend)

Spawn one `frontend-assessor` worker per cluster, in parallel:

- **C1 component-structure** — aspects 1 (component structure/naming), 2 (file organization), 6 (import/export)
- **C2 styling-state** — aspects 3 (styling), 4 (state management), 5 (props/data flow)
- **C3 types-errors-perf** — aspects 7 (types/language), 8 (error handling), 14 (performance)
- **C4 data-forms-routing** — aspects 10 (forms/validation), 11 (data fetching/API), 12 (routing/navigation)
- **C5 cross-cutting** — aspects 9 (testing), 13 (permissions/security), 15 (config), 16 (docs), 17 (build/tooling)

## Step C — Fan out workers (PARALLEL, fragment-write)

First `mkdir -p .claude/.hypr-parts`. Then, in **one message**, launch all
five `frontend-assessor` workers concurrently. Each worker **writes its own
fragment** `.claude/.hypr-parts/frontend-<cluster>.md` (distinct files → no
contention) and returns only a one-line summary — it does **not** return rule
text, so you never ingest the rules into your context (the speedup over re-emitting
the file). Each worker prompt must include:

- its cluster id, **fragment path**, and the **aspect numbers + names** it owns,
- the scout's **sample file list** for that cluster (and the `gaps:` note),
- the **rule budget**: full → 2–5 rules per aspect with evidence; `quick` → 2–3,
- its contract: write blocks with `id: PENDING` to the fragment, no external docs,
  skip aspects with no evidence, final message = one summary line.

Collect the five summary lines (rule counts + skipped aspects).

## Step D — Assemble (cheap: `cat` + deterministic renumber, no re-emit)

Do **not** retype rules. Assemble with shell:

1. `cat .claude/.hypr-parts/frontend-c1.md … frontend-c5.md > /tmp/fe-body.md`
2. Renumber `id: PENDING` → sequential, deterministically:

   ```
   awk 'BEGIN{n=0} /^id: PENDING$/{n++; printf "id: FE-%03d\n", n; next} {print}' /tmp/fe-body.md > /tmp/fe-num.md
   ```

   `n` = rule count; `next_id` = `n + 1`.
3. Prepend the Step A frontmatter + `hypr-meta` (with `next_id`) and write
   `.claude/rules/frontend.md` (skeleton + body).
4. **Mechanical lint** (deterministic): bad severity
   `grep -nE '^severity:' … | grep -vE 'severity: (error|warn|info)$'`; multi/brace
   scope `grep -nE '^scope:.*[,{}]' …`; `check:` present on every block
   (`grep -c '^id:'` == `grep -c '^check:'`); no leftover `id: PENDING`
   (`grep -n '^id: PENDING' …` empty); no duplicate IDs
   (`grep '^id:' … | sort | uniq -d` empty); `next_id` = highest ID + 1. Fix hits,
   re-run step 2 if you add/remove a block.
5. **Widen `paths:`** to a superset of the scopes present
   (`grep '^scope:' … | sort -u`; broad domain glob `src/**/*.{ts,tsx}` when in
   doubt). An uncovered scope silently never loads.

De-dupe is a judgment call — it happens in Step E (the critic), not here.

## Step E — Coverage critic (parity guard) + cleanup

Spawn **coverage-critic** with `domain: frontend`, the full aspect catalog (1–17),
the scout's `gaps:` note, and the **mode**. The critic runs **lean** — it skips
the mechanical checks the Step D lint already did and only judges coverage
gaps/thin coverage, duplicates, genericness, and severity miscalibration
(spot-checking ~5 citations). Apply its fixes (fill gaps, merge/drop duplicates,
rewrite generic rules, fix miscalibrated severities). If you add/remove a block,
**re-run the Step D renumber and lint** and reset `next_id` — first reset every ID
(`sed -E 's/^id: FE-[0-9]+$/id: PENDING/'`) so the renumber sees all blocks, not
just new ones. Then `rm -rf .claude/.hypr-parts`.

## Step F — Report (single approval gate + speed metric)

1. `END_TS=$(date +%s)`; report wall-clock `END_TS - START_TS`.
2. Present one summary for approval: rule count, aspects covered (X/Y, N/A noted),
   critic verdict, elapsed time.

## After Assessment

- `/hypr:implement` to implement frontend chunks
- `/hypr:validate frontend` to verify the rule set
- `/hypr:checks frontend` to mechanize structural rules into ast-grep checks
- `/hypr:refresh frontend` to re-assess incrementally as the codebase evolves
