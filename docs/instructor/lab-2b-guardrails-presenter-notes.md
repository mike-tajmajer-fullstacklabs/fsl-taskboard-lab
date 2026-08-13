# Lab 2.b — Guardrails, and Making Standards Travel · Presenter Notes

Speaker notes for `lab-2b-guardrails.pptx` (the same text is attached to each slide's Notes pane).

> **Calibrated against the Lab 1.b room feedback (2026-08-12), adapted for Google Meet
> delivery (remote, not in-room).** Nothing remains provisional.

## Slide 1 · Guardrails, and Making Standards Travel

Welcome to 2.b. The challenge in one breath: take the rule the class agreed last week and give it teeth — a hook that stops the agent while it writes, and a CI gate that stops anyone at merge time, both verified in both directions, with the unenforceable clauses honestly decided rather than quietly dropped. The interesting output today is not the hook — it is the list of things the hook could not check.

~1 min.

## Slide 2 · Two hours, hands-on _(Today)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

The blocks sum to ~103 — the slack is deliberate; protect it for verification, which is the step people skip. Prereq check right now, in chat: "type 2A-DONE and HOOKS-DONE if both are true" — anyone missing either follows along on the shared screen for the build sections and catches up async per the handout (Slack for 1:1 help; Meet chat has no DMs). Assessment disclosure: same rubric, and today's hook or gate is also the Framework Practitioner artifact.

~2 min.

## Slide 3 · Where 2.a left us _(Recap)_

Fast. The only new idea is the last bullet — the premise of the block. Today REVISITS the 2.a NFR: the residue decisions recorded this session update that same document, not a new one.

~2 min.

## Slide 4 · The model layer cannot be the control. _(The Premise)_

Industry consensus, not our opinion — say so. The phrase to land: "model-independent governance." Connect to their own interview complaints about the agent being a yes-man and ignoring stated patterns — this is the failure mode it addresses.

~3 min.

## Slide 5 · Five layers of enforcement _(The Map)_

The honesty about this repo matters — it models the behaviour we want. Note the build framing precisely: layers 1–2 plus one layer-4 gate; a governance doc that overstates its own coverage is the failure mode. Layer 5 is not a gap in the others — it is what makes them credible.

~4 min.

## Slide 6 · The five-minute guardrail _(Warm-Up)_

Everyone, together, five minutes. This is the honest answer to "no restore points" and "it did something I did not expect" — the cheapest guardrail with the largest payoff, in every repo they own tomorrow. Teach ask-vs-deny while they type: deny the unrecoverable, ask the annoying — if everything asks, people stop reading, which is prompt fatigue and it kills the layer. Remote verification: "paste the refusal line Claude gave you into chat" — and the paste-over-the-file failure shows up as "seed.json rule gone"; the handout has the before-state and names settings.local.json.

~5 min.

## Slide 7 · The hook already in your repo _(Layer 2)_

The message structure is the teaching point: BLOCKED / Why / Instead / Done means. A guardrail that only says no makes the agent guess, and it guesses creatively. Four lines turn a refusal into a redirection.

~3 min.

## Slide 8 · Block or nudge? Decide, do not default _(Severity)_

New material for most of the room. The nudge shape (PostToolUse + exit 2) is genuinely useful and almost nobody knows it: the edit lands, and Claude is told to fix it. Name the taxonomy refinement explicitly — mechanical, PARTLY, fuzzy — because their 2.a lists were binary and the middle bucket is where their hook will live.

~3 min.

## Slide 9 · An unverified guardrail is a belief _(Verification)_

Insist on this in the exercise. The usual death of a guardrail is not failing to block — it is blocking something legitimate on day three, getting disabled, and taking the layer with it. The evidence standard matters: a claim without the refusal text is not verified.

~2 min.

## Slide 10 · The bypass you write down _(Layer 5)_

The most senior idea in the block. The bypass rate is a signal about the RULE, not about discipline — if people constantly go around it, the rule is mis-scoped. That reframe lands well with leads.

~2 min.

## Slide 11 · Taught today, built at scale _(Layers 3–5)_

Sanitised exemplar — no client, product, or domain detail; if asked, "another engagement." The proportion is the insight: nine validators sounds heavy until you see the bypass is a single comment convention.

~2 min.

## Slide 12 · Rules about AI are just rules. _(The Meta-Case)_

Ninety seconds; it collapses a distinction people assume exists. If the room heads toward "we need an AI policy", the answer is: you need an NFR, and you wrote one last week.

~2 min.

## Slide 13 · Demo — build along, one guardrail

Transition. Two instructions: build along in your own copy as I go, and watch where the time goes — I will spend more time verifying than writing.

## Slide 14 · Seven steps — build along on screen _(Demo · The Steps)_

Run the demo AGAINST this slide — call the step number as you go so anyone who drops can rejoin; on Meet nobody can glance at a neighbour's screen.

COMMON QUESTIONS

Q: "Why three layers for one rule?"
A: they fail differently — the line informs a reader, the deny stops the common case cheaply, the hook explains itself when it fires; you will not always build all three.

Q: "My settings.json already has a hooks block — another one?"
A: no — add a second entry to the EXISTING PreToolUse array (the handout shows the merged shape).

Q: "Does the hook slow every edit?"
A: it runs per matched tool call, milliseconds; if a hook is slow, that is the hook's fault, not the mechanism.

Q: "Hook never fires?"
A: nine times in ten, no new session — hooks load at session start; the rest: matcher or path normalisation (Windows backslashes).

~3 min.

## Slide 15 · Read-only database unless approved _(Demo · The Rule)_

Deliberately parallel to the exhibit they just read — the shape is the point, not this rule. Make the two-rules distinction explicitly; the review agent flagged it as the most likely novice confusion of the block.

~3 min.

## Slide 16 · Twenty lines, no dependencies _(Demo · The Check)_

Type it live if the room is comfortable; paste if behind. Say the Windows path normalisation out loud — it is the bug every cohort hits and why the hook is Node, not shell. Then register it together and restart sessions — the forgotten-restart is the "my hook never fires" stuck point.

~5 min.

## Slide 17 · Both directions, then the bypass _(Demo · Verify)_

Slow down here and say why: this is the step people skip. Both tests visibly. If your own hook false-positives live, that is a gift — work it through on the shared screen.

~5 min.

## Slide 18 · Checkpoint 1 _(Checkpoint)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

Chat is the room-walk: refusal texts land where you can read them, and silence from a name is your signal to check in (Slack, not the whole call). Common failure: a path check that also catches db.json.example or a test fixture. Fast finishers: read protect-seed.js and diff the two hooks' messages.

~3 min.

## Slide 19 · The same pattern, somewhere you will recognise _(Your Stack)_

Three minutes, no hands-on. Why it is here: their real world is SQL Server and stored procedures, and the pattern they just built on a JSON file needs to visibly transfer. The false-positive row is the most valuable one — it is the PARTLY tag from the severity slide, in the wild. The takeaway card now carries a SECOND worked example ("all backends must use SQLite" — ADR for the why, NFR for the must + CI dependency scan, deny rule on npm install pg*), whose org-wide reach also previews the hand-off two slides from now. Point at it; do not teach it.

~3 min.

## Slide 20 · The hook — enforce what you wrote _(Your Clause · 1 Of 3)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

FRAME THE EXERCISE FIRST, one breath, before any mechanics — this is 2.a's wire-in promise landing: last week the rule reached layer 1 (informs); today it moves to layers 2 and 4 (enforce) — but only PARTIALLY, per clause, and that is by design, not failure. The mechanical clause ("ships with a test in the same PR") gets a nudge and a gate. The fuzzy clause ("the test failed first" — the one that catches fix B, the most important line in their NFR) cannot be enforced by anything built today; it ends in the residue column as a recorded decision with a name. Enforcement is a PER-CLAUSE property of a rule — the same per-clause lesson as 2.a's Checked-by line, now with teeth. Said up front, the residue column becomes the point of the exercise instead of its leftovers. Remote circulation = one whole-call chat nudge at ~7 min ("what does your allow case replay?" — no answer means verification is about to be skipped) + Slack for 1:1s.

WHAT EACH TARGET IS (rescue detail in the teachers guide, never on screen): default = PostToolUse nudge when an edited server/src *.ts has no sibling *.test.ts; store-boundary choice = PreToolUse block when a written file outside repositories/ contains an import of db/store.

COMMON QUESTIONS

Q: "My clause is fuzzy — what do I build?"
A: build the mechanical core of your list instead, and your fuzzy clause becomes a residue decision; nobody builds nothing.

Q: "Block or nudge for mine?"
A: run the PARTLY test — if your check can false-positive, nudge; write the reason down either way.

Q: "Do I need the hook AND the gate?"
A: yes — different audiences: the hook stops the agent, the gate stops anyone.

~15 min.

## Slide 21 · Checkpoint 2 _(Checkpoint)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

Gate hard here: the CI-gate step depends on the clause being genuinely mechanical, which this checkpoint proves. Fast finishers: the policy-bundle stretch, or offer an allow-case replay to whoever asks in Slack.

~2 min.

## Slide 22 · The same clause at merge time _(Your Clause · 2 Of 3)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

THE GOTCHA that will eat this step remotely: the gate runs on pull_request — a student who commits to their branch and waits will conclude it does not work. Say it before they start: push, open a draft PR, watch the check.

CONCRETE CORES (rescue detail; guide has the code): test-discipline = fail if the PR diff touches server/src/** with no *.test.ts in the diff; store-boundary = fail if grep finds db/store imports outside repositories/. The docs-only-PR question is where block-vs-warn becomes real — do not answer it for them. Residue is an acceptance criterion: "the test must have failed first" needs a named owner or an explicit drop, back in the 2.a NFR.

~10 min.

## Slide 23 · Point the reviewer at your standards _(Your Clause · 3 Of 3)_

Short and satisfying: the reviewer quoting their own NFR back at them is the moment governance stops being paperwork. The giget fallback matters — copies made before Jul 29 lack the agents folder.

COMMON QUESTIONS

Q: "How do I run it?"
A: ask Claude to "review my branch with the taskboard-code-reviewer agent", or @-mention the agent; it reads CLAUDE.md, then your docs, then the diff.

Q: "It did not cite my NFR."
A: check your doc is in its process list AND your clause applies to something in the diff — a reviewer with nothing to catch cites nothing.

Q: "Report in chat?"
A: paste one finding that cites your standard — that is the loop-closing moment, share it.

~4 min.

## Slide 24 · Let us compare _(Review)_

Push hardest on the residue question — it reveals whether the lesson landed. A PR with an empty residue column has either a trivial rule or has not looked.

~10 min.

## Slide 25 · The sixth artifact, and it is yours _(Hand-Off)_

Three minutes; framing over content. The guide is written for a team new to governance — it opens with the four terms, Crawl is one person's afternoon, and every tool option carries its trap named. Callback: this handout reached you as one canonical repo plus a pointer — crawl — and giget if you ran it, most of walk. Done = the template filled: rung, FIRST MOVE, and an owner who is a person. The two fields people skip are Owner and Not-doing-yet, and they are the two that matter. "We will decide later" is the only answer that costs more than acting.

~3 min.

## Slide 26 · What leaves this room _(Wrap & Retro)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

Close on the deny/ask list — the thing every person applies tomorrow regardless of how far they got. Read the ship checklist as one list; it mirrors the handout exactly. Retro as a chat waterfall: type, hold, 3-2-1 send.

COPY THE CHAT BEFORE ENDING THE CALL — Meet deletes it, and the refusal texts + retro lines feed the capture entry. INSTRUCTOR, within 24h: file the lab-capture entry (AI-Transformation-Playbook/04-labs/lab-capture-template.md) — outcomes, stuck points, timings, Format B observations.

~5 min.
