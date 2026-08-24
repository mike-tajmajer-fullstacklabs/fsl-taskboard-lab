---
name: list
description: List available agents and skills from the Hypr directory
argument-hint: [agents | skills | category | name]
disable-model-invocation: true
---

# List Available Agents & Skills

Browse the official Hypr directory to discover agents and skills you can install.

## Step 1: Fetch the Directory

Fetch the directory index using one of these methods (in order):

### Option A: Using `gh` CLI (supports private repos)

```bash
gh api /repos/FullStack-Engineering/agent-directory/contents/registry.json --jq '.content' | base64 -d
```

### Option B: Using raw URL (public repos only)

```
https://raw.githubusercontent.com/FullStack-Engineering/agent-directory/main/registry.json
```

Try `gh` CLI first. If it fails (not installed or not authenticated), fall back to the raw URL.

## Step 2: Check Installed Agents & Skills

Scan the local project to determine which agents and skills are already installed.

### Agents

Read the list of files in `.claude/agents/` to determine which agents are already installed.

An agent is considered installed if a file exists matching the agent name:

- `accessibility-analyzer` is installed if `.claude/agents/accessibility-analyzer.md` exists

### Skills

Read the list of subdirectories in `.claude/skills/` to determine which skills are already installed.

A skill is considered installed if a subdirectory exists containing a `SKILL.md` file:

- `commit` is installed if `.claude/skills/commit/SKILL.md` exists

## Step 3: Parse Arguments for Type Filtering

Determine what to display based on `$ARGUMENTS`:

| Invocation | Behavior |
|---|---|
| `/hypr:list` | Show all agents and skills |
| `/hypr:list agents` | Show only agents |
| `/hypr:list skills` | Show only skills |
| `/hypr:list {category}` | Filter both agents and skills by category |
| `/hypr:list {name}` | Show detail view for a specific agent or skill |

Resolution order:

1. If `$ARGUMENTS` is empty, show all.
2. If `$ARGUMENTS` is exactly `agents` or `skills`, filter by type.
3. If `$ARGUMENTS` matches a known category name, filter both types by that category.
4. If `$ARGUMENTS` matches a known agent or skill name, show the detail view.
5. Otherwise, show an error: `No agent, skill, or category matching "{name}" found.`

## Step 4: Display Available Agents & Skills

Format the output as a combined table with a **Type** column, sorted by category then name:

```
Available Agents & Skills from Hypr Directory

| Name                   | Type  | Category | Description                                    | Status    |
|------------------------|-------|----------|------------------------------------------------|-----------|
| accessibility-analyzer | Agent | quality  | WCAG 2.1 accessibility analysis and reporting  | Installed |
| testing-agent          | Agent | quality  | Generate comprehensive test suites             | Available |
| commit                 | Skill | tooling  | Guided commit workflow with conventional style | Installed |
| security-scanner       | Agent | security | Scan code for security vulnerabilities         | Available |
| migration-agent        | Agent | tooling  | Help migrate between frameworks                | Available |

To install an agent or skill:
  /hypr:add {name}

Example:
  /hypr:add testing-agent
```

When filtered by type (`/hypr:list agents` or `/hypr:list skills`), the Type column may be omitted since all rows share the same type.

## Step 5: Show Details (if requested)

If `$ARGUMENTS` matches a specific agent or skill name in the directory, show detailed info.

### Agent Detail

```
accessibility-analyzer

  Type:        Agent
  Description: Analyzes code against WCAG 2.1 criteria and assigns conformance levels
  Category:    quality
  Tags:        a11y, wcag, accessibility, audit
  Status:      Installed

  Install: /hypr:add accessibility-analyzer
```

### Skill Detail

For skills, show the **Invocation** mode only when the registry entry provides
it (it is optional advisory metadata):

```
commit

  Type:        Skill
  Description: Guided commit workflow with conventional commit style
  Category:    tooling
  Tags:        git, commit, conventional
  Invocation:  User only
  Status:      Installed

  Install: /hypr:add commit
```

Claude Code honors these invocation modes for skills:

- `User + Automatic` (default) - usable via slash command and auto-invoked by Claude
- `User only` - slash command only, when the skill sets `disable-model-invocation: true`
- `Automatic only` - Claude-invoked and hidden from the `/` menu, when the skill sets `user-invocable: false`

Registry entries carry an optional `invocation` field; translate it as:

- `"both"` → `User + Automatic`
- `"user"` → `User only`
- `"automatic"` → `Automatic only`

If the registry entry omits invocation metadata, default to `User + Automatic`.

## Directory Format

The registry.json file has this structure (v1.1.0):

```json
{
  "version": "1.1.0",
  "agents": [
    {
      "name": "accessibility-analyzer",
      "description": "Analyzes code against WCAG 2.1 criteria and assigns conformance levels",
      "category": "quality",
      "tags": ["a11y", "wcag", "accessibility", "audit"]
    }
  ],
  "skills": [
    {
      "name": "commit",
      "description": "Guided commit workflow with conventional commit style",
      "category": "tooling",
      "tags": ["git", "commit", "conventional"],
      "invocation": "user"
    }
  ]
}
```

### Backward Compatibility

If the registry does not contain a `skills` array (v1.0.0 registries), treat it as an empty array and proceed normally. Only agents will be displayed in this case.

## Categories

Common categories include:

- `quality` - Code quality, testing, accessibility
- `security` - Security scanning and analysis
- `tooling` - Development tools, migrations, refactoring
- `documentation` - Doc generation and maintenance

## Error Handling

### Directory unavailable (public access)

```
Could not fetch the Hypr directory.

Please check your internet connection and try again.

URL: https://raw.githubusercontent.com/FullStack-Engineering/agent-directory/main/registry.json
```

### Directory unavailable (private repo)

```
Could not access the directory.

If the directory is in a private repository, make sure you're authenticated:
  gh auth status

If not logged in, run:
  gh auth login
```

### No agents or skills found

```
The Hypr directory is empty or could not be parsed.

This may be a temporary issue. Please try again later.
```

### No match for argument

```
No agent, skill, or category matching "{name}" found.

Run /hypr:list to see all available agents and skills.
```

## Related Commands

- `/hypr:add {name}` - Install an agent or skill
- `/hypr:status` - Show installed agents and skills and their status
