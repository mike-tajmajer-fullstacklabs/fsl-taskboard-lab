---
paths:
  - "src/components/**/*.tsx"
  - "src/**/*.tsx"
---

# Example: `.claude/rules/frontend.md` (Detected from Codebase)

> _Representative excerpt of a generated frontend rule set. A full assessment
> emits 25+ `rule` blocks in the format defined in
> [docs/rules-format.md](../../rules-format.md). The `paths:` frontmatter scopes
> when Claude loads these rules; `check:` is reserved for a later enforcement
> step. The Per-File Implementation Loop behavior is NOT in this file — it lives
> in the Hypr frontend-executor agent._

```hypr-meta
domain: frontend
base_commit: 9f1c2ad7b3e8c4d05a6e1f2b3c4d5e6f7a8b9c0d
generated_at: 2025-09-26
plugin_version: 1.0.0
next_id: 86
```

```rule
id: FE-001
severity: error
scope: src/components/**/*.tsx
statement: Component names use PascalCase and are descriptive of their function (e.g. RemoveItemModal, ProductCardHeader, ReviewInfo).
example: src/components/Modals/RemoveItemModal.tsx:1
check:
```

```rule
id: FE-002
severity: info
scope: src/**/*.tsx
statement: Components are defined as arrow-function constants and exported as default exports.
example: src/components/Modals/RemoveItemModal.tsx:1
check:
```

```rule
id: FE-004
severity: info
scope: src/components/**/*.tsx
statement: UI components define styled components first, then the main component (e.g. PrimaryButton uses styled(Button)).
example: src/components/Button/PrimaryButton.tsx:1
check:
```

```rule
id: FE-005
severity: warn
scope: src/**/*.tsx
statement: TypeScript props interfaces are named with the component name + "Props" suffix (e.g. ReviewInfoProps).
example: src/features/UserDetail/Reviews/ReviewInfo.tsx:1
check:
```

```rule
id: FE-006
severity: warn
scope: src/**
statement: The project uses a 2-tier folder structure: components/ for reusable components and features/ for page-specific components.
example: src/components/Modals/RemoveItemModal.tsx:1
check:
```
