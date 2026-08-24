---
name: build-chunk
description: Implement and review a chunk until approved, handling the full implement → review → fix cycle automatically
argument-hint: <chunk>
disable-model-invocation: true
---

# Build Chunk

You are building a feature chunk using Hypr. This command orchestrates the full implementation cycle: implement → review → fix → re-review, repeating until the chunk is approved.

## Prerequisites Check

First, verify the setup:

1. Check if `.claude/rules/frontend.md` exists (for frontend chunks)
2. Check if `.claude/rules/backend.md` exists (for backend chunks)
3. If neither exists, tell user to run the appropriate assessment first

## Chunk Selection

The chunk to build is provided in $ARGUMENTS.

**Expected argument formats:**

- Feature file path with chunk: `features/feature-001-auth.md chunk 1`
- Chunk reference: `feature-001 chunk 2`
- Chunk name: `"Create login form component"`

### If $ARGUMENTS is empty

Ask the user which chunk they want to build.

## Build Cycle

Execute this cycle until the chunk is APPROVED:

```
┌─────────────────────────────────────────────────┐
│                 BUILD CYCLE                      │
├─────────────────────────────────────────────────┤
│                                                  │
│  1. IMPLEMENT                                    │
│     └── Use implementation process from          │
│         /hypr:implement                          │
│     └── Follow 7-8 step per-file loop           │
│     └── Update chunk status to "Implemented"    │
│                                                  │
│  2. REVIEW                                       │
│     └── Use review process from /hypr:review    │
│     └── Check pattern compliance                │
│     └── Verify acceptance criteria              │
│     └── Generate review report                  │
│                                                  │
│  3. EVALUATE OUTCOME                            │
│     ├── APPROVED → Exit cycle, chunk complete   │
│     ├── CHANGES REQUESTED → Fix issues, repeat  │
│     └── BLOCKED → Stop and escalate to user     │
│                                                  │
└─────────────────────────────────────────────────┘
```

### Step 1: Implement

Follow the implementation process:

1. Load the feature document and identify the chunk
2. Determine chunk type (Frontend/Backend/Both)
3. Load appropriate agent rules
4. Execute the per-file implementation loop (7-8 steps)
5. Update chunk status to "Implemented"

### Step 2: Review

Run the **panel review** from `/hypr:review` on the chunk's files:

1. `/hypr:conformance` first (machine-checkable rules)
2. Fan out the lens panel in parallel (conformance / criteria / correctness / tests)
3. Adversarially verify each finding, then gate by confidence × severity
4. Produce the review report with a gated outcome (APPROVED / CHANGES REQUESTED / BLOCKED)

**On a re-review (cycle 2+), only re-run the lenses that produced the prior
findings** (plus `conformance` if rules-related fixes were made) — no need to
re-run the full panel when only a couple of issues were outstanding.

### Step 3: Evaluate and Continue

Based on review outcome:

**If APPROVED:**

- Update chunk status to "Reviewed"
- Update review status to "Approved"
- Log to Progress Log
- Report completion to user
- **EXIT the cycle**

**If CHANGES REQUESTED:**

- List the specific issues found
- Fix each issue following the same patterns
- Re-run review (go back to Step 2)
- **Maximum 3 fix attempts** before asking user for help

**If BLOCKED:**

- Report the blocking issues to user
- **EXIT the cycle** and wait for user decision

## Cycle Limits

To prevent infinite loops:

- **Max review cycles:** 3
- After 3 failed reviews, stop and ask user:

  ```
  This chunk has failed review 3 times. Issues remaining:
  - [list issues]

  Would you like to:
  A) Continue trying to fix these issues
  B) Skip review and mark as implemented
  C) Abandon this chunk and revisit the plan
  ```

## Progress Reporting

After each cycle iteration, report:

```
## Build Progress: [Chunk Name]

**Cycle:** [N] of 3
**Implementation:** Complete
**Review Status:** [APPROVED / CHANGES REQUESTED / BLOCKED]

### Issues Fixed This Cycle:
- [issue 1] ✓
- [issue 2] ✓

### Remaining Issues:
- [issue 3] - [fix in progress]
```

## Example Usage

```
/hypr:build-chunk features/feature-001-auth.md chunk 1
/hypr:build-chunk feature-002 chunk 3
/hypr:build-chunk "Create login API endpoint"
```

## Success Criteria

A chunk build is complete when:

- [ ] All files implemented following project patterns
- [ ] All acceptance criteria met
- [ ] Tests exist and pass (if applicable)
- [ ] Review status is APPROVED
- [ ] Feature document updated with final status

## Critical Rules

- **ONE CHUNK AT A TIME** - Never build multiple chunks in one invocation
- **FOLLOW ALL STEPS** - Don't skip implementation or review steps
- **RESPECT CYCLE LIMITS** - Stop after 3 failed reviews
- **UPDATE STATUS** - Keep feature document current throughout
- **REPORT PROGRESS** - User should see status after each cycle
