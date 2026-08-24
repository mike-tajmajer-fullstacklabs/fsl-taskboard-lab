---
name: chunk-breakdown
description: Breaks features into small, implementable chunks with clear dependencies and acceptance criteria. Used during feature planning.
user-invocable: false
---

# Chunk Breakdown

This skill breaks features into small, implementable chunks that can be completed in a single development session. Each chunk should be independently testable and deployable.

## When This Skill Activates

This skill is automatically invoked when:

- Creating feature plans with the feature-planner agent
- Breaking down complex requirements
- Estimating implementation work
- Sequencing development tasks

## Chunk Principles

### Size Constraints

- **Maximum time**: < 2 hours of implementation
- **Maximum files**: 1-3 files per chunk
- **Minimum scope**: Must be testable/verifiable alone
- **Independence**: Minimal dependencies on other chunks

### Chunk Types

- **Frontend**: UI components, styling, client-side logic
- **Backend**: API endpoints, services, database operations
- **Both**: Full-stack features requiring coordinated changes

## Breakdown Process

### Step 1: Identify Feature Boundaries

Map the feature's scope:

- What new UI elements are needed?
- What new API endpoints are needed?
- What database changes are required?
- What existing code needs modification?

### Step 2: Find Natural Seams

Look for logical boundaries:

- Separate UI from data fetching
- Separate API from business logic
- Separate database from services
- Separate core from enhancements

### Step 3: Create Atomic Chunks

Each chunk should:

- Have a single responsibility
- Be completable without other chunks existing
- Have clear inputs and outputs
- Be testable in isolation

### Step 4: Define Dependencies

Map chunk relationships:

- Which chunks must complete first?
- Which chunks can run in parallel?
- What's the critical path?

### Step 5: Add Acceptance Criteria

For each chunk, define:

- What does "done" look like?
- How do we verify it works?
- What tests should pass?

## Chunk Template

```markdown
### Chunk [N]: [Descriptive Name]

**Type:** Frontend | Backend | Both
**Dependencies:** None | Chunk X must be completed first
**Estimated time:** [30min-2hrs]

**Files to create/modify:**
- path/to/file1.tsx (create)
- path/to/file2.ts (modify)

**Description:**
[What this chunk implements]

**Acceptance criteria:**
- [ ] [Specific, verifiable outcome 1]
- [ ] [Specific, verifiable outcome 2]
- [ ] [Test requirement if applicable]
```

## Breakdown Examples

### Example: User Authentication Feature

**Bad breakdown** (chunks too large):

1. Implement authentication (too vague, too large)
2. Add tests (bundled with implementation)

**Good breakdown** (proper chunks):

```markdown
### Chunk 1: Create User model and migration
**Type:** Backend
**Dependencies:** None
**Files:** src/models/User.ts, migrations/001_create_users.ts
**Acceptance:**
- [ ] User model with email, passwordHash fields
- [ ] Migration runs successfully
- [ ] Model can create/read users

### Chunk 2: Create authentication service
**Type:** Backend
**Dependencies:** Chunk 1
**Files:** src/services/AuthService.ts
**Acceptance:**
- [ ] hashPassword function works
- [ ] verifyPassword function works
- [ ] Unit tests pass

### Chunk 3: Create login API endpoint
**Type:** Backend
**Dependencies:** Chunk 2
**Files:** src/routes/auth.ts
**Acceptance:**
- [ ] POST /api/auth/login endpoint exists
- [ ] Returns JWT on valid credentials
- [ ] Returns 401 on invalid credentials

### Chunk 4: Create login form component
**Type:** Frontend
**Dependencies:** None (can parallel with backend)
**Files:** src/features/auth/LoginForm.tsx
**Acceptance:**
- [ ] Form with email/password fields
- [ ] Client-side validation
- [ ] Follows project component patterns

### Chunk 5: Integrate login form with API
**Type:** Frontend
**Dependencies:** Chunks 3, 4
**Files:** src/features/auth/LoginForm.tsx, src/hooks/useAuth.ts
**Acceptance:**
- [ ] Form calls login API
- [ ] Success redirects to dashboard
- [ ] Errors display to user
```

## Quality Checks

Before finalizing chunks:

- [ ] Each chunk is < 2 hours of work
- [ ] Each chunk has clear acceptance criteria
- [ ] Dependencies are explicitly stated
- [ ] File paths are specific
- [ ] No chunk requires another chunk's completion to start (unless stated)
- [ ] Chunks can be assigned to different developers
- [ ] Each chunk results in working, testable code
