# Feature Development Flow for AI Agents

## Core Principle

Different types of work require different agents with specialized approaches. Never mix planning with execution.

## Agent Types and When to Use

### 1. Plan Agent (Feature-Level Work)

**Use when:** User requests a new feature, enhancement, or complex change

**Process:**

- Follow the feature-planner agent's planning process, using the rules in `.claude/rules/planning.md` (created via /hypr:assess-planning)
- Use project-specific feature planning patterns discovered in the assessment
- Create comprehensive feature documents with proper chunk breakdown
- Never implement code - only plan and document

### 2. Frontend Execute Agent

**Use when:** Working on a specific frontend chunk from a feature plan

**Process:**

- Follow the frontend-executor agent's 8-step per-file implementation loop, using the rules in `.claude/rules/frontend.md`
- Reference the feature document for context and requirements
- Only work on the assigned chunk, not the entire feature

### 3. Backend Execute Agent

**Use when:** Working on a specific backend chunk from a feature plan  

**Process:**

- Follow the backend-executor agent's 7-step per-file implementation loop, using the rules in `.claude/rules/backend.md`
- Reference the feature document for context and requirements
- Only work on the assigned chunk, not the entire feature

## Feature Document Template

Create in `features/feature-XXX.md` with this format:

```markdown
# Feature XXX: [Feature Name]

## Requirements
- [List original user requirements]

## Architecture Design
- [How this feature fits into existing app patterns]
- [What components/services will be created/modified]
- [Integration points with existing systems]

## Implementation Chunks

### Chunk 1: [Name]
**Type:** Frontend/Backend/Both
**Dependencies:** None / Chunk X must be completed first
**Files to create/modify:**
- path/to/file1.tsx
- path/to/file2.ts
**Tests required:** Yes/No - [when to write them]
**Acceptance criteria:**
- [ ] Specific outcome 1
- [ ] Specific outcome 2

### Chunk 2: [Name]  
**Type:** Frontend/Backend/Both
**Dependencies:** Chunk 1 must be completed
**Files to create/modify:**
- path/to/file3.tsx
**Tests required:** Yes - write after Chunk 1 is complete
**Acceptance criteria:**
- [ ] Specific outcome 1

[Continue for all chunks...]

## Testing Strategy
- Unit tests: [when and what to test]
- Integration tests: [when and what to test]  
- E2E tests: [when and what to test]

## Rollback Plan
- [How to undo this feature if needed]
```

## Decision Tree

**User Request → Determine Agent Type:**

```
Is this a new feature or complex change?
├── YES → Use Plan Agent
│   ├── Create feature document
│   ├── Break into chunks
│   └── Hand off chunks to Execute Agents
└── NO → Is it frontend or backend work?
    ├── Frontend → Use Frontend Execute Agent
    └── Backend → Use Backend Execute Agent
```

## Critical Rules

1. **Plan Agent NEVER executes code** - only creates feature documents
2. **Execute Agents NEVER plan features** - only implement assigned chunks
3. **Execute Agents MUST reference the feature document** for context
4. **Execute Agents MUST mark chunks complete** in feature document when done
5. **Plan Agent creates realistic chunks** - small enough for single execute session

## Integration with Existing Patterns

- **Plan Agent** uses project patterns to design features appropriately
- **Frontend Execute Agent** follows the rules in `.claude/rules/frontend.md`
- **Backend Execute Agent** follows the rules in `.claude/rules/backend.md`
- **All agents** use the same verification and documentation standards

## Success Criteria

- Features are properly planned before implementation begins
- Implementation follows established project patterns exactly
- Code is delivered in working, tested chunks
- Feature documents serve as implementation roadmap and documentation
