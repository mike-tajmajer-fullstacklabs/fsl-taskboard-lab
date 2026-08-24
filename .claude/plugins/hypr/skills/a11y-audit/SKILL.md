---
name: a11y-audit
description: Analyze code against WCAG 2.1 criteria and get a conformance level rating (A, AA, or AAA)
argument-hint: [target] [level:a|aa|aaa]
disable-model-invocation: true
---

# Accessibility Audit

Analyze your code against WCAG 2.1 success criteria and receive a conformance level rating.

## Usage

```
/hypr:a11y-audit [target]
```

### Arguments

`$ARGUMENTS` can be:

- **File path** - Analyze a specific component: `/hypr:a11y-audit src/components/LoginForm.tsx`
- **Directory** - Analyze all files in a directory: `/hypr:a11y-audit src/components/`
- **Feature name** - Analyze files related to a feature: `/hypr:a11y-audit "checkout flow"`
- **Empty** - Interactive mode, will ask what to analyze

### Options

Add these keywords to customize:

- `level:aa` - Only check up to Level AA (default)
- `level:aaa` - Include Level AAA criteria
- `level:a` - Only check Level A criteria
- `verbose` - Include passed criteria in report
- `quick` - Summary only, no detailed violations

## Run the Audit

Use the **accessibility-analyzer** agent to perform this audit. Pass it the
resolved target (from `$ARGUMENTS`) and the chosen conformance level, and have
it return its report.

The agent will:

1. Read all relevant code files
2. Evaluate against WCAG 2.1 success criteria
3. Document each violation with file:line references
4. Assign an overall conformance level
5. Provide fix recommendations

## Output

### Conformance Levels

| Level | Meaning | Requirement |
|-------|---------|-------------|
| **Does Not Conform** | Failed Level A criteria | Fix critical barriers |
| **Level A** | Minimum accessibility | Passed all 30 Level A criteria |
| **Level AA** | Legal standard | Passed all 50 Level A + AA criteria |
| **Level AAA** | Maximum accessibility | Passed all 78 criteria |

### Report Sections

1. **Score Summary** - Pass/fail counts per level
2. **Violations** - Each failure with severity, location, and fix
3. **Recommendations** - Prioritized action items

## Integration with Development Workflow

### During Development

Run analysis on components as you build them:

```
/hypr:a11y-audit src/components/NewFeature.tsx
```

### Before PR

Run analysis on all changed files:

```
/hypr:a11y-audit src/features/checkout/
```

### CI/CD Integration

The analysis report can inform automated checks:

- Fail PR if "Does Not Conform"
- Warn if below Level AA
- Track accessibility score over time

## Criteria Reference

The analyzer checks against:

### Level A (30 criteria)

Core accessibility - removes severe barriers:

- Alt text on images
- Keyboard accessibility
- Form labels
- Semantic HTML
- No keyboard traps
- Page titles
- Focus order

### Level AA (20 criteria)

Legal standard - addresses major barriers:

- Color contrast (4.5:1)
- Resize to 200%
- Focus visible
- Error suggestions
- Status messages (aria-live)
- Target size (24x24px)

### Level AAA (28 criteria)

Maximum accessibility (not legally required):

- Enhanced contrast (7:1)
- No timing constraints
- Sign language for video
- Reading level considerations
- Target size (44x44px)

## Limitations

Some criteria require manual verification:

- Actual color contrast values
- Content at 200% zoom
- Complex focus order scenarios
- Media accessibility (captions quality)

These are flagged as "Requires Manual Verification" in the report.

## Related Commands

- `/hypr:a11y` - Add WCAG rules to your agents
- `/hypr:review` - Code review including accessibility checks
