---
paths:
  - "features/**"
---

# Example: `.claude/rules/planning.md` (Enterprise Platform v1)

> _Representative excerpt of a generated planning rule set. A full assessment
> emits 25+ `rule` blocks in the format defined in
> [docs/rules-format.md](../../rules-format.md). Planning rules are workflow-time
> (`paths: [features/**]`, also read explicitly by the planner); `check:` is
> reserved for a later enforcement step. The Feature Planning Process behavior is
> NOT in this file — it lives in the Hypr feature-planner agent._

```hypr-meta
domain: planning
base_commit: 9f1c2ad7b3e8c4d05a6e1f2b3c4d5e6f7a8b9c0d
generated_at: 2025-09-26
plugin_version: 1.0.0
next_id: 86
```

### Aspect 1: Feature Planning Structure

```rule
id: PL-001
severity: warn
scope: **/*
statement: Features follow a 3-tier architecture - database schema (migrations), API layer (controllers/services), and frontend UI (pages/components).
example: src/pages/Users.tsx:1
check:
```

```rule
id: PL-002
severity: warn
scope: db/migrations/**/*.sql
statement: Every new feature starts with a database schema migration named YYYY_MM_DD_TICKET_description.sql.
example: db/migrations/2025_06_05_T1316_TICKET_1234_create_user_schema.sql:1
check:
```

```rule
id: PL-003
severity: info
scope: src/pages/**/*.tsx
statement: Each entity follows the page-component structure Page.tsx -> TableHeader.tsx + TableSubheader.tsx + Table.tsx.
example: src/pages/Users.tsx:1
check:
```

```rule
id: PL-004
severity: info
scope: **/*
statement: Features are ticket-driven with a project prefix (PROJ-XXXX), referenced in migrations, components, and file names for traceability.
example: features/001-user-auth.md:1
check:
```
