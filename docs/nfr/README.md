# Non-functional requirements (NFRs)

This directory holds the team's non-functional requirement documents: the
cross-cutting rules code must follow regardless of feature — logging
conventions, database safety, how we handle external-API failures (timeouts,
404/429/500), performance budgets, security expectations.

**It is intentionally empty.** Writing the first NFR docs is a training-lab
deliverable (Lab 2). Good starting points already embodied in the code:

- The logging convention in `server/src/lib/logger.ts` and its usage rules in CLAUDE.md.
- The external-API error-handling pattern in `server/src/services/inspiration.service.ts`
  and its tests (404 → NOT_FOUND, 429 → RATE_LIMITED + Retry-After, 5xx → UPSTREAM_ERROR).
- The database-access boundary: only `server/src/repositories/` may touch the store
  (worth pairing with an ADR and a guardrail).

Keep each NFR doc short and testable: what the rule is, why it exists, how to
comply, and how compliance is checked (lint rule, hook, review checklist, test).
