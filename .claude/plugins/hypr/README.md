# Hypr

A Claude Code plugin that generates AI agents pre-loaded with your project's patterns.

## Installation

**Option 1: Local directory (recommended)**

```bash
git clone git@github.com:FullStack-Engineering/hypr-framework.git ~/hypr
```

Then in Claude Code:

```
/plugin marketplace add ~/hypr
/plugin install hypr@hypr
```

**Option 2: GitHub (remote)**

In Claude Code:

```
/plugin marketplace add FullStack-Engineering/hypr-framework
/plugin install hypr@hypr
```

**Option 3: Per-session only**

```bash
claude --plugin-dir /path/to/hypr
```

Verify with `/hypr:status`.

---

## Plugin Structure

This plugin requires two files in `.claude-plugin/`:

**plugin.json** - Plugin metadata:

```json
{
  "name": "hypr",
  "description": "...",
  "version": "1.1.0",
  "author": { "name": "..." }
}
```

**marketplace.json** - Registers the plugin:

```json
{
  "name": "hypr",
  "owner": { "name": "..." },
  "plugins": [
    {
      "name": "hypr",
      "source": "./",
      "description": "..."
    }
  ]
}
```

Note: The `source` field must be `"./"` (not `"."`).

To enable permanently, add to `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "hypr@hypr": true
  }
}
```

---

## Updating the Plugin

**For local installations:**

```bash
cd ~/hypr && git pull
```

Then in Claude Code:

```
/plugin marketplace update hypr
```

**For GitHub installations:**

```
/plugin marketplace update hypr
```

Changes take effect after restarting Claude Code.

---

## Example: First-Time Setup

```bash
# 1. Run the assessment wizard
/hypr:assess

# 2. Run assessments for your stack (each runs parallel workers, then one approval)
/hypr:assess-planning     # Analyzes how you plan features
/hypr:assess-frontend     # Analyzes your frontend patterns
/hypr:assess-backend      # Analyzes your backend patterns

# 3. Validate agents are accurate
/hypr:validate all
```

This creates `.claude/rules/` (path-scoped rule sets) plus a portable `AGENTS.md` that capture your project's patterns.

---

## Example: Continuous Feature Development

```bash
# 1. Plan a feature (creates features/feature-xxx.md)
/hypr:plan Add user profile with avatar upload

# 2. Build chunks with automated review cycles
/hypr:build-chunk chunk 1    # Implements → Reviews → Fixes → Repeats until approved
/hypr:build-chunk chunk 2
/hypr:build-chunk chunk 3

# 3. When your codebase evolves, refresh agents
/hypr:refresh frontend
```

---

## Example: Accessibility

```bash
# Install the WCAG 2.1 AA rule set so agents generate accessible code
/hypr:a11y

# Audit existing code and get a conformance rating (A / AA / AAA)
/hypr:a11y-audit src/components/
```

`/hypr:a11y` installs the WCAG rules as a path-scoped rule set
(`.claude/rules/accessibility.md`) with pre-validated ast-grep checks;
`/hypr:a11y-audit` delegates to the bundled `accessibility-analyzer` agent for
an on-demand report.

---

## Example: Installing Optional Agents & Skills

Hypr ships a directory of optional agents and skills you can pull into a project:

```bash
# Browse what's available
/hypr:list

# Install one by name (from the directory), a GitHub repo, a URL, or a local path
/hypr:add accessibility-analyzer
```

---

## Commands

| Command | Description |
|---------|-------------|
| `/hypr:status` | Show setup status and installed rule sets, agents, and skills |
| `/hypr:assess` | Start the assessment wizard |
| `/hypr:assess-planning` | Generate planning agent from your feature patterns |
| `/hypr:assess-frontend` | Generate frontend agent from your component patterns |
| `/hypr:assess-backend` | Generate backend agent from your API patterns |
| `/hypr:plan <feature>` | Create a feature plan with implementation chunks |
| `/hypr:implement <chunk>` | Implement a specific chunk |
| `/hypr:build-chunk <chunk>` | Implement → review → fix cycle until approved |
| `/hypr:review <target>` | Review code against project patterns |
| `/hypr:validate <type>` | Validate agent accuracy (planning/frontend/backend/all) |
| `/hypr:refresh <type>` | Update agent with evolved codebase patterns |
| `/hypr:checks <type>` | Generate + self-validate ast-grep checks for mechanizable rules |
| `/hypr:conformance [target]` | Run the checks and report a conformance pass rate |
| `/hypr:eval [target]` | Measure output quality — conformance pass-rate, indistinguishable-from-existing-code judge, optional rules precision/recall |
| `/hypr:list [type]` | Browse the Hypr directory of optional agents and skills |
| `/hypr:add <name>` | Install an optional agent or skill from the directory or a URL |
| `/hypr:a11y` | Install WCAG 2.1 AA accessibility rules as a path-scoped rule set |
| `/hypr:a11y-audit <target>` | Audit code against WCAG 2.1 and get a conformance rating |

---

## Agents

### Assessment Agents

Assessment is orchestrated by the `/hypr:assess-*` commands, which run a scout to
map the repo, fan out the assessor workers in parallel over aspect clusters, then
run a coverage critic before you approve.

| Agent | Purpose |
|-------|---------|
| `assessment-scout` | Fast first pass — maps the repo and picks sample files per aspect cluster |
| `planning-assessor` | Worker — analyzes an assigned cluster of planning aspects |
| `frontend-assessor` | Worker — analyzes an assigned cluster of frontend aspects |
| `backend-assessor` | Worker — analyzes an assigned cluster of backend aspects |
| `coverage-critic` | Final parity guard — flags coverage gaps, duplicates, and generic rules |

### Execution Agents

| Agent | Purpose |
|-------|---------|
| `feature-planner` | Creates feature plans following your patterns |
| `frontend-executor` | Implements frontend code following your patterns |
| `backend-executor` | Implements backend code following your patterns |
| `code-reviewer` | Review-panel worker — reviews through one lens (conformance / criteria / correctness / tests) with confidence-scored findings |
| `review-verifier` | Adversarially verifies each finding (confirmed / refuted / uncertain) to cut false positives |
| `output-judge` | Eval judge — scores generated files 1–5 on how indistinguishable they are from real sibling files |

### Quality Agents

| Agent | Purpose |
|-------|---------|
| `accessibility-analyzer` | Audits code against WCAG 2.1 and assigns a conformance level (A/AA/AAA) |

---

## Skills

| Skill | Purpose |
|-------|---------|
| `pattern-discovery` | Discovers patterns by analyzing similar files |
| `rule-extraction` | Converts discovered patterns to structured rule blocks |
| `chunk-breakdown` | Breaks features into implementable chunks |
| `pattern-validation` | Validates code matches project patterns |
| `check-authoring` | Drafts + self-validates ast-grep checks for structural rules |

Generated rules use a structured, provenance-bearing block format — see [docs/rules-format.md](docs/rules-format.md) for the schema and location contract. For how output quality is measured and how corrections flow back into the rules, see [docs/evals.md](docs/evals.md).

---

## Enforceability

The structural subset of your rules is backed by deterministic [ast-grep](https://ast-grep.github.io) checks, so conformance is measured rather than re-derived:

1. `/hypr:checks <type>` drafts an ast-grep rule for each mechanizable rule, **self-validates it** (a check that won't validate is dropped), writes it to `.claude/rules/checks/<id>.yml` (matching the rule's `id`), and sets `check: ast-grep` on the block.
2. The PostToolUse hook runs the applicable checks on edited files when ast-grep is installed (otherwise it just reminds).
3. `/hypr:conformance` runs all checks and reports a pass rate (e.g. "Backend: 18/22 mechanized rules pass").
4. CI (`.github/workflows/hypr-conformance.yml`, offered by `/hypr:checks`) runs `ast-grep scan -c sgconfig.yml`; `error`-severity violations fail the PR.

**Dependency:** ast-grep — `npx @ast-grep/cli` (Node), or `brew install ast-grep` / `cargo install ast-grep --locked` / `pip install ast-grep-cli`. Every path degrades safely when it's absent. The accessibility rule set ships with pre-validated checks (`/hypr:a11y`), so enforcement works out of the box for those rules.

---

## Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| PostToolUse | Write/Edit | Runs your ast-grep checks on the edited file (if ast-grep is installed) and reports violations; otherwise reminds you to validate against `.claude/rules/`. Silent if no rules exist. |

---

## Project Structure

After setup:

```
your-project/
├── AGENTS.md                 # portable overview + rule index (read by any agent/tool)
├── CLAUDE.md                 # @AGENTS.md (so Claude consumes it)
├── .claude/
│   └── rules/                # path-scoped rule sets (loaded only when relevant)
│       ├── planning.md        # from /hypr:assess-planning
│       ├── frontend.md        # from /hypr:assess-frontend
│       ├── backend.md         # from /hypr:assess-backend
│       └── accessibility.md   # optional, from /hypr:a11y
├── features/
│   └── feature-001-*.md
└── ... your code
```

Detailed rules live in `.claude/rules/*.md`, each with a `paths:` glob so Claude
loads a set only when you edit a matching file. `AGENTS.md` is a slim, portable
overview for humans and other tools. See `docs/rules-format.md`.

---

## Requirements

- Claude Code CLI v2.1.0+ (skills-in-plugins support)
- Existing codebase with established patterns

## License

MIT
