---
name: pattern-discovery
description: Discovers implementation patterns by analyzing multiple similar files in a codebase. Automatically invoked when analyzing code to extract conventions.
user-invocable: false
---

# Pattern Discovery

This skill helps discover implementation patterns by analyzing multiple similar files in a codebase. Use this when you need to understand how a project consistently implements certain types of code.

## When This Skill Activates

This skill is automatically invoked when:

- Analyzing files during an assessment
- Looking for patterns before implementing new code
- Comparing files to understand conventions
- Extracting rules for agent files

## Discovery Process

### Step 1: Identify File Type

Determine what type of files to analyze:

- Components (React, Vue, Angular, etc.)
- Services/Controllers
- API endpoints
- Database models
- Test files
- Configuration files

### Step 2: Gather Sample Files

Find 5-10 files of the same type:

- Use glob patterns to find similar files
- Prioritize recently modified files
- Include files from different features/areas
- Exclude generated or third-party files

### Step 3: Analyze Structure

For each file, examine:

- File naming conventions
- Directory placement
- Import organization
- Export patterns
- Internal structure/organization

### Step 4: Identify Commonalities

Compare files to find:

- Consistent naming patterns
- Shared structural elements
- Common import sources
- Repeated code patterns
- Standard function signatures

### Step 5: Note Variations

Also identify:

- Acceptable variations (when pattern differs based on context)
- Deprecated patterns (old files that don't match newer ones)
- Edge cases (special files that break the pattern)

### Step 6: Formulate Rules

Convert observations into actionable rules:

- Be specific (include actual examples)
- Be prescriptive (say what TO do, not what NOT to do)
- Include file path examples
- Note when variations are acceptable

## Output Format

Discovered patterns become `rule` blocks (see `docs/rules-format.md` and the
`rule-extraction` skill for the full field contract). Each pattern carries a
stable `id`, `severity`, `scope` glob, `statement`, an `example` of `path:line`,
and an empty `check`:

```rule
id: FE-001
severity: error
scope: src/components/**/*.tsx
statement: Component names use PascalCase matching their function.
example: src/components/LoginForm.tsx:5
check:
```

## Quality Criteria

Good pattern rules are:

- **Specific**: Reference actual files and code
- **Observable**: Based on evidence in the codebase
- **Actionable**: Clear enough to follow immediately
- **Consistent**: Applies across multiple files
- **Current**: Reflects the latest conventions

## Example Application

When analyzing React components:

1. Look at 5-10 component files
2. Note: All use PascalCase naming
3. Note: All are in `src/components/` or feature folders
4. Note: All use arrow function syntax
5. Note: Props interfaces use `ComponentNameProps` pattern
6. Note: Styled components defined at bottom of file

Results in rule blocks like:

```rule
id: FE-001
severity: error
scope: src/**/*.tsx
statement: Component names use PascalCase (e.g. LoginForm, UserProfile, DashboardCard).
example: src/components/LoginForm.tsx:1
check:
```

```rule
id: FE-002
severity: info
scope: src/**/*.tsx
statement: Components are defined as arrow functions (const ComponentName = () => {}); props interfaces named [ComponentName]Props are defined above the component.
example: src/components/UserProfile.tsx:3
check:
```
