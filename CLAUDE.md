# TaskBoard

Task-board training app: React client + Express API + JSON-file database.
npm-workspaces monorepo: `client/` (Vite + React 18 + TS), `server/` (Express 5 + TS), `shared/` (types only, imported as TS source — no build step).

## Commands

- `npm install` then `npm run reset-db` — first-time setup
- `npm run dev` — start client (5173) and server (3001) together
- `npm test` — all tests; single workspace: `npm test -w server`
- Single file: `npx vitest run src/services/tags.service.test.ts` from inside `server/` or `client/`
- `npm run lint` / `npm run typecheck` — must pass before every PR
- `npm run reset-db` — restore `server/data/db.json` from the seed

## Architecture

- Request flow: route → service → repository → store. Routes parse input (zod) and send responses; services own ALL business rules and throw typed errors; repositories only persist.
- Every API response uses the shared envelope: `{ data, meta? }` on success, `{ error: { code, message, details? } }` on failure (see docs/adr/0001).
- Domain and API types live in `@taskboard/shared` — never redeclare them locally.

## Critical rules

- NEVER modify `server/data/seed.json` — it is the canonical baseline every lab resets to (also enforced by a deny rule and a PreToolUse hook). To change data, use the API or edit `db.json`, then `npm run reset-db` to restore.
- All `db.json` access MUST go through `server/src/repositories/`. Routes and services never import `server/src/db/store.ts`.
- Produce API responses ONLY with the helpers in `server/src/lib/respond.ts`; never hand-roll response JSON.
- Throw error classes from `server/src/lib/errors.ts` for expected failures; never return error objects or set status codes in services.

## Code style (where it differs from defaults)

- Named exports only — no default exports anywhere.
- One React component per file, file named after the component. Feature folders follow Page → Grid → Card (+ Form) naming, e.g. `TagsPage`/`TagGrid`/`TagCard`/`TagForm`.
- Styling is CSS Modules co-located with the component (`TagCard.module.css`), consuming design tokens from `client/src/index.css` — no raw hex values in component CSS.
- Server logging: `logger.info('<file-basename>', message, meta?)` from `server/src/lib/logger.ts`. Bare `console.*` in `server/src` fails lint.
- Data hooks return `{ <items>, loading, error, refetch, ...mutators }` — copy the shape of `useTags`.

## Gotchas

- Express 5 forwards rejected async handlers to the error middleware automatically — do not add try/catch or wrapper utilities in routes.
- Server tests MUST create their data dir via `makeTestDb()` from `server/src/testing/helpers.ts`; never read or assert against the real seed data. See `.claude/rules/testing.md`.
- `server/data/db.json` is gitignored and generated — a missing db.json is not a bug; the server copies the seed on boot.
- The client dev server proxies `/api` to `localhost:3001`; API paths in client code are origin-relative (no host).
- The inspiration endpoint simulates a flaky third-party API (404/429/500 on purpose) — its errors are expected behavior, not bugs.

## Workflow

- Branch names: `feat/<slug>` or `fix/<slug>`; commits follow Conventional Commits (`fix: correct overdue check`).
- Every PR: lint + typecheck + tests green in CI, tests added for the change, link the issue with `Closes #N`.
- Architectural decisions are recorded in `docs/adr/` (template provided); NFR docs belong in `docs/nfr/`.
