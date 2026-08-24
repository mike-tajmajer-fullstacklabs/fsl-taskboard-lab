# Accessibility in Hypr

## What Hypr Provides

### 1. AI Agents That Generate Accessible Code

Hypr's frontend and backend agents can have WCAG rules built in. When you enable accessibility, your agents generate compliant code from the start - using `<button>` instead of `<div>`, including labels on inputs, adding proper ARIA attributes.

```bash
/hypr:a11y  # Adds WCAG rules to your existing agents
```

### 2. AI Agent That Reviews for Issues Tools Miss

Automated tools like axe and Pa11y catch ~60-70% of accessibility issues. The rest require judgment: Is the alt text meaningful? Does the focus order make sense? Are error messages helpful?

Hypr's analyzer reviews code for these judgment-based issues.

```bash
/hypr:a11y-audit src/components/  # Reviews code, assigns WCAG grade
```

---

## Methodology: Keeping Projects Accessible Over Time

For ongoing projects where you want accessibility baked into new features, bug fixes, and changes, we recommend this three-prong approach:

```
+-----------------------------------------------+
|  PRONG 1: Accessible Code Generation          |  <-- Hypr
+-----------------------------------------------+
              |
              v
+-----------------------------------------------+
|  PRONG 2: Automated Testing in CI/CD          |  <-- 3rd party tools
+-----------------------------------------------+
              |
              v
+-----------------------------------------------+
|  PRONG 3: AI Review for Issues Tools Miss     |  <-- Hypr
+-----------------------------------------------+
```

### Prong 1: Generate Accessible Code from the Start

**Why?** Fixing accessibility after the fact costs 10x more than building it right the first time.

**How?** Enable accessibility rules on your Hypr agents. New code follows WCAG standards automatically.

**Tool:** `/hypr:a11y`

### Prong 2: Validate with 3rd Party Tools in CI/CD

**Why?** Even with good intentions, mistakes slip through. Automated tools catch measurable violations on every PR.

**How?** Integrate industry-standard tools into your pipeline.

| Tool | Use Case |
|------|----------|
| [axe-core](https://github.com/dequelabs/axe-core) | Test suite integration |
| [Pa11y](https://pa11y.org/) | CI/CD pipeline |
| [eslint-plugin-jsx-a11y](https://github.com/jsx-eslint/eslint-plugin-jsx-a11y) | Development-time linting |
| [Lighthouse](https://developer.chrome.com/docs/lighthouse/) | Manual audits |

**Example CI/CD integration:**

```yaml
# GitHub Actions
- run: npx pa11y-ci ./pa11y-ci.config.js
- run: npm run test:a11y
```

### Prong 3: Review for Issues Tools Miss

**Why?** 30-40% of accessibility issues require human judgment. Tools can't assess meaning, logic, or cognitive load.

**How?** Use Hypr's analyzer to review code for semantic correctness, focus flow, and whether the implementation actually helps users.

**Tool:** `/hypr:a11y-audit`

---

## Fixing an Existing Inaccessible Codebase

Hypr is designed for keeping projects accessible over time - not for remediating a codebase with hundreds of existing violations.

If you need to fix an existing inaccessible codebase, reach out to us about specialized migration and remediation agents.

---

## Quick Start

```bash
# 1. Add accessibility rules to your agents
/hypr:a11y

# 2. Build features - agents now generate accessible code

# 3. Audit code to find issues
/hypr:a11y-audit src/components/MyComponent.tsx
```

---

## WCAG Conformance Levels

The audit grades code against WCAG 2.1:

| Level | Meaning |
|-------|---------|
| **Does Not Conform** | Failed Level A - critical barriers exist |
| **Level A** | Minimum accessibility (30 criteria) |
| **Level AA** | Legal standard - target this (50 criteria) |
| **Level AAA** | Maximum accessibility (78 criteria) |

See [wcag-reference.md](./wcag-reference.md) for the full criteria list.
