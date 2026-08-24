---
paths:
  - "src/controllers/**/*.controller.ts"
  - "src/services/**/*.ts"
  - "src/data/**/*.ts"
---

# Example: `.claude/rules/backend.md` (Enterprise Platform V1)

> _Representative excerpt of a generated backend rule set. A full assessment
> emits 25+ `rule` blocks (this example project had 89) in the format defined in
> [docs/rules-format.md](../../rules-format.md). The `paths:` frontmatter above
> scopes when Claude loads these rules; the `check:` field is reserved for a
> later enforcement step and left empty. The Per-File Implementation Loop
> behavior is NOT in this file — it lives in the Hypr backend-executor agent._

```hypr-meta
domain: backend
base_commit: 9f1c2ad7b3e8c4d05a6e1f2b3c4d5e6f7a8b9c0d
generated_at: 2025-09-26
plugin_version: 1.0.0
next_id: 90
```

```rule
id: BE-001
severity: error
scope: src/controllers/**/*.controller.ts
statement: Controller classes use framework decorators with kebab-case route names matching resource plurals (e.g. @Route('resources')).
example: src/controllers/resources/resource.controller.ts:167
check:
```

```rule
id: BE-002
severity: error
scope: src/controllers/**/*.controller.ts
statement: API endpoints follow RESTful conventions with HTTP method decorators (@Get(), @Post(), @Put(), @Delete()) and parameter routes like /:id.
example: src/controllers/items/items.controller.ts:115
check:
```

```rule
id: BE-003
severity: warn
scope: src/controllers/**/*.controller.ts
statement: All controllers include API documentation with operation metadata, tags, response types, and authentication decorators.
example: src/controllers/resources/resource.controller.ts:180
check:
```

```rule
id: BE-004
severity: warn
scope: src/controllers/**
statement: Route organization separates public, private, and standard endpoints with nested controllers (e.g. /private/accounts, /public/sessions).
example: src/controllers/private/accounts/account.controller.ts:1
check:
```

```rule
id: BE-006
severity: error
scope: src/**
statement: Backend follows a layered architecture with clear separation: controllers/ for HTTP handlers, domain/ for models and utilities, data/ for database access.
example: src/controllers/resources/resource.controller.ts:1
check:
```

```rule
id: BE-009
severity: warn
scope: src/data/db/repositories/**/*.ts
statement: Database access follows DDD with repository objects ending in .repository.ts and helper functions ending in .helpers.ts.
example: src/data/db/repositories/account.repository.ts:22
check:
```

```rule
id: BE-016
severity: error
scope: src/controllers/auth/**/*.ts
statement: Authentication uses multiple strategies with security middleware: TokenGuard for bearer tokens and ApiKeyGuard for API keys.
example: src/controllers/auth/middleware/token.guard.ts:7
check:
```

```rule
id: BE-026
severity: error
scope: src/errors/**/*.ts
statement: Error handling uses a custom exception hierarchy extending a base error class with HTTP status codes and field validation support.
example: src/errors/validation-error.ts:6
check:
```
