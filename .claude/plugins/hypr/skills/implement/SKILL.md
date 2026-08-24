---
name: implement
description: Implement a specific chunk from a feature plan following your project patterns
argument-hint: <chunk>
---

# Chunk Implementation

> **Model-invocable by design** — `/hypr:build-chunk` and `/hypr:eval` use this
> skill's flow mid-run; `disable-model-invocation` would break that orchestration.

You are implementing a feature chunk using Hypr. This command routes to the appropriate executor agent based on the chunk type.

**CRITICAL: This command ONLY implements chunks. Do NOT create todo lists or plan additional work. Focus solely on implementing the specified chunk(s).**

## Prerequisites Check

First, verify the setup:

1. Check if `.claude/rules/frontend.md` exists (for frontend chunks)
2. Check if `.claude/rules/backend.md` exists (for backend chunks)
3. If neither exists, tell user to run the appropriate assessment first

## Chunk Selection

The chunk to implement is provided in $ARGUMENTS.

### If $ARGUMENTS specifies a chunk

Implement ONLY that specific chunk. Do not implement other chunks.

### If $ARGUMENTS is empty or just a feature file

1. Read the feature document
2. Identify all chunks that have NO unfinished dependencies (can be implemented now)
3. If multiple chunks can be implemented in parallel, ASK the user:

   ```
   The following chunks have no dependencies and can be implemented:
   - Chunk 1: [name]
   - Chunk 2: [name]

   Would you like to:
   A) Implement all of these in parallel
   B) Just implement Chunk 1 first
   ```

4. Wait for user response before proceeding

**Expected argument formats:**

- Feature file path: `features/feature-001-auth.md`
- Chunk reference: `feature-001 chunk 2`
- Chunk name: `"Create login form component"`

## Implementation Process

### Step 1: Load Feature Document

Read the feature document to understand:

- The chunk's requirements
- Dependencies on other chunks
- Files to create/modify
- Acceptance criteria

### Step 2: Determine Chunk Type

Based on the chunk's **Type** field:

- **Frontend** → Use **frontend-executor** agent
- **Backend** → Use **backend-executor** agent
- **Both** → Ask user which part to start with

### Step 3: Execute Implementation

Route to the appropriate agent:

**For Frontend chunks:**

- Load `.claude/rules/frontend.md` patterns
- Follow 8-step per-file implementation loop
- ONE FILE AT A TIME

**For Backend chunks:**

- Load `.claude/rules/backend.md` patterns
- Follow 7-step per-file implementation loop
- ONE FILE AT A TIME

### Step 4: Update Feature Document

After completing a chunk:

- Mark chunk as complete in the feature document
- Note any issues or deviations
- Update progress tracking

## Critical Rules

- **ONLY IMPLEMENT THE SPECIFIED CHUNK(S)** - Do not plan or implement other chunks
- **NO TODO LISTS** - Do not create todo lists for future chunks
- **ONE FILE AT A TIME** - Never create multiple files in one response
- **FOLLOW ALL STEPS** - Complete all 7-8 steps before moving to next file
- **VERIFY PATTERNS** - Every file must match project patterns
- **RUN TESTS** - Tests must pass before moving on
- **STOP WHEN CHUNK IS DONE** - After completing the chunk(s), stop and report completion

## Example Usage

```
/hypr:implement features/feature-001-auth.md chunk 1
/hypr:implement "Create login API endpoint"
/hypr:implement feature-002 chunk 3
/hypr:implement features/feature-001-auth.md   # Will ask about parallel chunks
```

## Progress Tracking

After each file is complete, report:

- [ ] File created/modified
- [ ] Pattern compliance verified
- [ ] Types pass
- [ ] Tests pass (if applicable)
- [ ] Integration verified

When the specified chunk(s) are complete:

1. Update the feature document
2. Report what was completed
3. **STOP** - Do not automatically continue to other chunks
