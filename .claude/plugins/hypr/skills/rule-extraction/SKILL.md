---
name: rule-extraction
description: Extracts concrete, actionable rules from discovered patterns. Converts observations into guidelines that AI agents can follow precisely.
user-invocable: false
---

# Rule Extraction

This skill converts pattern observations into concrete, actionable rules that AI agents can follow to produce code consistent with project conventions.

## When This Skill Activates

This skill is automatically invoked when:

- Converting pattern discoveries into agent rules
- Writing rules to agent files during assessment
- Refining existing rules for clarity
- Ensuring rules are specific enough to follow

## Extraction Process

### Step 1: Gather Observations

Start with raw observations:

- "Most components use arrow functions"
- "Files are in folders named after features"
- "Tests have a describe-it structure"

### Step 2: Add Specificity

Make observations concrete:

- "Most components" → "All 15 components examined"
- "arrow functions" → "const ComponentName: React.FC<Props> = () => {}"
- "named after features" → "src/features/[feature-name]/components/"

### Step 3: Include Examples

Add real examples from the codebase:

- File paths: `src/features/auth/components/LoginForm.tsx`
- Code snippets: `const LoginForm: React.FC<LoginFormProps> = ({ onSubmit }) => {`
- Pattern variations: "except for page components which use default exports"

### Step 4: Make Actionable

Convert to imperative form:

- "Components use..." → "Create components using..."
- "Files are organized..." → "Place files in..."
- "Tests follow..." → "Write tests following..."

### Step 5: Address Edge Cases

Document when rules vary:

- "Use arrow functions for components, except class components for error boundaries"
- "Place in features/ folder, except shared utilities go in src/lib/"

### Step 6: Order by Importance

Prioritize rules:

1. Naming conventions (most visible)
2. File organization (structural)
3. Code structure (implementation)
4. Testing patterns (validation)
5. Documentation (supporting)

## Rule Quality Checklist

Each rule must pass these checks:

- [ ] **Specific**: Contains actual file paths or code examples
- [ ] **Observable**: Based on evidence from multiple files
- [ ] **Actionable**: Clear enough to follow without interpretation
- [ ] **Testable**: Can verify if new code follows the rule
- [ ] **Current**: Reflects latest conventions (not legacy code)
- [ ] **Atomic**: States exactly one convention. If a block bundles several
      independent conventions (e.g. quoting + import-type + build command), split
      it into one block each so every rule can carry its own `severity` and `check`.

## Rule Block Format

Emit each rule as a fenced `rule` block with all six fields, in this exact
order. **Never emit a flat numbered list** — every rule is a `rule` block. The
full contract is in `docs/rules-format.md`.

```rule
id: FE-001
severity: error
scope: src/components/**/*.tsx
statement: Name components using PascalCase matching their function (e.g. UserProfileCard, LoginForm, DashboardHeader).
example: src/components/UserProfileCard.tsx:12
check:
```

How the quality checklist above maps onto the fields:

- **Specific / Observable** → a concrete `statement` plus an `example` of `path:line` where the pattern was observed.
- **Actionable** → `statement` written as an imperative.
- The pattern's blast radius → `scope`, a single glob (use `**/*` only if it truly applies everywhere).
- How strongly the convention holds → `severity`: exactly one of `error`
  (structural / must), `warn` (should), or `info` (preference). Write these three
  tokens **verbatim** — never `warning`, `warns`, or any synonym.
- `check:` is left **empty** — it is reserved for a later enforcement step.

`id` uses the domain prefix (`BE-`/`FE-`/`PL-`/`A11Y-`) + a zero-padded 3-digit
number, assigned sequentially and never renumbered.

> **During a parallel assessment, do not assign IDs or write provenance.**
> Assessor workers emit every block with the literal `id: PENDING`, writing them
> to their assigned fragment file (`.claude/.hypr-parts/<domain>-<cluster>.md`) —
> never to the rule file itself, and never only inline in their final message.
> The orchestrator assigns sequential IDs and writes the `hypr-meta` header
> centrally at synthesis (see "Parallel generation" in `docs/rules-format.md`).
> The ID and provenance guidance below applies when you are writing rules
> directly (e.g. a manual edit or a `/hypr:refresh` that owns the file), not
> inside an assessor worker.

### Provenance header

When you own the file (not as a parallel worker), open each rules section with
one `hypr-meta` block. Capture the values by running `git rev-parse HEAD`,
`date +%Y-%m-%d`, and (best effort) reading `version` from the plugin's
`plugin.json`. Set `next_id` to one past the highest ID you assign; it is the ID
high-water mark so removed IDs are never reused (see the Freshness section of
`docs/rules-format.md`):

```hypr-meta
domain: frontend
base_commit: <sha from git rev-parse HEAD>
generated_at: <date from date +%Y-%m-%d>
plugin_version: <version, or unknown if ${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json can't be resolved>
next_id: <one past the highest id assigned>
```

### Good vs bad statements

```
// TOO VAGUE
Bad:  statement: Use good naming conventions
Good: statement: Name functions using camelCase verbs describing their action (e.g. fetchUserData, handleSubmit, validateForm)

// NO EXAMPLE PROVENANCE
Bad:  (omitting the example: line)
Good: example: src/features/auth/__tests__/login.test.ts:8

// NOT ACTIONABLE
Bad:  statement: Components should be organized properly
Good: statement: Place page components in src/pages/[PageName]/index.tsx and feature components in src/features/[feature]/components/
```

## Output Verification

After extracting rules, verify:

1. **Coverage**: All major patterns have rules
2. **Consistency**: Rules don't contradict each other
3. **Completeness**: Rules cover the full workflow (naming → organizing → implementing → testing)
4. **Clarity**: Another AI could follow these rules without additional context
