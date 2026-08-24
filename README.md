# TaskBoard — FSL AI-Workflows Training Lab

A deliberately realistic task-board app used in FullStack Labs' AI-assisted
development training. You'll use this codebase throughout the labs to practice
real workflows with Claude Code: shipping reviewed PRs, encoding team
conventions, building guardrails, and running pattern-aware code generation.

It looks and behaves like a production codebase on purpose — layered
architecture, shared conventions, CI, seeded data, **and a few real bugs in the
issue backlog**. Treat it like you'd treat work code.

## Getting your copy

1. Click **Use this template → Create a new repository** (public or private, your account).
2. Clone your copy, then from the repo root run the setup script for your platform — it creates the training labels + backlog issues in YOUR repo:

```bash
./scripts/setup-repo.sh      # macOS / Linux
```

```powershell
.\scripts\setup-repo.ps1     # Windows (PowerShell)
```

> Template copies don't inherit issues, so this script seeds your working
> backlog. Add `--protect-main` (bash) or `-ProtectMain` (PowerShell) to also
> require PRs with green CI on main. Re-running is safe: issues that already
> exist are skipped.

## Quickstart

Requires Node 20+ (`nvm use` picks it up from `.nvmrc`).

```bash
npm install
npm run reset-db     # creates server/data/db.json from the seed
npm run dev          # client on http://localhost:5173, API on http://localhost:3001
```

| Script                               | What it does                                       |
| ------------------------------------ | -------------------------------------------------- |
| `npm run dev`                        | Run client + server together                       |
| `npm test`                           | All tests (`-w server` / `-w client` for one tier) |
| `npm run lint` / `npm run typecheck` | What CI runs on every PR                           |
| `npm run reset-db`                   | Restore the database to the canonical seed         |
| `npm run hypr:setup`                 | Install the bundled Hypr framework (Lab 3)         |
| `npm run hypr:teardown`              | Remove it again after the lab                      |

## Architecture at a glance

Three npm workspaces: `client/` (Vite + React 18 + TS), `server/` (Express 5 +
TS), `shared/` (types both tiers import). The server is layered **route →
service → repository → store**, persisting to a JSON file behind a repository
boundary; every response uses a shared envelope. Details in
[docs/architecture.md](docs/architecture.md) and
[docs/adr/](docs/adr/) — and [CLAUDE.md](CLAUDE.md) is the working example of a
project context file, worth reading on its own.

## How the labs use this repo

- **Lab 1 — First AI-assisted task.** Run `./scripts/setup-repo.sh`, pick an
  issue labeled `lab-1` from your backlog, and ship it as a reviewed,
  CI-green PR using Plan Mode — tests included. The CLAUDE.md here is your
  reference for what a good context file looks like.
- **Lab 2 — AI-document governance.** This repo ships exactly one worked
  example of each governance artifact: one ADR
  ([docs/adr/0001](docs/adr/0001-shared-api-response-envelope.md)), one hook
  guardrail ([.claude/hooks/protect-seed.js](.claude/hooks/protect-seed.js)),
  one scoped rules file ([.claude/rules/testing.md](.claude/rules/testing.md)).
  The gaps are yours to fill: an ADR for a decision that's in the code but
  undocumented, the first [docs/nfr/](docs/nfr/) document, and a
  database-safety guardrail.
- **Lab 3 — Hypr pipeline.** The repeated conventions across route/service/
  repository files and the parallel component slices are what
  pattern assessment extracts. Run `npm run hypr:setup` once (see
  [Hypr for Lab 3](#hypr-for-lab-3)), run the assessment here, then ship a
  scoped feature chunk through the generated agents.
- **Lab 4 — Capstone.** Author your own artifact in `.claude/` (subagent,
  skill, workflow automation) or a governance doc, and use it on a real task
  in this repo.

## Hypr for Lab 3

Hypr lives in a private marketplace, so this repo ships a pinned copy of it in
[.claude/plugins/hypr/](.claude/plugins/hypr/) — no access to the upstream repo
needed. Register and install it once per machine:

```bash
npm run hypr:setup
```

That runs two Claude Code commands: it registers `.claude/plugins/hypr` as a
local marketplace named `hypr-lab`, then installs the `hypr` plugin from it.
Restart Claude Code afterwards and `/hypr:assess`, `/hypr:plan`,
`/hypr:build-chunk` and the rest are available. Re-running it is safe.

Both commands use `--scope local`, so Hypr is enabled **in this repo only** —
your other projects are untouched. The wiring lands in
`.claude/settings.local.json`, which is gitignored because it holds an absolute
path specific to your machine; the committed `.claude/settings.json` stays as
Lab 2 left it.

To remove it after the lab:

```bash
npm run hypr:teardown
```

That uninstalls the plugin and drops the marketplace registration. If the
plugin isn't installed it stops there and leaves the marketplace alone — remove
that on its own with `claude plugin marketplace remove hypr-lab`.

> Already using Hypr from the real marketplace? Local scope keeps the two apart
> here, but a user-scope `hypr` stays active in this repo as well — disable it
> for the duration of the lab.

`/hypr:conformance` and the ast-grep half of `/hypr:review` are out of scope for
this lab — nobody installs `ast-grep`, so `/hypr:review` notes that its
mechanical pass was skipped and reviews every rule by judgement instead. That
line in the report is expected, not a broken setup.

## Known quirks

- The test suite is intentionally incomplete — some modules have exemplary
  coverage, others have gaps. Part of your job is closing them.
- The backlog issues are real: the bugs they describe are in this code.
- `/api/inspiration` simulates a flaky third-party API (404/429/500 on
  purpose). Its failures are features.
- `server/data/seed.json` is the canonical baseline and is guarded — see the
  Critical rules in [CLAUDE.md](CLAUDE.md).

## Troubleshooting

- **Port in use:** the server takes `PORT` from the environment; the client
  proxy targets 3001, so change both if you move it.
- **Node version errors:** `nvm use` (needs ≥ 20; Vite requires 20.19+).
- **Weird data state:** `npm run reset-db` restores the seed.
- **Windows and Hypr:** `npm run hypr:setup` / `hypr:teardown` work as-is (both
  run through `cmd.exe`). Hypr's own post-edit hook is a bash script, though, so
  install Git for Windows if you want it — without bash on PATH the hook is
  skipped, which costs you a per-edit reminder and nothing else.
- **Windows:** use the PowerShell scripts (`.\scripts\setup-repo.ps1`,
  `.\scripts\seed-issues.ps1`) — they mirror the `.sh` versions. If your
  execution policy blocks them, run
  `powershell -ExecutionPolicy Bypass -File .\scripts\setup-repo.ps1`.
  The app itself runs fine on any OS.

## License

MIT — see [LICENSE](LICENSE).
