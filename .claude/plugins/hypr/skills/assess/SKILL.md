---
name: assess
description: Start the Hypr assessment wizard to analyze your codebase and generate specialized AI agents
disable-model-invocation: true
---

# Hypr Assessment Wizard

You are starting the Hypr setup process. Guide the user through analyzing their codebase and generating specialized AI agents.

## Step 1: Check Existing Setup

First, check if Hypr is already set up in this project:

1. Check if `.claude/` directory exists
2. Check if `.claude/rules/` directory exists
3. List any existing rule files (`.claude/rules/planning.md`, `.claude/rules/frontend.md`, `.claude/rules/backend.md`) and a root `AGENTS.md`

Report what you find to the user.

## Step 2: Create Directory Structure (if needed)

If `.claude/` doesn't exist, create the following structure:

```
.claude/
├── rules/        # Generated, path-scoped rule sets will go here
└── skills/       # Installed skills (via /hypr:add) will go here
AGENTS.md         # portable overview + index (created by the assessment)
CLAUDE.md         # @AGENTS.md (created by the assessment)
```

Create `.claude/skills/` as well so later `/hypr:add`, `/hypr:list`, and
`/hypr:status` have the expected layout.

## Step 3: Assessment Options

Present the user with assessment options:

**Available Assessments:**

1. **Planning Assessment** (`/hypr:assess-planning`)
   - Analyzes how your project structures and plans features
   - Generates: `.claude/rules/planning.md`
   - Runs a scout + parallel assessor workers, then one approval at the end
   - Use for: Feature planning, architecture decisions

2. **Frontend Assessment** (`/hypr:assess-frontend`)
   - Analyzes your frontend component patterns and conventions
   - Generates: `.claude/rules/frontend.md`
   - Runs a scout + parallel assessor workers, then one approval at the end
   - Use for: Building frontend features

3. **Backend Assessment** (`/hypr:assess-backend`)
   - Analyzes your backend API and service patterns
   - Generates: `.claude/rules/backend.md`
   - Runs a scout + parallel assessor workers, then one approval at the end
   - Use for: Building backend features

4. **Full Assessment** (all three)
   - Runs all three assessments (each is internally parallel)
   - Recommended for new projects

## Step 4: Guide Assessment Selection

Based on what the user provided in $ARGUMENTS:

- If `$ARGUMENTS` is "planning" → suggest running `/hypr:assess-planning`
- If `$ARGUMENTS` is "frontend" → suggest running `/hypr:assess-frontend`
- If `$ARGUMENTS` is "backend" → suggest running `/hypr:assess-backend`
- If `$ARGUMENTS` is "all" or "full" → guide through all three assessments
- If `$ARGUMENTS` is empty → ask which assessment(s) they want to run

## Step 5: Explain the Process

Before starting any assessment, explain:

1. **The assessment analyzes your codebase** - It will read existing files to discover patterns
2. **It runs in parallel** - A fast scout maps the repo, then several assessor workers analyze different aspect clusters at the same time (this is what keeps it fast)
3. **Rules are assembled and de-duplicated** - The orchestrator collects every worker's rules, assigns stable IDs, and writes the rule file
4. **A coverage critic checks quality** - A final pass flags gaps, duplicates, and generic rules before you approve
5. **One approval at the end** - No mid-stream checkpoints; you review the finished rule set once

## Next Steps

After setup, suggest:

- Run the selected assessment command
- Or use `/hypr:status` to check current setup anytime
