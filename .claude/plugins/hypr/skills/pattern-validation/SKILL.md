---
name: pattern-validation
description: Validates that generated code matches established project patterns. Used during implementation to ensure consistency.
user-invocable: false
---

# Pattern Validation

This skill validates that generated code matches established project patterns from the agent files. It ensures code quality and consistency before marking work as complete.

## When This Skill Activates

This skill is automatically invoked when:

- Completing a file during implementation
- Verifying pattern match in Step 4 of implementation loops
- Reviewing code for consistency
- Validating agent rules are being followed

## Validation Process

### Step 1: Load Pattern Rules

Read the relevant agent file:

- `.claude/rules/frontend.md` for frontend code
- `.claude/rules/backend.md` for backend code
- `.claude/rules/planning.md` for feature plans

### Step 2: Identify Applicable Rules

Determine which rules apply to this file type:

- Naming rules
- Organization rules
- Structure rules
- Import rules
- Testing rules

### Step 3: Check Each Rule

For each applicable rule, verify:

- Does the new code follow this rule?
- Are there any deviations?
- Are deviations justified?

### Step 4: Compare to Similar Files

Find 2-3 existing files of the same type:

- Does new code match their structure?
- Does new code use same patterns?
- Are there unexplained differences?

### Step 5: Report Findings

Document validation results:

- Rules followed correctly
- Rules violated (with specifics)
- Suggested fixes

## Validation Checklist

### Naming Conventions

- [ ] File name matches project convention
- [ ] Component/function names follow pattern
- [ ] Variable names are consistent
- [ ] Type/interface names follow convention

### File Organization

- [ ] File is in correct directory
- [ ] File structure matches similar files
- [ ] Sections are in expected order

### Import Patterns

- [ ] Imports are in correct order
- [ ] Import paths follow convention
- [ ] No unused imports
- [ ] Correct use of relative vs absolute imports

### Code Structure

- [ ] Function/component structure matches pattern
- [ ] Props/parameters follow convention
- [ ] Return types are correct
- [ ] Error handling matches pattern

### Testing (if applicable)

- [ ] Test file exists and is named correctly
- [ ] Test structure matches project pattern
- [ ] Coverage meets project standards

## Validation Report Format

```markdown
## Pattern Validation Report

**File:** [path/to/file.ts]
**Type:** [Component/Service/etc.]
**Agent:** [.claude/rules/frontend.md/.claude/rules/backend.md]

### Rules Checked: X

### Passed
- [rule id, e.g. BE-001]: [statement] [checkmark]
- [rule id, e.g. BE-002]: [statement] [checkmark]

### Failed
- [rule id, e.g. BE-003]: [statement]
  - **Expected:** [What the rule says]
  - **Actual:** [What the code does]
  - **Fix:** [How to correct]

### Comparison to Similar Files
- Compared to: [file1.ts, file2.ts, file3.ts]
- Consistency: [High/Medium/Low]
- Notable differences: [Any unexplained differences]

### Overall Status: [PASS/FAIL]
```

## Common Validation Failures

### Naming Issues

```
Rule: "Name components using PascalCase"
Found: "const loginform"
Fix: Rename to "const LoginForm"
```

### Structure Issues

```
Rule: "Define props interface above component"
Found: Props interface defined inline
Fix: Extract to named interface above component
```

### Import Issues

```
Rule: "Order imports: React, external, internal, relative"
Found: Relative imports mixed with external
Fix: Reorder imports following convention
```

### Organization Issues

```
Rule: "Place components in src/features/[feature]/components/"
Found: Component in src/components/ but is feature-specific
Fix: Move to appropriate feature folder
```

## Automated Checks

Where possible, use tooling:

- **TypeScript**: Run type check on file
- **ESLint**: Run linter on file
- **Prettier**: Check formatting
- **Tests**: Run relevant test suite

Report all tool outputs in validation results.

## Resolution

After validation:

**If PASS:**

- Mark step as complete
- Proceed to next step in implementation loop

**If FAIL:**

- List all issues found
- Apply fixes before proceeding
- Re-validate after fixes
- Only proceed when all rules pass
