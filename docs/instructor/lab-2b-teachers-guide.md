# Lab 2.b teacher's guide — guardrails over Google Meet

How to run the 2.b session (26 slides, agenda ~103 min in a 120 cap), **over Google Meet**.
Audience: instructors; **deliberately not linked from any student-facing document** — it carries
the rescue code for both targets, which must never appear on screen. Companion to the slide notes
and to `docs/labs/lab-2b-demo-walkthrough.md` (the student-replayable demo script).

Calibrated against Lab 1.b (2026-08-12 interview): checkpoint gates worked; the room waits to be
told — the demo is a build-along and the exercise has named targets for that reason: a default (the sibling-test nudge) and a store-boundary choice for anyone who did the 2.a stretch.

---

## 1. The session in four sentences

Last week the room wrote a standard; today they make something refuse to violate it. The demo
builds one guardrail together (read-only `db.json`) so the mechanics are rehearsed; the exercise
then has each person enforce **their own 2.a clause** at two enforcement points — a hook
(authoring time) and a CI gate (merge time) — with the unenforceable residue decided and named,
back in the 2.a NFR. The interesting output is not the hook; it is the residue list. The block
ends by handing the team the sixth artifact: how standards travel.

**The evidence standard, repeated all session:** refusal text pasted in the PR description.
"It worked" is not verification.

## 2. Remote mechanics — this session's specifics

| Need                         | Meet mechanism                                                   | The gotcha                                                                                                                             |
| ---------------------------- | ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| Build-along demo             | Screen-share + the seven-step slide; call step numbers as you go | Nobody can glance at a neighbour's screen — the step number is the rejoin point                                                        |
| Checkpoint verification      | **Paste refusal text into chat**                                 | Silence from a name = check in via Slack, not the whole call                                                                           |
| Prereq check                 | Chat: "type 2A-DONE and HOOKS-DONE"                              | Anyone missing either follows the shared screen and completes async                                                                    |
| 1:1 help during the exercise | **Slack** — Meet chat has no DMs                                 | Say it out loud at exercise start or strugglers sit silent                                                                             |
| Retro                        | Chat waterfall (type, hold, 3-2-1 send)                          | —                                                                                                                                      |
| The capture inputs           | Refusal texts + retro lines live in chat                         | **Meet deletes chat at call end — copy it before leaving**                                                                             |
| Seeing the CI gate run       | Students must **open a draft PR**                                | `on: pull_request` — a pushed branch alone runs nothing; say this before the gate step or half the room concludes their gate is broken |

## 3. Prep checklist

- [ ] Deck at slide 1; the demo walkthrough (`docs/labs/lab-2b-demo-walkthrough.md`) open in a
      tab — it is your demo script, verbatim
- [ ] Your own copy reset and WITHOUT the db.json guardrail (you build it live; a pre-built one
      kills the wrong-turns that teach)
- [ ] The rescue code from §5 in a scratch file — for Slack DMs to stuck students, never for
      screen-share
- [ ] Slack channel open; capture template location handy for after
- [ ] Sticky note: **copy chat before ending the call**

## 4. Run sheet (deltas from the slide notes — the notes carry the per-slide detail)

| Segment                  | Remote-critical moves                                                                                                                                                      |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Agenda (2)               | Prereq check in chat now. Assessment disclosure: rubric + Framework Practitioner artifact                                                                                  |
| Warm-up (6)              | Everyone edits settings.json together; verification = paste Claude's refusal line in chat; watch for "seed.json rule gone" (paste-over)                                    |
| Layers & severity (5–12) | Taught; keep pace — the exercise needs its full 34 min                                                                                                                     |
| Demo build-along (13–18) | Run against the seven-step slide, call step numbers. Steps 6–7 (verify both ways) get the time; your own live false positive is a gift                                     |
| Checkpoint 1 (18)        | Refusal texts in chat; read them as they land                                                                                                                              |
| Your clause (20–23)      | Announce the two named targets (on-slide) + the draft-PR gotcha BEFORE they start. One whole-call chat nudge at ~7 min: "what does your allow case replay?" Slack for 1:1s |
| Checkpoint 2 (21)        | Refusal text in PR description — check PR links in chat                                                                                                                    |
| Review (24)              | Two or three volunteers screen-share. Push hardest on the residue question                                                                                                 |
| Hand-off (25)            | Three minutes, framing over content; done = rung + first move + a named person                                                                                             |
| Wrap (26)                | Retro waterfall; reflection note into the PR now; **copy the chat**; file the capture within 24h                                                                           |

## 5. Rescue code (never on screen — Slack it to a stuck student, one piece at a time)

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
        'Why: NFR-0002 — a change under server/src ships with a test in the same PR.',
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
  echo "::error::server/src changed with no test in the diff (NFR-0002)."
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
      'BLOCKED: only repositories/ may import db/store (ADR-0002 / NFR-0002).',
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
  echo "::error::db/store imported outside repositories/ (ADR-0002)."
  exit 1
fi
```

(Note the `index.ts` exclusion — the boot-time `ensureDb()` exception their own ADR names.
A student whose gate fails on index.ts has just met their ADR's exception clause in the wild:
that is a teaching moment, not a bug.)

## 6. Expected outcomes (recognition, not steering)

- Most hooks land as **nudges** (test discipline is PARTLY by nature); most gates as **fail**
  with a docs-only path filter or a written "accepted noise" decision
- The residue list should contain, at minimum: _"the test must have failed first"_ with an
  owner or an explicit drop — if a PR closes 2.b without it, the central lesson missed
- One or two students will discover the draft-PR gotcha before you warn them — let the first
  one report it in chat; peer-discovered gotchas stick

## 7. Failure modes and recoveries (Meet edition)

| Symptom                                         | Recovery                                                                                                                                                       |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "My hook never fires" (will be the most common) | New session? Then matcher, then Windows paths. It's on the steps slide and in the walkthrough                                                                  |
| "My gate doesn't run"                           | Draft PR open? `on: pull_request` runs nothing for a bare branch                                                                                               |
| A student's clause is fuzzy and they're stalled | They build the mechanical core of the AGREED list instead; the fuzzy clause becomes their residue entry — nobody builds nothing                                |
| Store-boundary gate fails on index.ts           | Their ADR's own exception clause, live — point them at their ADR, not at the code                                                                              |
| Someone disables the seed hook to "simplify"    | Stop that gently and publicly — the layers are the exhibit; removing one to make another easier is the anti-lesson                                             |
| Exercise overruns                               | Cut order (already in the deck notes): README → async; layers 3–5 compression; stored-proc slide drops. Never cut verify-both-ways, the bypass, or the residue |
| Chat floods with refusal texts at once          | Good — that's the checkpoint working. Skim for names missing, not for content                                                                                  |
| Screen-share stage fright at review             | Ask for PR links in chat instead and read one aloud yourself — the artifact reviews fine without its author presenting                                         |

## 8. After the session

- **Copy the chat before ending the call** — refusal texts, PR links, retro lines all feed the
  capture entry
- File the capture within 24h (`AI-Transformation-Playbook/04-labs/lab-capture-template.md`);
  note which clauses produced hooks vs gates vs residue — that distribution is the Format B
  data point for this block
- The roll-up decision (rung + first move + owner) goes to the weekly status; if the room
  deferred it, that deferral is itself the status line — with a date
- Async completions keep every acceptance criterion, including the reflection note and peer
  review; Slack is the support channel
