---
name: refresh
description: Re-run assessment to update agents with evolved codebase patterns
argument-hint: planning | frontend | backend
disable-model-invocation: true
---

# Agent Refresh

You are refreshing a Hypr agent to update it with evolved codebase patterns.

## Agent to Refresh

The agent type is provided in $ARGUMENTS.

**Valid options:**

- `planning` - Refresh `.claude/rules/planning.md`
- `frontend` - Refresh `.claude/rules/frontend.md`
- `backend` - Refresh `.claude/rules/backend.md`
- `all` - Refresh all existing rule sets

If you find a legacy `.claude/agents/{type}-agent.md` from an older Hypr version,
migrate it: regenerate into `.claude/rules/{type}.md` and remove the old file.

If $ARGUMENTS is empty, ask which agent(s) to refresh.

## When to Refresh

Consider refreshing agents when:

- Significant new features have been added
- Coding conventions have changed
- New patterns have emerged
- `/hypr:validate` found many issues
- Team members report agent suggestions don't match current patterns

## Refresh Process

### Step 1: Locate and back up the rule file

Target `.claude/rules/[type].md`. Copy it to `.claude/rules/[type].md.backup`.

### Step 2: Apply pending corrections (priors)

Before any diff-driven work, fold in real-world corrections so this refresh
improves the rules instead of regenerating them blind. Read
`.claude/rules/[type].corrections.md` (if present) and apply each un-archived
`correction` block as a **prior** (format + semantics in `docs/evals.md`):

- **add** → draft the missing rule now (consume `next_id`, never reuse an id).
- **adjust / tighten / soften** → edit the named rule **in place, keeping its `id`**
  (e.g. drop an over-aggressive `error` to `warn`).
- **exception** → narrow the named rule's `scope` (or note the documented
  exception) so it stops flagging the legitimate case.

Corrections are priors, not gospel: if a correction contradicts what the current
code shows (Step 3+), prefer the code and note the conflict. After applying, move
each handled block under a `## Applied` heading in the corrections file with
today's date so it isn't re-applied next refresh.

### Step 3: Compute what changed (Freshness algorithm)

Follow the **Freshness** algorithm in `docs/rules-format.md`:

- Read `base_commit` from the file's `hypr-meta` header.
- **Guard:** if `base_commit` is missing, or
  `git merge-base --is-ancestor <base_commit> HEAD` exits non-zero (shallow
  clone, rebased/squashed history), the incremental diff is unavailable — tell
  the user and fall back to a FULL re-assessment via `/hypr:assess-[type]`, then
  stop here.
- `git diff --name-status <base_commit> HEAD` → changed/added/deleted/renamed files.
- Map those files to **affected aspects** using the file's `paths:`/`scope`
  globs and each rule's `example:` path. When the mapping is ambiguous, treat
  the aspect as affected (re-assess) rather than skip it.

### Step 4: Targeted re-assessment

Re-assess **only the affected aspects**. Leave unaffected rule blocks
byte-for-byte unchanged.

### Step 5: Currency pass on untouched rules

For each rule you are not re-assessing, reconcile its `example:` path against the
Step 3 `git diff --name-status` output:

- **Renamed (`R` status):** the diff gives `old → new`; if a rule's `example:`
  matches the old path, **update it to the new path and keep the rule's `id`**
  (do not delete it).
- **Deleted (`D` status, with no rename):** remove that rule's block (its `id`
  is retired).
- **Otherwise:** leave the rule unchanged.

Don't rely on `git ls-files`/`test -f` alone — both a deleted and a renamed path
return "missing", so they can't distinguish the two; the `R`/`D` status can.

### Step 6: Merge, preserving IDs

- A rule that persists **keeps its existing `id`** — match by `example:` path
  first, then statement similarity; when unsure, keep the existing id.
- New rules take `next_id` from the `hypr-meta` header and bump it. If `next_id`
  is absent (legacy file), use `max(existing id)+1` — this can reuse a retired
  top ID, so writing `next_id` now repairs the guarantee for future refreshes.
- Removed rules: delete the block; their IDs are **retired and never reused**.
- Update the `hypr-meta` header: `base_commit` = current `git rev-parse HEAD`,
  `generated_at` = today, bumped `next_id`, refreshed `plugin_version` (best
  effort). Resync `paths:` frontmatter if scopes changed.

### Step 7: Validate

- Run `/hypr:validate [type]` to verify
- Test with a small implementation task
- Get user approval on changes
- If this rule set has ast-grep checks (or you want them), run
  `/hypr:checks [type]` to resync them with the refreshed rules — new structural
  rules can be mechanized and checks for changed/retired rules updated. Optional;
  it needs the ast-grep CLI and `/hypr:checks` explains how to install it.

## Refresh vs Full Re-Assessment

| Scenario | Action |
|----------|--------|
| Minor pattern changes | Use `/hypr:refresh` |
| Major architecture change | Re-run full assessment |
| New technology added | Re-run full assessment |
| `base_commit` unreachable (shallow/rebased) | Re-run full assessment |
| Few validation issues | Use `/hypr:refresh` |
| Many validation issues | Re-run full assessment |
| Regular maintenance | Use `/hypr:refresh` |

## Output

The refresh updates:

```
.claude/rules/[type].md
```

And creates a backup at:

```
.claude/rules/[type].md.backup
```

## Change Report

After refresh, provide:

```markdown
## Refresh Report: [Agent Type]

### Changes Made
- Rules updated: X
- Rules added: X
- Rules removed: X
- Rules unchanged: X

### Updated Rules
- [rule id, e.g. BE-005]: [Old] → [New]

### New Rules
- [new rule id]: [New rule statement]

### Removed Rules
- [rule id]: [Removed because...]

### Validation Status
- [Pass/Fail with details]
```

## Example Usage

```
/hypr:refresh planning
/hypr:refresh frontend
/hypr:refresh all
```

## After Refresh

1. Review the change report
2. Test the updated agent with an implementation task
3. If issues remain, consider full re-assessment
