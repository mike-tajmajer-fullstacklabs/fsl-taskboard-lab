---
name: validate
description: Validate that a generated agent correctly reflects your project patterns
argument-hint: planning | frontend | backend | all
disable-model-invocation: true
---

# Agent Validation

You are validating a Hypr agent to ensure it correctly reflects your project patterns.

## Agent to Validate

The agent type is provided in $ARGUMENTS.

**Valid options:**

- `planning` - Validate `.claude/rules/planning.md`
- `frontend` - Validate `.claude/rules/frontend.md`
- `backend` - Validate `.claude/rules/backend.md`
- `all` - Validate all existing agents

If $ARGUMENTS is empty, ask which agent(s) to validate.

## Validation Process

### Step 1: Load Agent File

Read the specified rule file from `.claude/rules/`.

If the file doesn't exist, inform the user they need to run the assessment first:

- `/hypr:assess-planning` for planning agent
- `/hypr:assess-frontend` for frontend agent
- `/hypr:assess-backend` for backend agent

### Step 2: Extract Rules

Parse each `rule` block from the agent file, keyed by its `id` (see `docs/rules-format.md`).

### Step 3: Validate Each Rule

For each rule, perform these checks:

0. **Format Conformance Check** (mechanical, run first)
   - **Severity vocabulary**: `severity` must be exactly `error`, `warn`, or
     `info`. Flag any other token — most commonly `warning` (should be `warn`) —
     since consumers and the ast-grep severity mapping key on the canonical three
     (see `docs/rules-format.md`).
   - **Atomicity**: flag a block whose `statement` bundles several independent
     conventions (e.g. quoting + import-type + build command in one rule). A
     compound rule can't carry a single meaningful `severity` or `check` and
     should be split into one block per convention.
   - **Field completeness**: all six fields present, in order; `scope` is a
     single glob; `id` matches the domain prefix + zero-padded number.

1. **Specificity Check**
   - Is the rule specific to THIS project?
   - Does it include actual file paths or examples?
   - Would this rule be different for another project?

2. **Accuracy Check**
   - Find files in the codebase that should follow this rule
   - Verify the pattern described actually exists
   - Look for counter-examples that violate the rule

3. **Completeness Check**
   - Are there patterns in the codebase NOT covered by rules?
   - Are there important variations not documented?

4. **Currency Check** (use the **Freshness** algorithm in `docs/rules-format.md`, same as `/hypr:status` and `/hypr:refresh`)
   - Compute changes since the file's `hypr-meta` `base_commit` (with the ancestor guard); report commits-behind and in-scope changes.
   - Flag **likely-stale rules**: blocks whose `example:` source was modified, renamed, or deleted since `base_commit`.

### Step 4: Report Findings

For each issue found, report:

- **Rule `id`** and statement
- **Issue type**: Malformed (severity/atomicity/field), Inaccurate, Outdated, Incomplete, or Too Generic
- **Evidence**: Files that contradict or aren't covered
- **Suggested fix**: How to correct the rule

### Step 5: Summary

Provide an overall assessment:

- **Rules validated**: X of Y
- **Issues found**: List by category
- **Coverage gaps**: Patterns not covered
- **Recommendation**: Whether to re-run assessment

## Output Format

```markdown
## Validation Report: [Agent Type]

### Summary
- Total rules: X
- Valid rules: X
- Issues found: X
- Coverage: X%

### Issues

#### [Rule id, e.g. BE-005]: "[statement]"
- **Issue**: [Description]
- **Evidence**: [File paths showing issue]
- **Fix**: [Suggested correction]

### Missing Patterns
- [Pattern not covered by any rule]

### Recommendations
- [What to do next]
```

## Example Usage

```
/hypr:validate planning
/hypr:validate frontend
/hypr:validate all
```

## After Validation

Based on findings:

- **Few issues**: Manually update rules in agent file
- **Many issues**: Re-run assessment with `/hypr:refresh [type]`
- **Missing patterns**: Add rules manually or re-assess

For a deterministic, measured pass over the **machine-checkable** rules (those
with `check: ast-grep`), run `/hypr:conformance` — it complements this reasoning
pass with actual ast-grep results.
