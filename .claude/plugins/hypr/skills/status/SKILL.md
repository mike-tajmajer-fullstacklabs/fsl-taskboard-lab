---
name: status
description: Show the current Hypr setup status, installed agents, and installed skills
disable-model-invocation: true
---

# Hypr Status

You are checking the current Hypr setup status for this project.

## Status Check

Perform the following checks and report to the user:

### 1. Directory Structure

Check if these directories exist:

- `.claude/` - Main Hypr directory
- `.claude/rules/` - Generated, path-scoped rule sets
- `.claude/agents/` - Optional agents installed via `/hypr:add`
- `.claude/skills/` - Installed skills
- `features/` - Feature documents
- `AGENTS.md` / `CLAUDE.md` - Portable rule overview + Claude import

Report: Which directories exist and which are missing.

### 2. Rule Set Status

For each rule set, check (read provenance from the file's `hypr-meta` header —
never use file mtime):

**Planning** (`.claude/rules/planning.md`)

- [ ] File exists
- [ ] `generated_at` (from `hypr-meta`)
- [ ] Number of rules (count `rule` blocks)
- [ ] Key patterns covered

**Frontend** (`.claude/rules/frontend.md`)

- [ ] File exists
- [ ] `generated_at` (from `hypr-meta`)
- [ ] Number of rules (count `rule` blocks)
- [ ] Key patterns covered

**Backend** (`.claude/rules/backend.md`)

- [ ] File exists
- [ ] `generated_at` (from `hypr-meta`)
- [ ] Number of rules (count `rule` blocks)
- [ ] Key patterns covered

#### Legacy agents (pre-modernization)

For each domain where `.claude/rules/{type}.md` is **missing**, also check for a
legacy `.claude/agents/{type}-agent.md` (the old combined format). If one
exists, do **not** report the rule set as a clean "Missing → run assessment" —
report it as **"Legacy (N rules) — migrate with `/hypr:refresh {type}`"** so the
user knows there are existing rules to carry over. (These legacy files are NOT
the optional agents in §3; they're superseded Hypr rule files.)

### 3. Optional Agents

Check for any additional agents installed from the registry (agents that are NOT planning-agent, frontend-agent, or backend-agent):

Look for other `.md` files in `.claude/agents/` such as:

- `accessibility-analyzer.md`
- `testing-agent.md`
- `security-scanner.md`
- Any other installed agents

For each optional agent found:

- [ ] File name
- [ ] Description (from frontmatter)
- [ ] Installed (present in `.claude/agents/`) — optional agents have no `hypr-meta`, so report presence only, not a mtime-derived "age"

### 4. Installed Skills

Scan `.claude/skills/` for subdirectories containing a `SKILL.md` file.

For each skill found:

- [ ] Skill name (subdirectory name)
- [ ] Description (from SKILL.md frontmatter)
- [ ] Invocation mode: "User + Automatic" (default), "User only" (if `disable-model-invocation: true`), or "Automatic only" (if `user-invocable: false`)
- [ ] Installed (present in `.claude/skills/`) — no `hypr-meta`, so report presence only, not a mtime-derived "age"

### 5. Feature Documents

List all feature documents in `features/`:

- File name
- Feature title
- Status (if trackable)
- Chunks completed vs total

### 6. Freshness Health

For each existing rule set, compute staleness from provenance using the
**Freshness** algorithm in `docs/rules-format.md` (do NOT use file mtime):

- **Commits behind** — `git rev-list --count <base_commit>..HEAD` (read
  `base_commit` from the file's `hypr-meta`).
- **In-scope changes** — count of files changed since `base_commit` that match
  the rule set's `paths:`/`scope` globs.
- **Likely-stale rules** — rules whose `example:` source file was modified,
  renamed, or deleted since `base_commit`.
- If `base_commit` is unreachable (the ancestor guard fails), report
  "freshness unknown — full refresh recommended".
- Recommend `/hypr:refresh <type>` when there are likely-stale rules, or when
  in-scope changes are a large share of the domain's files.

## Output Format

```markdown
## Hypr Status Report

### Setup Status
- [x] .claude/ directory exists
- [x] .claude/rules/ directory exists
- [x] AGENTS.md / CLAUDE.md exist
- [x] .claude/skills/ directory exists
- [x] features/ directory exists

### Rule Sets

| Domain | Status | Rules | Generated | Behind | Likely-stale | Health |
|--------|--------|-------|-----------|--------|--------------|--------|
| Planning | Ready | 28 | 2026-06-10 | 4 commits | 0 | Fresh |
| Frontend | Ready | 32 | 2026-05-02 | 87 commits | 5 | Refresh recommended |
| Backend | Missing | - | - | - | - | Run assessment |

### Optional Agents

| Agent | Description | Installed |
|-------|-------------|-----------|
| accessibility-analyzer | WCAG 2.1 analysis | 2024-01-20 |

Run `/hypr:list` to see more available agents.

### Installed Skills

| Skill | Description | Invocation | Installed |
|-------|-------------|------------|-----------|
| db-migrate | Database migration helper | User + Automatic | 2024-01-22 |
| code-review | Automated code review | User only | 2024-01-25 |

Run `/hypr:list skills` to see more available skills.

### Feature Documents

| Feature | Status | Progress |
|---------|--------|----------|
| feature-001-auth.md | In Progress | 3/5 chunks |
| feature-002-dashboard.md | Complete | 4/4 chunks |

### Recommendations

1. [Any recommended actions]
2. [Refresh suggestions if agents are stale]
```

## Quick Actions

Based on status, suggest next actions:

**If no setup:**

```
Run /hypr:assess to set up Hypr for this project
```

**If missing agents:**

```
Run /hypr:assess-[type] to generate the missing agent
```

**If a rule set is stale (likely-stale rules, or many in-scope changes since `base_commit`):**

```
Run /hypr:refresh [type] to update the rule set
```

**If no skills installed:**

```
Run /hypr:list skills to discover and install available skills
```

**If everything is ready:**

```
Ready to use!
- /hypr:plan [feature] - Plan a new feature
- /hypr:implement [chunk] - Implement a chunk
- /hypr:validate [type] - Validate an agent
- /hypr:list - Discover optional agents and skills to install
```

## Example Output

```
Hypr Status for: my-project

Setup: Complete

Rule Sets:
  Planning: Ready (28 rules, 4 commits behind, fresh)
  Frontend: Ready (32 rules, 87 commits behind, 5 likely-stale — refresh recommended)
  Backend: Not configured

Optional Agents:
  accessibility-analyzer: Installed

Installed Skills:
  db-migrate: User + Automatic
  code-review: User only

Features:
  - feature-001-auth: 3/5 chunks complete
  - feature-002-dashboard: Complete

Recommendations:
  - Run /hypr:assess-backend to complete setup
  - Run /hypr:list to discover more agents and skills
```
