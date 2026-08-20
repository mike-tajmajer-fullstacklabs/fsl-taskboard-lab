# Lab 2.b teacher's guide — guardrails over Google Meet

How to run the 2.b session (26 slides, agenda ~107 min in a 120 cap), **over Google Meet, with
the participants gathered at physical tables on their side**. Audience: instructors;
**deliberately not linked from any student-facing document** — it carries the rescue code for
all four menu rules, which must never appear on screen. Companion to the slide notes and to
the four student demo walkthroughs (`docs/labs/lab-2b-demo-{1,2,3,4}-*-walkthrough.md`).

Calibrated against Lab 1.b (2026-08-12): checkpoint gates worked; the room waits to be told —
the demo is a build-along and the exercise has named targets for that reason. **Restructured
2026-08-18 from team-lead feedback:** shorter demos, one per enforcement layer, told as a
timeline (authoring → commit → merge); the **git hook is taught first** as the familiar anchor
and is the vehicle for teaching Claude hooks; one structured table-talk beat; side discussion at
the tables is welcome all session. Announce the change as a **deliberate adjustment, not an
apology** — the script is in the slide-2 notes.

---

## 1. The session in five sentences

This repo is full of written rules that nothing enforces; today each person picks one and gives
it teeth. The session teaches ONE anatomy — an event fires a script, and the exit code decides —
met first where the room already lives with it (their own repo runs husky), then moved to
authoring time (the Claude hook they build along), then to merge time (the CI gate they wire).
The exercise (reworked 2026-08-19 — no prior NFR assumed): pick a rule from the **four-rule
menu** (or bring your own), build the hook, verify both directions, then run the same check as a
CI gate. Kept deliberately simple — no severity essays, no residue ceremony: build it, prove it
fires, prove it stays quiet. The block ends by handing the team the sixth artifact: how
standards travel.

**The evidence standard, repeated all session:** the hook's text pasted in the PR description
(and the gate's run URL — its merge-time twin). "It worked" is not verification.

## 2. Remote + table mechanics — this session's specifics

| Need                         | Mechanism                                                        | The gotcha                                                                                                                             |
| ---------------------------- | ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| Tables                       | Participants sit together in rooms; you present over Meet        | You cannot see or hear a table — the per-table chat report-backs and the checkpoints are your only visibility. Design holds: evidence in chat, always |
| Side discussion              | Standing permission, announced at slide 2                        | Mute unless addressing the call. Table talk is encouraged during builds; checkpoints stay **individual** — everyone pastes their own evidence |
| Table-talk beat (slide 12)   | You mute; one line per table in chat; solo attendees answer solo | Silence from a table → Slack someone at it, never a call-out. The lines are their guardrail backlog — copy them out                    |
| Build-along demo             | Screen-share + the steps slide; call step numbers as you go      | The step number is the rejoin point — and a table can now also rescue its own straggler; give it a beat before you intervene           |
| Checkpoint verification      | **Paste refusal text into chat** (gate: the run URL)             | Silence from a name = check in via Slack, not the whole call                                                                           |
| Prereq check                 | Chat: "type HOOKS-DONE"                                          | Anyone missing it follows the shared screen and completes async                                                                        |
| 1:1 help during the exercise | **Slack** — Meet chat has no DMs                                 | Say it out loud at exercise start or strugglers sit silent                                                                             |
| Retro                        | Chat waterfall (type, hold, 3-2-1 send)                          | —                                                                                                                                      |
| The capture inputs           | Refusal texts + run URLs + table-talk lines + retro lines        | **Meet deletes chat at call end — copy it before leaving**                                                                             |
| Seeing the CI gate run       | Students must **open a draft PR**                                | `on: pull_request` — a pushed branch alone runs nothing; say this before the gate step or half the room concludes their gate is broken |
| Rubric question at a table   | "Does helping each other hurt our scores?"                       | No — peer help scores Independence 3; **helping others scores 4**. Say so if asked; never discuss individual scores                    |

## 3. Prep checklist

- [ ] Deck at slide 1; demo walkthroughs 1–3 open in tabs — they are your demo scripts,
      verbatim (demo 4, reading the CI, is self-guided student material — no live beat)
- [ ] Your own copy reset, WITHOUT the db.json guardrail and WITHOUT husky (you build both live;
      pre-built kills the wrong-turns that teach)
- [ ] The rescue code from §6 in a scratch file — for Slack DMs to stuck students, never for
      screen-share
- [ ] Ask the team lead (day before) whether a topics/concerns list is coming — if yes, pick two
      items to read aloud as candidate rules at the table-talk beat
- [ ] Slack channel open; capture template location handy for after
- [ ] Sticky note: **copy chat before ending the call**

## 4. Run sheet (deltas from the slide notes — the notes carry the per-slide detail)

| Segment                     | Remote-critical moves                                                                                                                                              |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Agenda (2)                  | Announce the format adjustment (deliberate, not apology) + table-talk permission. Prereq check in chat. Assessment disclosure: rubric + Framework Practitioner artifact |
| Map + where-this-grows (5–6) | 5 min total; say the order out loud — layer 3 first because they already run it. Slide 6 is org-level and aspirational (typical start → aspiration); if someone says "that starting column is us": "that's everyone — it's why this session exists" |
| Warm-up (7)                 | Run card 1. Everyone edits settings.json together; paste the refusal line in chat; watch for "seed.json rule gone" (paste-over)                                    |
| Git-hook demo (8)           | Run card 2. Instructor-only demo against the slide's 7 rows (row 3 = the runs-everywhere beat, nothing typed); land "event → script → exit code decides" at row 4 |
| Bridge (9) + refresher (10) + severity (11) | Walk the bridge ONE COLUMN at a time. The refresher is the whole hook contract on one slide — 60–90 s down the left column, then point at the JSON (the exercise reuses that exact shape). Severity = the Claude-side refinement (which event = which severity) |
| Table talk (12)             | You mute, ~4 min; one line per table in chat (rule + moment + block/nudge); seed from the topics list if one arrived                                               |
| Demo build-along (13–18)    | Run card 3, against the seven-step slide, call step numbers. Steps 6–7 (verify both ways) get the time; your own live false positive is a gift                     |
| Checkpoint 1 (18)           | Refusal texts in chat; read them as they land                                                                                                                     |
| Your rule: menu (19)        | Read all four rows aloud, give tables a quiet minute to pick; choosing together is fine, clustering is fine. Own rule? One filter: detectable from path or content |
| Your rule: hook (20–21)     | One whole-call chat nudge at ~7 min: "what does your allow case replay?" Slack for 1:1s. Checkpoint 2: the hook's text in the PR                                   |
| Your rule: gate (22–23)     | Say the mechanism first (GitHub can't run their hook — second program). Draft-PR gotcha BEFORE they start. Checkpoint 3: PR link + red-then-green check in chat    |
| Review (24)                 | Two or three volunteers screen-share. Push hardest on the false-positive question; a table's severity disagreement is better material than a working demo         |
| Hand-off (25)               | Three minutes, framing over content; done = rung + first move + a named person                                                                                     |
| Wrap (26)                   | Retro waterfall; reflection note into the PR now; **copy the chat**; file the capture within 24h                                                                   |

## 5. Demo run cards

Uniform shape: clock · script (type this / say this) · prepared failure + recovery · common
questions live in the slide notes.

### Run card 1 — Warm-up: permissions (layer 2a) · 5 min · slide 7

1. Everyone opens `.claude/settings.json`. Say: "merge, never paste — your seed rules and hooks
   block must survive." (~1 min)
2. Everyone merges the `allow`/`ask` arrays + appends the new `deny` entries (on-slide). While
   they type, teach the rule of thumb: **deny the unrecoverable, ask the annoying** — if
   everything asks, prompt fatigue kills the layer. The `allow` array is empty on purpose — it's
   where never-ask commands get promoted later; entries are earned. (~2 min)
3. Verify: "ask Claude to force-push — paste the refusal line into chat." Then: "now ask it to
   edit seed.json — still refused?" (~2 min)

**Prepared failure:** someone's seed rule is gone (they pasted over the file). Recovery: the
handout has the before-state; restore both blocks, re-verify. Do it in Slack unless two or more
hit it — then fix one on the shared screen.

**Known wart — say nothing unless asked:** the `Write(path)` deny entries are no-ops in current
Claude Code (`Edit(path)` rules cover all file-editing tools); the Write lines are kept as
harmless belt-and-suspenders, and headless runs may print a warning about them. Protection
holds via the Edit rules either way.

### Run card 2 — The git hook (layer 3) · 8 min · slide 8 · instructor-only demo

Student replay: `docs/labs/lab-2b-demo-2-git-hook-walkthrough.md` (stretch goal).

Steps match the slide's 7 rows exactly — call the row number as you go.

1. **Type:** `npm install -D husky`, then `npx husky init` (two commands — `&&` breaks on
   Windows PowerShell 5.1, and the walkthrough shows them separately) — **say:** ".husky/
   appeared, and package.json gained a prepare script — that's how the hooks reach every
   teammate who runs npm install." Then `rm .husky/pre-commit` — "husky starts you with
   npm-test-on-commit; today is about commit-msg." (~2 min)
2. **Type:** `cp docs/labs/snippets/commit-msg.sh .husky/commit-msg` — **say:** "same command on
   Windows — PowerShell aliases cp." Open the hook on screen. **Say:** "five working lines —
   read the first: git hands us the commit-message file as $1. The rule it checks is already in
   CLAUDE.md; nothing enforced it until now." Point at the BLOCKED/Why/Instead/Done block: "same
   message shape as every hook in this repo." (~1.5 min)
3. **Nothing to type — the say-only row:** "notice what we did NOT do: no chmod, no extension,
   and the shebang is decoration. Git runs husky's shim, and the shim runs this file as an
   argument to sh — the OS never executes it. Same on Windows: git ships its own shell." If
   pressed (or to flex): `chmod -x .husky/commit-msg` and commit — it still fires. Raw git
   hooks are the caveat (they DO need chmod +x, and `git update-index --chmod=+x` to travel) —
   the walkthrough carries it. (~0.5 min)
4. **Type:** `git commit --allow-empty -m "changed stuff"` — refused. **Say the anatomy line,
   slowly: "an event fired a script, and the exit code decided. That sentence is the whole
   concept — you'll see it twice more today, unchanged."** (~1 min)
5. **Type:** `git commit --allow-empty -m "docs: explain the commit format"` — passes silently.
   "Exit 0 is the 99% case — a hook that fires on legitimate work gets disabled by Friday." (~1 min)
6. **Type:** `git commit --no-verify -m "changed stuff"` — it lands. **Say:** "the bypass ships
   with git — you can't remove it, so you write it down: when it's OK, who approves. An
   undocumented bypass is the real governance hole. And count how often it fires — a bypass used
   weekly is a rule that's wrong, not a team that's lax." (~1.5 min)
7. **Do not run** row 7 — say it: "clone this fresh without npm install: no hooks. Layer 3
   travels with the wired clone — and that plus --no-verify is exactly why the same rule runs
   again at merge time." Cleanup off-screen later: `git reset --hard HEAD~2`. (~0.5 min)

**Prepared failure:** the hook doesn't fire for you live. Check in this order, narrating:
`"prepare": "husky"` present in package.json, `npm install` run since, `git config
core.hooksPath` says `.husky/_`. Finding it live IS the lesson — these are the rows of the
stuck-points table. (The exec bit is NOT on this list — husky's shim runs the file via sh.)

**Two more prepared failures, both observed on a real Windows repo (2026-08-19):** every commit
failing with `npm error Missing script: "test"` = the starter pre-commit is still present and
that repo has no test script — hook order means it blocks before commit-msg ever runs; delete it.
Every commit blocked with `: command not found` (code 127) or a syntax error = CRLF line endings
in the hook file (Windows editor default) — save as LF; a CRLF hook fails closed.

### Run card 3 — The Claude hook build-along (layer 2b) · 19 min · slides 13–18

Student replay: `docs/labs/lab-2b-demo-3-claude-hook-walkthrough.md` — it is your script,
verbatim; run against the seven-step slide, calling step numbers.

The card's only additions to the previous build: open with the bridge frame ("the git hook you
just watched, moved to authoring time — the event is the agent's tool call, the input is JSON on
stdin, exit 2 is the block"), and at step 5 land the analogy for restarts: "hooks load at session
start the way git hooks arrive at npm install." Steps 6–7 get the time; your own live false
positive is a gift — work it through on the shared screen. Checkpoint 1: refusal texts in chat.

**Step 6 is the two-message beat — the demo's strongest minute.** Permission rules evaluate
BEFORE PreToolUse hooks (verified live, 2026-08-19), so: ask once — the deny answers with the
generic wall ("denied by your permission settings"). **Say: "listen to the difference."** Pull
the two db.json deny entries, start a NEW session (settings load at start), ask again — the hook
answers with BLOCKED/Why/Instead/Done. Restore the entries. **Say: "the wall stops; the signpost
redirects — and your clause this afternoon can ONLY be a hook, because deny rules match paths
and hooks run logic."** The hook's text is the evidence they save.

_(The former "CI today" run card was retired 2026-08-19 with its slide — the gate slide's lede
now carries the second-program mechanism, its notes carry the division-of-labour aside, and the
format:check gap-hunt lives on as **self-guided** material in
`docs/labs/lab-2b-demo-4-ci-walkthrough.md`. Demo 4 is reference material, not a live demo.)_

## 6. Rescue code (never on screen — Slack it to a stuck student, one piece at a time)

### The sibling-test nudge, assembled — read and test this before the session

The fragments further down are for Slack-ing one piece at a time; this is the complete runnable
file so YOU hold the whole picture. **The unlock: nothing in the code makes it "a PostToolUse
hook"** — the identical script under `"PreToolUse"` would be a block. The registration event
decides what exit 2 can still do: before the tool runs it vetoes; after, there is nothing to
veto, so the stderr is delivered to the agent as feedback instead.

```js
#!/usr/bin/env node
// .claude/hooks/check-convention.js — the sibling-test nudge, complete.
let raw = '';
process.stdin.on('data', (chunk) => (raw += chunk));
process.stdin.on('end', () => {
  let filePath = '';
  try {
    filePath = JSON.parse(raw).tool_input?.file_path ?? '';
  } catch {
    process.exit(0); // unparseable — never block unrelated work
  }
  const path = filePath.replaceAll('\\', '/');

  const isServerSrc = /server\/src\/.*\.ts$/.test(path) && !path.endsWith('.test.ts');
  if (isServerSrc) {
    const fs = require('fs');
    const sibling = path.replace(/\.ts$/, '.test.ts');
    if (!fs.existsSync(sibling)) {
      console.error(
        [
          'NOTE: ' + path + ' has no sibling test.',
          'Why: CLAUDE.md testing approach — tests are co-located; a change ships with its test.',
          'Instead: add or extend ' + sibling + ' before opening the PR.',
        ].join('\n'),
      );
      process.exit(2); // PostToolUse: informs, cannot block
    }
  }
  process.exit(0);
});
```

Registered under **PostToolUse** — this is what makes it a nudge:

```json
"hooks": {
  "PostToolUse": [{ "matcher": "Edit|Write",
    "hooks": [{ "type": "command",
      "command": "node \"$CLAUDE_PROJECT_DIR/.claude/hooks/check-convention.js\"" }] }]
}
```

Test it in seconds, no agent session (from the repo root — `stats.service.ts` has no test, the
planted gap, so it fires; `todos.service.ts` has one, so it stays silent):

```bash
echo '{"tool_input":{"file_path":"server/src/services/stats.service.ts"}}' | node .claude/hooks/check-convention.js; echo "exit: $?"
```

**Default target — test discipline (PostToolUse nudge: edited server/src `*.ts` with no sibling test):**

```js
// inside the hook, after parsing filePath:
const path = filePath.replaceAll('\\', '/');
const isServerSrc = /server\/src\/.*\.ts$/.test(path) && !path.endsWith('.test.ts');
if (isServerSrc) {
  const fs = require('fs');
  const sibling = path.replace(/\.ts$/, '.test.ts');
  if (!fs.existsSync(sibling)) {
    console.error(
      [
        'NOTE: ' + path + ' has no sibling test.',
        'Why: CLAUDE.md testing approach — tests are co-located; a change ships with its test.',
        'Instead: add or extend ' + sibling + ' before opening the PR.',
      ].join('\n'),
    );
    process.exit(2); // PostToolUse: informs, cannot block
  }
}
```

Gate core (in `governance-gate.yml`'s check step):

```bash
if grep -qE '^server/src/.*\.ts$' changed.txt && ! grep -qE '\.test\.ts$' changed.txt; then
  echo "::error::server/src changed with no test in the diff (CLAUDE.md testing approach)."
  exit 1
fi
```

**Store-boundary choice (PreToolUse block: import of db/store outside repositories/):**

```js
const path = filePath.replaceAll('\\', '/');
const body = payload.tool_input?.content ?? payload.tool_input?.new_string ?? '';
const inServer = path.includes('server/src/') && !path.includes('server/src/repositories/');
if (inServer && /from\s+['"].*db\/store['"]/.test(body)) {
  console.error(
    [
      'BLOCKED: only repositories/ may import db/store (CLAUDE.md Don\'t list).',
      'Why: business logic coupled to the storage format cannot be tested or swapped.',
      'Instead: call the repository for this entity, or add the method it lacks.',
      'Done means: no db/store import outside server/src/repositories/.',
    ].join('\n'),
  );
  process.exit(2);
}
```

Gate core:

```bash
if grep -rn "from '.*db/store'" server/src --include='*.ts' | grep -v 'repositories/' | grep -v index.ts; then
  echo "::error::db/store imported outside repositories/ (CLAUDE.md)."
  exit 1
fi
```

(Note the `index.ts` exclusion — the boot-time `ensureDb()` call is the rule's one legitimate
exception. A student whose gate fails on index.ts has just met a real rule's real-world
exception: that is a teaching moment, not a bug — the fix is the exclusion shown above.)

**Typed errors (PostToolUse nudge: `throw new Error(` written under server/src):**

```js
// inside the hook, after parsing filePath AND body (content ?? new_string):
const path = filePath.replaceAll('\\', '/');
if (path.includes('server/src/') && !path.endsWith('.test.ts') && /throw\s+new\s+Error\(/.test(body)) {
  console.error(
    [
      'NOTE: this change throws a bare Error.',
      'Why: CLAUDE.md conventions — expected failures use the typed classes in server/src/lib/errors.ts.',
      'Instead: throw NotFoundError / ConflictError / ValidationError as appropriate.',
    ].join('\n'),
  );
  process.exit(2);
}
```

Gate core: `git diff origin/$BASE...HEAD -- 'server/src/**/*.ts' | grep -E '^\+.*throw new Error\('`
→ error "bare Error thrown in server/src (CLAUDE.md conventions)". Diff-scoped (`^\+` = added
lines only), so existing code never trips it — and today the codebase has zero, verified.

**Response envelope (PostToolUse nudge: `res.json`/`res.send` written in a route file):**

```js
const path = filePath.replaceAll('\\', '/');
if (path.includes('server/src/routes/') && /res\.(json|send)\(/.test(body)) {
  console.error(
    [
      'NOTE: this route responds directly with res.json/res.send.',
      'Why: ADR-0001 — every response uses the envelope, produced only by server/src/lib/respond.ts.',
      'Instead: use the respond.ts helpers (sendData / sendError).',
    ].join('\n'),
  );
  process.exit(2);
}
```

Gate core: same diff-scoped grep shape on `server/src/routes/**` for `res\.(json|send)\(`
→ error "route bypasses the envelope (ADR-0001)". Also zero existing violations, verified.

## 7. Expected outcomes (recognition, not steering)

- Expect clustering on the sibling-test and store-boundary rules (they were the old named
  targets and the demo primes them) — fine; the typed-errors and envelope picks tend to come
  from whoever wants a content-match challenge
- Most hooks land as **nudges** (three of the four menu rules are content heuristics); the
  store boundary is the natural **block**
- Table-talk lines skew toward formatting/lint rules at commit time and test-discipline or
  boundary rules split between authoring-nudge and merge-gate — both defensible; the follow-up
  question is "who are you holding it against?"
- One or two students will discover the draft-PR gotcha before you warn them — let the first
  one report it in chat; peer-discovered gotchas stick

## 8. Failure modes and recoveries (Meet + tables edition)

| Symptom                                         | Recovery                                                                                                                                                       |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "My hook never fires" (will be the most common) | New session? Then matcher, then Windows paths. It's on the steps slide and in the demo-3 walkthrough                                                          |
| "My gate doesn't run"                           | Draft PR open? `on: pull_request` runs nothing for a bare branch                                                                                              |
| The git-hook stretch doesn't fire (async)       | prepare script, npm install, core.hooksPath — the demo-2 walkthrough's stuck-points table, in that order (NOT chmod — husky's shim runs the file via sh)      |
| Stretch: every commit fails "Missing script: test" | The starter pre-commit in a repo with no test script — pre-commit runs before commit-msg; delete it or add the script                                       |
| Stretch: every commit blocked, `command not found` (127) | CRLF line endings in the hook — save as LF; a CRLF hook fails closed (blocks valid commits too)                                                       |
| A student's own-rule pick isn't detectable      | One filter: can a script decide it from a file path or file content? If not, steer to the nearest menu rule — nobody builds nothing                           |
| "My regex is imperfect" stalls someone          | That's what nudges are for — an imperfect block stops real work; an imperfect nudge costs one ignorable note. Ship the nudge                                  |
| Store-boundary gate fails on index.ts           | The rule's one legitimate exception (boot-time ensureDb), live — the fix is the index.ts exclusion in the rescue gate core                                    |
| Someone disables the seed hook to "simplify"    | Stop that gently and publicly — the layers are the exhibit; removing one to make another easier is the anti-lesson                                            |
| A table goes silent for a whole segment         | Slack one person at it — never a call-out. If two tables go quiet at the same slide, the material is the problem: drop a rung and say so                      |
| Table talk runs hot past its box                | Good sign, but call it: "capture the thread in chat, we'll pull it into the review discussion" — then actually do so at slide 24                              |
| Exercise overruns                               | Cut order: README → async; compress where-this-grows (6) to 1 min; table talk 4 → 2 min (never zero). Never cut verify-both-ways, the bypass, the residue, a checkpoint, or the ~3-min hand-off |
| Chat floods with refusal texts at once          | Good — that's the checkpoint working. Skim for names missing, not for content                                                                                 |
| Screen-share stage fright at review             | Ask for PR links in chat instead and read one aloud yourself — the artifact reviews fine without its author presenting                                        |

## 9. After the session

- **Copy the chat before ending the call** — refusal texts, PR links, gate run URLs, table-talk
  lines, retro lines all feed the capture entry
- File the capture within 24h (`AI-Transformation-Playbook/04-labs/lab-capture-template.md`);
  note which menu rules were picked, which produced false positives, AND the interactive-format
  observations: did table talk produce the backlog lines, did the git-hook-first bridge land
  (fewer "what's a hook" questions at the build-along is the tell) — this session is the
  validation data point for the interactive variant
- The roll-up decision (rung + first move + owner) goes to the weekly status; if the room
  deferred it, that deferral is itself the status line — with a date
- Async completions keep every acceptance criterion, including the reflection note and peer
  review; Slack is the support channel
