---
name: add
description: Install an optional agent or skill from the Hypr directory or a custom URL
argument-hint: <name | user/repo | url | path>
disable-model-invocation: true
---

# Add Agent or Skill

Install an optional agent or skill to extend Hypr's capabilities. Both can be installed from:

- The official Hypr directory (agents and skills)
- A GitHub repository (public or private via `gh` CLI)
- A direct URL
- A local file path

## Prerequisites

Before installing, check:

1. `.claude/` directory exists (run `/hypr:assess` first if not)
2. `.claude/agents/` directory exists (for agents)
3. `.claude/skills/` directory exists (for skills)

If directories don't exist, create them.

## Step 1: Parse the Source

From `$ARGUMENTS`, determine the source type:

### Official Directory (Agent or Skill)

If the argument is a simple name (no slashes, no URL):

```
accessibility-analyzer
testing-agent
chunk-breakdown
pattern-discovery
```

Look up the name in the registry:

1. **Fetch `registry.json`** using `gh` CLI first, falling back to raw URL:

   ```bash
   gh api /repos/FullStack-Engineering/agent-directory/contents/registry.json --jq '.content' | base64 -d
   ```

   Fallback:

   ```
   https://raw.githubusercontent.com/FullStack-Engineering/agent-directory/main/registry.json
   ```

2. **Search both arrays** in the registry:
   - Check `agents` array for a matching `name`
   - Check `skills` array for a matching `name` (treat as empty array if missing)

3. **Resolve the URL** based on where the match was found:
   - If found in `agents`:

     ```
     https://raw.githubusercontent.com/FullStack-Engineering/agent-directory/main/agents/{name}/AGENT.md
     ```

   - If found in `skills`:

     ```
     https://raw.githubusercontent.com/FullStack-Engineering/agent-directory/main/skills/{name}/SKILL.md
     ```

   - If **not found in registry** (or registry fetch fails): try the agent URL first, then fall back to the skill URL if the agent URL fails

### GitHub Shorthand

If the argument contains exactly one slash (user/repo format):

```
someuser/my-agent
company/custom-skill
```

Resolve to:

```
https://raw.githubusercontent.com/{user}/{repo}/main/AGENT.md
```

If AGENT.md is not found, fall back to:

```
https://raw.githubusercontent.com/{user}/{repo}/main/SKILL.md
```

If the argument has a colon after the repo (user/repo:path):

```
someuser/agents:security-scanner
someuser/skills:chunk-breakdown
```

Resolve to:

```
https://raw.githubusercontent.com/{user}/{repo}/main/{path}/AGENT.md
```

If AGENT.md is not found, fall back to:

```
https://raw.githubusercontent.com/{user}/{repo}/main/{path}/SKILL.md
```

### Direct URL

If the argument starts with `http://` or `https://`:

```
https://raw.githubusercontent.com/example/repo/main/my-agent/AGENT.md
https://raw.githubusercontent.com/example/repo/main/my-skill/SKILL.md
https://gist.githubusercontent.com/.../SKILL.md
```

Use the URL directly.

### Local Path

If the argument starts with `/`, `./`, `../`, or `~`:

```
/path/to/agents/my-agent
~/my-skills/custom-skill
./local-agents/security-scanner
```

Read directly from the local filesystem. Look for:

1. `{path}/AGENT.md` if path is a directory
2. `{path}/SKILL.md` if `AGENT.md` not found and path is a directory
3. `{path}` directly if path ends in `.md`

## Step 2: Fetch the Content

### For Local Paths

Read the file directly using the Read tool. No network request needed.

### For GitHub Sources (directory or shorthand)

Try fetching in this order:

1. **Try `gh` CLI first** (supports private repos):

   ```bash
   gh api /repos/{owner}/{repo}/contents/{path}/AGENT.md --jq '.content' | base64 -d
   ```

   For the official directory (agents):

   ```bash
   gh api /repos/FullStack-Engineering/agent-directory/contents/agents/{name}/AGENT.md --jq '.content' | base64 -d
   ```

   For the official directory (skills):

   ```bash
   gh api /repos/FullStack-Engineering/agent-directory/contents/skills/{name}/SKILL.md --jq '.content' | base64 -d
   ```

2. **Fall back to raw URL** (public repos only):

   ```
   https://raw.githubusercontent.com/{owner}/{repo}/main/{path}/AGENT.md
   ```

   or

   ```
   https://raw.githubusercontent.com/{owner}/{repo}/main/{path}/SKILL.md
   ```

### For Direct URLs

Use WebFetch to retrieve the content.

### If fetch fails

- For directory items: suggest running `/hypr:list` to see available agents and skills
- For GitHub shorthand: verify the repository and path exist, or check if `gh` is authenticated
- For private repos: ensure `gh auth status` shows you're logged in
- For URLs: verify the URL is correct and accessible
- For local paths: verify the file exists

## Step 3: Detect Type

Determine whether the fetched content is an **agent** or a **skill** using the following precedence:

### 1. Registry Lookup

If the name was found in the registry `agents` array, it's an agent. If found in the `skills` array, it's a skill.

### 2. Source Filename

- Filename is `AGENT.md` → agent
- Filename is `SKILL.md` → skill

### 3. Frontmatter Fields

Agents and skills both use `name` + `description`, so use these only as a hint
when the registry lookup and source filename are unavailable:

- Contains `invocation`, `user-invocable`, or `disable-model-invocation` → **skill**
  (`user-invocable`/`disable-model-invocation` are skill-only fields; `invocation`
  is a legacy directory field still shipped by older skill sources — strip it on
  install, but treat it as a skill signal)
- Contains `tools:` → **agent** (agents use `tools:`; skills use `allowed-tools:`)

### 4. Fallback

If none of the above apply, default to **agent**.

## Step 4: Validate the Content

### Agent Validation

The fetched content must be a valid agent file:

1. **Has YAML frontmatter** - Starts with `---` and has a closing `---`
2. **Has description** - The frontmatter includes a `description` field
3. **Has content** - There is markdown content after the frontmatter

The current Claude Code schema also requires a `name` field. If the source omits
it, do not reject the install — derive the name (Step 5) and inject it into the
frontmatter at install time (Step 7) so the agent registers with a clean id.

### Skill Validation

The fetched content must be a valid skill file:

1. **Has YAML frontmatter** - Starts with `---` and has a closing `---`
2. **Has name** - The frontmatter includes a `name` field
3. **Has description** - The frontmatter includes a `description` field
4. **Has content** - There is markdown content after the frontmatter

If validation fails, report what's wrong and do not install.

## Step 5: Determine the Name

Extract the name in this order of preference:

1. From frontmatter `name` field if present
2. From the URL path - the directory name before `AGENT.md` or `SKILL.md`
3. If unclear, ask the user what to name it

The name determines the install path:

- **Agent**: `.claude/agents/{name}.md`
- **Skill**: `.claude/skills/{name}/SKILL.md`

## Step 6: Check for Existing Installation

### For Agents

If `.claude/agents/{name}.md` already exists, ask the user if they want to:

- **Overwrite** - Replace the existing agent
- **Rename** - Save with a different name
- **Cancel** - Abort the installation

### For Skills

If `.claude/skills/{name}/SKILL.md` already exists, ask the user if they want to:

- **Overwrite** - Replace the existing skill
- **Rename** - Save with a different name
- **Cancel** - Abort the installation

### Name Collision

If the name matches both an existing agent and an existing skill (e.g., installing a skill named `security-scanner` when an agent with that name exists), inform the user and ask them to confirm or choose a different name to avoid confusion.

## Step 7: Install

### Agent Installation

1. If the agent frontmatter has no `name:` field, insert `name: {name}` (the
   name resolved in Step 5) as the first frontmatter line. Claude Code derives
   agent identity from `name`, so without it the agent registers with a
   path-derived id like `hypr:{name}:AGENT`.
2. Write the agent content to `.claude/agents/{name}.md`

### Skill Installation

1. Create the directory `.claude/skills/{name}/` if it doesn't exist
2. Write the skill content to `.claude/skills/{name}/SKILL.md`

## Step 8: Report Success

### Agent Success

```
Agent installed successfully!

  Name: {agent-name}
  Location: .claude/agents/{agent-name}.md
  Description: {description from frontmatter}

Next steps:
  - The agent is now available for use
  - Run /hypr:status to see all installed agents and skills
  - Run /hypr:list to discover more agents and skills
```

### Skill Success

Determine the invocation mode from frontmatter:

- If `user-invocable: false` → **Automatic only** (Claude-invoked; hidden from the `/` menu)
- If `disable-model-invocation: true` → **User only** (slash command only)
- Otherwise → **User + Automatic** (default — invokable via slash command and auto-invoked by Claude)

```
Skill installed successfully!

  Name: {skill-name}
  Location: .claude/skills/{skill-name}/SKILL.md
  Description: {description from frontmatter}
  Invocation: {invocation mode}

Next steps:
  - The skill is now available for use
  - Run /hypr:status to see all installed agents and skills
  - Run /hypr:list to discover more agents and skills
```

## Examples

### Install agent from official directory

```
/hypr:add accessibility-analyzer
```

### Install skill from official directory

```
/hypr:add chunk-breakdown
```

### Install from GitHub (public or private)

```
/hypr:add mycompany/custom-agent
/hypr:add mycompany/custom-skill
```

### Install from URL

```
/hypr:add https://raw.githubusercontent.com/someone/repo/main/agents/cool-agent/AGENT.md
/hypr:add https://raw.githubusercontent.com/someone/repo/main/skills/pattern-discovery/SKILL.md
```

### Install from local path

```
/hypr:add ~/agent-directory/agents/accessibility-analyzer
/hypr:add ~/my-skills/chunk-breakdown
/hypr:add ./my-custom-agent/AGENT.md
/hypr:add ./my-custom-skill/SKILL.md
```

## Error Handling

### Agent or skill not found

```
Could not find agent or skill at: {source}

If installing from the directory, run /hypr:list to see available agents and skills.
If installing from GitHub, verify the repository and path exist.
```

### Private repo access denied

```
Could not access private repository.

Make sure you're authenticated with the GitHub CLI:
  gh auth status

If not logged in, run:
  gh auth login
```

### Local file not found

```
Could not find agent or skill at: {path}

Verify the path exists and contains an AGENT.md or SKILL.md file.
```

### Invalid agent file

```
The file at {source} is not a valid agent.

A valid agent file must:
- Start with YAML frontmatter (---)
- Include a name field
- Include a description field
- Have markdown content with agent instructions

See https://github.com/FullStack-Engineering/hypr-framework for the agent file format.
```

### Invalid skill file

```
The file at {source} is not a valid skill.

A valid skill file must:
- Start with YAML frontmatter (---)
- Include a name field
- Include a description field
- Have markdown content with skill instructions

See https://github.com/FullStack-Engineering/hypr-framework for the skill file format.
```

### Network error

```
Could not fetch content from {url}

Please check your internet connection and try again.
```

## Edge Cases

### Registry Fetch Failure

If the registry cannot be fetched, fall back to trying both URLs:

1. Try the agent URL: `agents/{name}/AGENT.md`
2. If that fails, try the skill URL: `skills/{name}/SKILL.md`

### Old Registry Without Skills Array

If the fetched registry.json does not contain a `skills` array, treat it as an empty array and proceed with agent-only lookup.

### Name Collision Between Agent and Skill

If a user installs a skill that has the same name as an already-installed agent (or vice versa), inform them of the existing installation and ask if they want to proceed. Both can coexist since they are stored in different directories.
