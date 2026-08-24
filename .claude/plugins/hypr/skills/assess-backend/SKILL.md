---
name: assess-backend
description: Run the backend assessment — orchestrates a scout + parallel assessor workers to analyze your API and service patterns and generate a backend rule set
disable-model-invocation: true
---

# Backend Assessment (parallel orchestrator)

You are the **orchestrator** for the Hypr backend assessment. You do NOT analyze
aspects yourself — you set up the rule file, fan out parallel `backend-assessor`
workers over aspect clusters, then assemble and quality-check their output. This
replaces the old single-agent, one-aspect-at-a-time walk (which took ~45–60 min);
the parallel design targets a fraction of that wall-clock at parity quality.

> **You must orchestrate at this (command) level.** Subagents cannot spawn
> subagents, so launch the scout, the workers, and the critic yourself with the
> Agent tool. Launch all workers **in a single message** (multiple Agent calls in
> one turn) so they run concurrently — that parallelism is the entire speedup.

## Prerequisites Check

1. Check if `.claude/rules/` exists (create if not).
2. If `.claude/rules/backend.md` already exists, warn the user it will be
   overwritten and confirm. (For an incremental update, point them at
   `/hypr:refresh backend` instead.)

`$ARGUMENTS`: `quick` → tell workers to emit fewer rules per aspect (2–3) and the
scout to pick ~5 samples per cluster; empty → full assessment.

## Step A — Provenance + skeleton (run ONCE, before any worker)

Capture provenance and create the skeleton file the workers will populate. This
moved here from the assessor so parallel workers never race on file creation.

1. `START_TS=$(date +%s)` — record start time for the speed metric.
2. Provenance: `git rev-parse HEAD` (base commit), `date +%Y-%m-%d` (today),
   plugin version (best effort: read `version` from
   `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`; else `unknown`).
3. Create `.claude/rules/backend.md` with `paths:` frontmatter + a `hypr-meta`
   header (per the Location Contract in `docs/rules-format.md`), `next_id: 1` for
   now (finalized in Step D):

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
plugin_version: <version, or unknown>
next_id: 1
```
````

   Seed `paths:` from the backend source dirs you can see; you will widen it in
   Step D to a superset of every rule's `scope`.
4. Ensure root `AGENTS.md` exists (create with a one-paragraph overview + a
   `## Rule sets` index if missing); add/update the Backend entry:
   ``- **Backend** — `.claude/rules/backend.md` (API, services, data access)``.
5. Ensure root `CLAUDE.md` exists containing the line `@AGENTS.md` (append if
   missing).

## Step B — Scout (one fast pass)

Spawn the **assessment-scout** agent with `domain: backend`, the cluster map
below, and the **mode** (`quick` if `$ARGUMENTS` is `quick`, else full → 5–10
samples per cluster). It returns a per-cluster sample-file manifest and a `gaps:`
note. Pass each cluster's sample line to the matching worker in Step C.

## Aspect clusters (backend)

Spawn one `backend-assessor` worker per cluster, in parallel:

- **C1 api-routing** — aspects 1 (API endpoint structure), 7 (service/controller org)
- **C2 data** — aspects 3 (DB queries/transactions), 8 (migrations), 13 (caching)
- **C3 auth-security** — aspects 4 (auth), 12 (permissions/security), 17 (rate limiting)
- **C4 validation-errors** — aspects 5 (request validation), 6 (error handling)
- **C5 async-integration** — aspects 9 (async ops), 14 (background jobs), 15 (file upload), 16 (email/notification)
- **C6 cross-cutting** — aspects 2 (file org), 10 (logging/monitoring), 11 (testing), 18 (config), 19 (docs), 20 (types/language), 21 (build/deploy)

## Step C — Fan out workers (PARALLEL, fragment-write)

First `mkdir -p .claude/.hypr-parts`. Then, in **one message**, launch all
six `backend-assessor` workers concurrently. Each worker **writes its own
fragment** `.claude/.hypr-parts/backend-<cluster>.md` (distinct files → no
contention) and returns only a one-line summary — it does **not** return rule
text, so you never ingest 69 rules into your context (this is the speedup over
re-emitting the file yourself). Each worker prompt must include:

- its cluster id, **fragment path**, and the **aspect numbers + names** it owns,
- the scout's **sample file list** for that cluster (and the `gaps:` note),
- the **rule budget**: full → 2–5 rules per aspect with evidence; `quick` → 2–3,
- its contract: write blocks with `id: PENDING` to the fragment, no external docs,
  skip aspects with no evidence, final message = one summary line.

Collect the six summary lines (rule counts + skipped aspects).

## Step D — Assemble (cheap: `cat` + deterministic renumber, no re-emit)

Do **not** retype rules. Assemble with shell so synthesis costs ~no output tokens:

1. **Concatenate** fragments in cluster order into a body file:
   `cat .claude/.hypr-parts/backend-c1.md … backend-c6.md > /tmp/be-body.md`
2. **Renumber** `id: PENDING` → sequential IDs deterministically:

   ```
   awk 'BEGIN{n=0} /^id: PENDING$/{n++; printf "id: BE-%03d\n", n; next} {print}' /tmp/be-body.md > /tmp/be-num.md
   ```

   The final `n` is the rule count; `next_id` = `n + 1`.
3. **Prepend** the frontmatter + `hypr-meta` skeleton from Step A (with `next_id`
   set to `n+1`) and **write** `.claude/rules/backend.md` (= skeleton + `/tmp/be-num.md` body).
4. **Mechanical lint** (deterministic — replaces the old by-hand format repair):
   - bad severity: `grep -nE '^severity:' .claude/rules/backend.md | grep -vE 'severity: (error|warn|info)$'`
   - multi/brace scope: `grep -nE '^scope:.*[,{}]' .claude/rules/backend.md`
   - every block has a `check:`: `[ "$(grep -c '^id:' …)" = "$(grep -c '^check:' …)" ]`
   - leftover placeholder: `grep -n '^id: PENDING' .claude/rules/backend.md` (must be empty)
   - duplicate IDs: `grep '^id:' .claude/rules/backend.md | sort | uniq -d` (must be empty)
   - `next_id` in `hypr-meta` = highest assigned ID + 1
   Fix any hits with a targeted edit (split a multi-glob scope into one rule per
   glob, add a missing `check:`), then re-run the renumber from step 2 if you
   added/removed a block.
5. **Set `paths:`** as a superset of the scopes present:
   `grep '^scope:' .claude/rules/backend.md | sort -u` → widen `paths:` to cover
   them (when in doubt use the broad domain glob `server/src/**/*.{ts,tsx}`, plus
   any non-`src` files cited like `tsconfig.json`/`CLAUDE.md`), then confirm every
   listed scope falls inside some `paths:` glob. An uncovered scope silently never
   loads.

De-dupe is a judgment call — it happens in Step E (the critic), not here.

## Step E — Coverage critic (parity guard) + cleanup

Spawn the **coverage-critic** agent with `domain: backend`, the full aspect
catalog (1–21), the scout's `gaps:` note, and the **mode**. The critic now runs
**lean** — it skips the mechanical checks already done by the Step D lint and only
judges: coverage gaps / thin coverage, duplicates, genericness, and severity
miscalibration (spot-checking ~5 citations, not all). Apply its fixes — fill
genuine coverage gaps, merge/drop duplicates, rewrite generic rules, fix
miscalibrated severities. If you added or removed any block, **re-run the Step D
renumber and lint** so IDs stay contiguous and `next_id` is reset — first reset
every ID (`sed -E 's/^id: BE-[0-9]+$/id: PENDING/'`) so the renumber sees all
blocks, not just new ones. Then remove the scratch dir:
`rm -rf .claude/.hypr-parts`.

## Step F — Report (single approval gate + speed metric)

1. `END_TS=$(date +%s)`; report wall-clock `END_TS - START_TS` (seconds) — this is
   the Phase-1 speed baseline; note it so refreshes can be compared.
2. Present a summary for **one** approval (no mid-stream checkpoints anymore):
   rule count, aspects covered (X/Y, with genuine N/A noted), critic verdict, and
   the elapsed time.

## After Assessment

- `/hypr:implement` to implement backend chunks
- `/hypr:validate backend` to verify the rule set
- `/hypr:checks backend` to mechanize structural rules into ast-grep checks
  (needs the ast-grep CLI; `/hypr:checks` tells you how to install it)
- `/hypr:refresh backend` to re-assess incrementally as the codebase evolves
