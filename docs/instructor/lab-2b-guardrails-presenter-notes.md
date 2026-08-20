# Lab 2.b — Guardrails, and Making Standards Travel · Presenter Notes

Speaker notes for `lab-2b-guardrails.pptx` (the same text is attached to each slide's Notes pane).

> **Calibrated against the Lab 1.b room feedback (2026-08-12), and restructured from team-lead
> feedback (2026-08-18): shorter demos told as a timeline (authoring → commit → merge), the git
> hook taught first as the vehicle for Claude hooks, and a table-talk beat. Google Meet delivery;
> tables are physical rooms on the participants' side.** Nothing remains provisional.

## Slide 1 · Guardrails, and Making Standards Travel

WHAT THIS SLIDE TEACHES: the session's promise — by the end, each person has given a written rule teeth and proven it in both directions.

Welcome to 2.b. The challenge in one breath: pick one of this repo's written rules and give it teeth — a hook that stops (or nudges) the agent while it writes, and a CI gate that stops anyone at merge time, both verified in both directions.

The win today is simple and real: a rule with teeth, proven to fire and proven to stay quiet.

~1 min.

## Slide 2 · Two hours, hands-on _(Today)_

WHAT THIS SLIDE TEACHES: the shape of the two hours and the ground rules — table talk is standing permission, checkpoints are individual, evidence lives in chat.

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

ANNOUNCE THE ADJUSTMENT as deliberate, not an apology: "we restructured this session from your feedback — shorter demos, the guardrails you already run, and time to talk at your tables."

Then the standing permission: side discussion at the tables is encouraged all session — mute unless addressing the call. The only structured moments are the checkpoints, which stay individual: everyone pastes their own evidence in chat.

The blocks sum to ~107 — the slack is deliberate; protect it for verification, which is the step people skip.

Prereq check right now, in chat: "type HOOKS-DONE if you did the Hooks lesson." Anyone missing it follows along on the shared screen for the build sections and catches up async per the handout (Slack for 1:1 help — Meet chat has no DMs).

Assessment disclosure: same rubric, and today's hook or gate is also the Framework Practitioner artifact. Helping your table mates counts FOR you on the Independence dimension, not against.

~2 min.

## Slide 3 · The law already on the books _(Recap)_

WHAT THIS SLIDE TEACHES: this repo already has written rules and zero enforcement — the gap between written and enforced is the session's entire subject.

[CALIBRATED from review, 2026-08-19: reworked — no prior NFR assumed; the repo's own written rules are the stimulus]

Fast. The only new idea is the last bullet — the premise of the block.

These three documents are also the MENU the exercise picks from later — say so: "remember these; you will choose one to enforce this afternoon."

~2 min.

## Slide 4 · The model layer cannot be the control. _(The Premise)_

WHAT THIS SLIDE TEACHES: why enforcement cannot live in the model — models are persuadable, so any rule that matters needs a deterministic check. Plus the session's three terms: guardrail, hook, policy.

Industry consensus, not our opinion — say so.

Landing line (spoken): because the check does not depend on which model ran, it survives a model upgrade. The phrase: "model-independent governance."

Connect to the pain the team named in the interviews — the agent agreeing too easily, ignoring stated patterns. This is the failure mode it addresses.

~3 min.

## Slide 5 · Five layers of enforcement _(The Map)_

WHAT THIS SLIDE TEACHES: the five enforcement layers, who each one holds against, and today's route through them as a timeline: authoring → commit → merge.

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

The honesty about this repo matters — it models the behaviour we want. Note the build framing precisely: layers 1–2 plus one layer-4 gate; a governance doc that overstates its own coverage is the failure mode.

Layer 5 is not a gap in the others — it is what makes them credible.

SAY THE ORDER out loud: we meet layer 3 first, because the room already runs a commit-time hook at work — the familiar one explains the new one.

~3 min.

## Slide 6 · Where organizations start, and where this grows _(Where This Grows)_

WHAT THIS SLIDE TEACHES: starting with almost nothing is normal — guardrails accrete one earned rule at a time, and today's artifacts are the first steps on that road.

[CALIBRATED from review, 2026-08-19: re-toned twice — org-level now; the earlier framings read as a maturity gap aimed at the room]

The table describes ORGANIZATIONS in general, deliberately. If someone says "that starting column is us", the answer is: "that's everyone — it's the normal starting point, and it's why this session exists."

Sanitised exemplar — no client, product, or domain detail; if asked, "another engagement." TONE RULE: never "they have it, you don't" — aspiration, not gap.

The proportion is still the insight: nine validators sounds heavy until you see the bypass is a single comment convention — governance is not volume, it accretes one earned rule at a time.

If the room heads toward "we need an AI policy": you need an NFR — rules about AI are just rules.

~2 min.

## Slide 7 · The five-minute guardrail _(Warm-Up)_

WHAT THIS SLIDE TEACHES: the cheapest guardrail that exists — three permission verdicts (allow / ask / deny) in settings.json. Config, not code, and usable in every repo they own tomorrow.

Everyone, together, five minutes. This is the honest answer to "no restore points" and "it did something I did not expect."

Teach ask-vs-deny while they type: deny the unrecoverable, ask the annoying. If everything asks, people stop reading — prompt fatigue kills the layer.

The allow array is shown EMPTY on purpose: it is the third verdict's home, where you later promote the commands you never want to be asked about (npm test, npm run lint). Empty is the right day-one default — entries are earned.

Remote verification: "paste the refusal line Claude gave you into chat." The paste-over-the-file failure shows up as "seed.json rule gone" — the handout has the before-state and names settings.local.json.

This is config, not a hook — the hook arc starts on the next slide, at the layer they already know.

~5 min.

## Slide 8 · The hook you already know — watch one get built _(Demo · Layer 3)_

WHAT THIS SLIDE TEACHES: the hook anatomy, on the layer the room already runs — an event fires a script, and the exit code decides. Plus: every layer has a bypass, and hooks work identically on every OS.

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

INSTRUCTOR-ONLY DEMO — the room watches; their replay is docs/labs/lab-2b-demo-2-git-hook-walkthrough.md, and adding it to their copy is a stretch. Run it against this slide; call row numbers.

ROW 3 IS THE CROSS-PLATFORM BEAT (verified empirically 2026-08-19: the hook fires with the exec bit stripped). Git runs husky's SHIM — core.hooksPath is .husky/_ — and the shim runs your file as an ARGUMENT to sh (sh -e), so the OS never executes the file: no chmod, no extension, no shebang, on any OS. On Windows, git ships its own sh plus grep and head.

ROW 4 IS THE ANATOMY — say it out loud, slowly: AN EVENT FIRED A SCRIPT, AND THE EXIT CODE DECIDED. That sentence is the whole hook concept, and it repeats unchanged at authoring time and merge time.

ROW 6 IS THE LAYER-5 TEACHING: there is always a bypass; undocumented bypasses are the real governance hole — not the missing gate, the escape hatch nobody wrote down. Name the approver ("APPROVED-X: <reason + who>" beats a silent override), and count how often it fires — a bypass used weekly is a rule that is wrong, not a team that is lax.

COMMON QUESTIONS

Q: "Why not commitlint?"
A: commitlint is the scaled version — a dependency that parses properly and handles rule sets; five lines of grep teach the anatomy, and you graduate when the rule set grows.

Q: "We already run husky — start over?"
A: no — add a new file next to your existing pre-commit; hooks are per-event files, they compose.

Q: "Does --no-verify defeat the whole thing?"
A: locally, yes — that is exactly why the same rule runs again at merge time, where --no-verify does not exist.

Q: "Do the agent's commits hit this hook?"
A: yes — the agent runs git like anyone; the layers stack, they do not divide by author.

Q: "Windows — no .ps1 extension?"
A: hooks never go through Windows program resolution — git.exe finds and runs them itself, with the shell it ships; extension and exec bit are irrelevant on every OS, and PowerShell aliases cp so even the copy line is identical.

Q: "So chmod is NEVER needed?"
A: not with husky — RAW git hooks (.git/hooks, no husky) are executed directly by git; there chmod +x IS required, and the bit travels to teammates via git update-index --chmod=+x. The walkthrough carries that nuance.

Q: "Every commit fails with npm error Missing script: test?"
A: that is husky's STARTER pre-commit (npm test), not your hook — pre-commit runs BEFORE commit-msg, so it blocks first; delete it or add a test script (observed live on a real Windows repo, 2026-08-19).

Q: "Every commit blocked with command not found, code 127, or a syntax error?"
A: the hook file has Windows CRLF line endings — an editor default, or core.autocrlf converting at checkout; save as LF (VS Code: click CRLF in the status bar). Verified: a CRLF hook FAILS CLOSED — it blocks even valid commits.

~8 min.

## Slide 9 · Same anatomy, three moments in time _(The Bridge)_

WHAT THIS SLIDE TEACHES: git hook, Claude hook, and CI gate are ONE concept at three moments in time — this table is the session's whole mental model.

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

THIS SLIDE IS THE VEHICLE — the git-hook demo exists so this table can make the Claude hook a variation on something the room already runs, not a new thing.

Say the sentence: "everything you just watched is about to happen again — the event moves from your commit to the agent's tool call."

Walk ONE COLUMN at a time, not one row: the commit column is what they just saw; the authoring column is the demo they are about to build; the merge column is the gate they wire in the exercise.

The protect-seed note is the callback: they were blocked by a Claude hook in Lab 1 without being told the word.

COMMON QUESTIONS

Q: "If CI catches it anyway, why the Claude hook?"
A: cost of the catch — at authoring time the fix is one message to an agent mid-task; at merge time it is a failed build after the work felt done. Same rule, cheaper moment.

Q: "Which layer do I pick for a new rule?"
A: the cheapest one that holds against the audience you are worried about — that question is the table-talk prompt coming shortly.

~3 min.

## Slide 10 · Claude hooks — the sixty-second refresher _(Refresher · Layer 2)_

WHAT THIS SLIDE TEACHES: the complete Claude-hook contract — events, matcher, JSON on stdin, exit codes, session-start loading — and the exact registration JSON the exercise reuses.

[CALIBRATED from review, 2026-08-19: refresher added — the prereq Hooks lesson is weeks old for most of the room, and the severity slide assumes its vocabulary]

Sixty to ninety seconds down the left column, then point at the JSON: it is the SAME shape the handout gives for registering their exercise hook, shown here wired to protect-seed.js — the hook that blocked them in Lab 1.

This is a REFRESHER, not first teaching — anyone who missed the Hooks lesson gets their teaching in the build-along.

Other events exist (SessionStart, UserPromptSubmit, Stop) — name them only if asked; today is the two tool-call events.

The exit-code bullet hands off to the next slide: WHICH event you register on is the severity decision. The new-session bullet previews the #1 stuck point of the exercise.

~3 min.

## Slide 11 · Block or nudge? Decide, do not default _(Severity)_

WHAT THIS SLIDE TEACHES: choosing WHICH event to register on IS the severity decision — PreToolUse blocks, PostToolUse nudges — and heuristic rules should nudge, because a false-positive block gets the hook disabled.

The room now knows both hook kinds, so this reads as the Claude-side refinement of the anatomy: git hooks have one lever (block or not); Claude hooks add WHICH EVENT, and that choice is the severity.

The nudge shape (PostToolUse + exit 2) is genuinely useful and almost nobody knows it: the edit lands, and Claude is told to fix it.

WORKED POSTTOOLUSE EXAMPLE — say it out loud (it is on the exercise menu, so this foreshadows): a PostToolUse hook on Edit|Write watches for an edited server/src *.ts with no sibling *.test.ts. The agent writes todos.service.ts — the edit LANDS, PostToolUse cannot stop it — the hook exits 2, and its stderr goes straight to the agent: "NOTE: todos.service.ts has no sibling test — add or extend todos.service.test.ts before opening the PR." The agent reads that mid-task and writes the test without being asked.

Why nudge, not block? The rule is PARTLY — a comment fix or a rename would false-positive a block; the nudge informs without ever interrupting legitimate work.

Name the taxonomy explicitly — mechanical, PARTLY, fuzzy — because most of the exercise menu lives in the middle bucket, and that is where their hook will live too.

~3 min.

## Slide 12 · What rule would you add next? _(Table Talk)_

WHAT THIS SLIDE TEACHES: nothing new — it converts the session into their backlog. Each table names one rule from their own repo and places it on the timeline they just learned.

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

THE STRUCTURED BEAT the tables asked for: you go on mute and watch chat; a reporter per table types the line; solo attendees answer individually.

If the team sends a topics list before the session, seed it here by reading two items aloud as candidate rules.

Silence from a table → Slack someone at it, never a call-out on the open call.

The chat lines are tomorrow's guardrail backlog — say so, and copy the chat before call end (it feeds the capture entry too). This beat doubles as the mental break before the 19-minute build-along.

Expected shapes: formatting/lint rules land at commit; test-discipline and boundary rules split between authoring-nudge and merge-gate — both defensible; ask "who are you holding it against?"

~4 min.

## Slide 13 · Demo — build along, one guardrail

WHAT THIS SLIDE TEACHES: transition only — the build-along is the git-hook concept moved to authoring time, and verification will take longer than writing.

Two instructions for the room: build along in your own copy as I go, and watch where the time goes — I will spend more time verifying than writing.

Frame with the bridge: same anatomy as the git hook you just watched; the event is now the agent's tool call, the message file is now JSON on stdin, and non-zero is now exit 2.

## Slide 14 · Seven steps — build along on screen _(Demo · The Steps)_

WHAT THIS SLIDE TEACHES: the demo's seven-step route — the rejoin map you narrate against while executing the steps across the next three slides — and that steps 6–7 (verify both directions) are the point, not the code.

HOW TO RUN IT: show this map for the ~3 minutes here, then ADVANCE — the rule (next slide), the code (the check slide), and verification (the verify slide) carry the demo while you execute the steps live. As you perform each step, SAY ITS NUMBER — on Meet nobody can glance at a neighbour's screen (though tables can — let them), so the number is the rejoin point; flip back to this map whenever the room drifts, and the walkthrough mirrors these rows 1:1.

STEP 6 IS THE TWO-MESSAGE BEAT and the demo's strongest minute. Permission rules evaluate BEFORE PreToolUse hooks (verified live, 2026-08-19), so the deny answers first with the generic wall; pull the two db.json deny entries, NEW session, ask again — the hook answers with the four-part signpost; restore the entries.

Say it: "the wall stops; the signpost redirects — and your rule this afternoon can ONLY be a hook, because deny rules match paths and hooks run logic."

COMMON QUESTIONS

Q: "The deny already blocks db.json — why would we ever need the hook?"
A: three reasons. The deny is a WALL (generic refusal; the agent knows it was stopped, not why, so it guesses creatively) while the hook is a SIGNPOST (BLOCKED / Why / Instead / Done redirects it to the sanctioned path). Deny rules can only match paths while hooks run LOGIC — the menu rules (sibling test, import boundary) cannot be deny rules at all. And the layers fail independently — the warm-up's paste-over failure kills a deny rule silently while the hook stands.

Q: "Why three layers for one rule?"
A: they fail differently — the line informs a reader, the deny stops the common case cheaply, the hook explains itself when it fires; you will not always build all three.

Q: "My settings.json already has a hooks block — another one?"
A: no — add a second entry to the EXISTING PreToolUse array (the handout shows the merged shape).

Q: "Does the hook slow every edit?"
A: it runs per matched tool call, milliseconds; if a hook is slow, that is the hook's fault, not the mechanism.

Q: "Hook never fires?"
A: nine times in ten, no new session — hooks load at session start, the way git hooks arrive at npm install. The rest: matcher, or path normalisation (Windows backslashes).

~3 min.

## Slide 15 · Read-only database unless approved _(Demo · The Rule)_

WHAT THIS SLIDE TEACHES: the demo's target rule and the three-layer shape it gets (CLAUDE.md line → deny entry → hook) — and that it is NOT the store-boundary rule from the menu.

Deliberately parallel to protect-seed, which they met on the bridge slide and can read in the repo — the shape is the point, not this rule.

Make the two-rules distinction explicitly; a review pass flagged it as the most likely novice confusion of the block.

~3 min.

## Slide 16 · Twenty lines, no dependencies _(Demo · The Check)_

WHAT THIS SLIDE TEACHES: the whole check is a few lines of plain Node — test the path, print the four-part message, exit 2. Nothing exotic.

SAY THE ELISION FIRST: the slide shows only the CHECK — the stdin-parsing plumbing above it (reading the tool call's JSON into filePath) comes from the walkthrough / the skeleton, and you will type or paste the full file. The first comment line on the slide marks the seam.

Type it live if the room is comfortable; paste if behind.

Call back the commit-msg hook as you type: same read-input → test → refuse shape — the input is JSON on stdin instead of a message file, and the block is exit 2, because exit codes are the contract everywhere.

Say the Windows path normalisation out loud — it is the bug every cohort hits and why the hook is Node, not shell.

Then register it together and restart sessions — the forgotten restart is the "my hook never fires" stuck point.

~5 min.

## Slide 17 · Verify both directions, then the bypass _(Demo · Verify)_

WHAT THIS SLIDE TEACHES: a guardrail fails two ways (never blocks / blocks real work), so verification is two-sided — and the bypass is the rule's legal route, written down, never "disable the hook."

[CALIBRATED from review, 2026-08-19: expanded — the old cards were fragments that assumed the story]

SAY THE FRAME FIRST, pointing at the lede: two failure modes, so two tests — an unverified guardrail is a belief.

STEP 6 IS THE TWO-MESSAGE BEAT (slide 14 row 6): first ask — the DENY answers, the generic wall; pull the two db.json deny entries, NEW session, ask again — the HOOK answers, BLOCKED/Why/Instead/Done, the signpost; restore the entries. The hook's text is the evidence they save into the PR — that is what "demonstrated in a live agent run" means.

STEP 7 IS THE HALF EVERYONE SKIPS — say why: novices prove the guardrail blocks and stop, but the killer failure is the FALSE POSITIVE discovered on Friday — it blocks legitimate work, someone disables the hook, and the layer dies. Silence + a green suite is a real test result, not an absence of one. Re-verify BOTH directions after every narrowing, because fixing a false positive often reopens the hole.

THE BYPASS CARD is not a third verification — it is writing down the LEGAL ROUTE for the thing the rule blocks: data changes happen by editing seed.json in a PR flagged to the instructor, then npm run reset-db. Callback to the git demo: every layer has an escape hatch (--no-verify there); an undocumented one is the real governance hole — so one line in CLAUDE.md next to the rule, with the approver named.

If your own hook false-positives live, that is a gift — work it through on the shared screen.

~5 min.

## Slide 18 · Checkpoint 1 _(Checkpoint)_

WHAT THIS SLIDE TEACHES: verification is a gate — everyone proves BOTH directions in their own copy before the room advances, and the evidence is pasted, not claimed.

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

Chat is the room-walk: refusal texts land where you can read them, and silence from a name is your signal to check in (Slack, not the whole call — though a table often fixes its own straggler before you get there; give it a beat).

Common failure: a path check that also catches db.json.example or a test fixture.

Fast finishers: read protect-seed.js and diff the two hooks' messages.

~3 min.

## Slide 19 · Pick a rule — the law is already written _(Your Rule · Pick One)_

WHAT THIS SLIDE TEACHES: the exercise is choosing to enforce a rule that already exists — four real, unenforced rules from the repo's own docs, and any pick is right.

[CALIBRATED from review, 2026-08-19: exercise reworked — pick any written rule; no NFR assumed, no default named]

PURE CHOICE on purpose — read all four rows aloud, then give the tables a quiet minute to pick. Choosing at the table together is fine; clustering on one rule is fine.

Every row traces to a doc the recap named — say the callback: "these are the laws from the recap slide; you are hiring the police."

Rescue detail per rule is in the teachers guide, never on screen.

If someone brings their own rule, one filter only: can a script detect it from a file path or file content? Then build it.

~2 min.

## Slide 20 · The hook — give your rule teeth _(Your Rule · Build It)_

WHAT THIS SLIDE TEACHES: the exercise itself — skeleton, register, new session, verify both directions. The plumbing is given; the rule is theirs.

[CALIBRATED from review, 2026-08-19: simplified — build the hook, verify it, done; no severity essays, no residue ceremony]

FRAME IT IN ONE BREATH: the rule is already written; you are adding the police.

Table talk during the build is welcome — compare approaches, debug a neighbour — but the artifact is individual: your rule, your hook, your evidence.

Remote circulation: one whole-call chat nudge at ~7 min — "what does your allow case replay?" No answer means verification is about to be skipped. Slack for 1:1s.

Rescue detail per menu rule is in the teachers guide — Slack it one piece at a time, never on screen.

COMMON QUESTIONS

Q: "Torn between rules?"
A: the sibling-test nudge is the gentlest start; the store boundary is the most satisfying block.

Q: "Do I need the hook AND the gate?"
A: yes — different audiences: the hook stops the agent, the gate stops anyone.

Q: "My detection regex is imperfect."
A: that is exactly what nudges are for — an imperfect block stops real work; an imperfect nudge costs one ignorable note.

~15 min.

## Slide 21 · Checkpoint 2 _(Checkpoint)_

WHAT THIS SLIDE TEACHES: the same gate as Checkpoint 1, now on their own rule — fires on the violation, silent on legitimate work, evidence in the PR.

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

Gate hard here: the CI-gate step reuses the same detection, which this checkpoint proves works.

Fast finishers: build a second rule from the menu, or offer an allow-case replay to whoever asks in Slack.

~2 min.

## Slide 22 · The same rule, written again — for GitHub _(Your Rule · Merge Time)_

WHAT THIS SLIDE TEACHES: the gate is a SECOND program enforcing the same rule — GitHub cannot run the Claude hook (no agent runs there), so the check is re-written as a grep that GitHub runs on every PR, binding everyone.

[CALIBRATED from review, 2026-08-19: rebuilt — "the same rule at merge time" let students believe their hook travels to GitHub; the second-program mechanism and the directed steps are now explicit]

SAY THE MECHANISM FIRST, in these words: "your hook is a program that Claude Code runs on your machine when the agent writes. GitHub has no Claude Code and no agent — nothing there can fire it. So we write the same CHECK a second time, as a grep inside a workflow file, and GitHub runs THAT on every pull request."

The spoken contrast, if faces look puzzled — two programs, one rule: check-convention.js is executed by Claude Code on their machine, triggered by the agent's tool call, looking at the one file being written; governance.yml is executed by GitHub Actions on GitHub's servers, triggered by a PR opening or updating, looking at the PR's whole diff.

Run the exercise against the rows — call row numbers, the house pattern. Say row 3 BEFORE they start: the gate runs on pull_request; a student who commits and waits will conclude it does not work.

CONCRETE CORES for all four menu rules are in the teachers guide (rescue detail — Slack, never on screen). Each is a diff-scoped grep, so pre-existing code never trips it.

MATURITY POINTER, only if asked how the two stay in sync: at scale you extract ONE rule module that both enforcers call — "one rule module, two enforcement points" (the takeaway card works it through). Today we write it twice because each check is three lines.

If someone notices their gate fires on a docs-only PR: nice catch — a path filter is the one-line fix. Do not make it a required decision; keep the momentum on build-and-verify.

DIVISION OF LABOUR aside, if it comes up: lint, typecheck, and tests already run on every PR here — deterministic guardrails have held this repo all along, and the repo's review agent is explicitly told NOT to re-report what they catch. Non-AI guardrails are the floor; the AI layer spends itself on what only it can see. Their own Actions pipeline is this same layer, built in-house.

The written-but-never-run gap hunt (format:check) lives in the demo-4 walkthrough for self-guided replay — it is no longer a live beat.

~10 min.

## Slide 23 · Checkpoint 3 _(Checkpoint)_

WHAT THIS SLIDE TEACHES: merge-time evidence — the red-then-green run URL is this layer's version of the hook's pasted text.

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

The usual stragglers: the draft-PR gotcha (a pushed branch alone runs nothing) and the shallow-clone diff failure (fetch-depth: 0).

CI runs take a minute or two — use the wait to skim the chat links as they land.

Fast finishers: a second menu rule, or the telemetry stretch from the handout's Stretch list (count how often the gate fires vs is bypassed).

~2 min.

## Slide 24 · Let us compare _(Review)_

WHAT THIS SLIDE TEACHES: cross-pollination — the room compares picks, false positives, and severity choices, and each person leaves naming a rule for their own repo.

[CALIBRATED from review, 2026-08-19: questions reworked for the pick-a-rule exercise]

Push hardest on the false-positive question — it reveals whether anyone actually ran the allow case.

The last question bridges to the table-talk backlog from earlier — pull those chat lines back up if the room stalls.

If a table had a good argument during the build, invite THAT to the mic — a disagreement about severity is better review material than a working demo.

~10 min.

## Slide 25 · The sixth artifact, and it is yours _(Hand-Off)_

WHAT THIS SLIDE TEACHES: one guardrail in one repo does not govern a team — how a standard reaches EVERY repo is itself an artifact, and the team (not the instructor) must choose its rung and its owner.

Three minutes; framing over content. The guide is written for a team new to governance — it opens with the four terms, Crawl is about thirty minutes of one person's time (matching the slide), and every tool option carries its trap named.

Callback: this handout reached you as one canonical repo plus a pointer — crawl — and giget if you ran it, most of walk.

Done = the template filled: rung, FIRST MOVE, and an owner who is a person. The two fields people skip are Owner and Not-doing-yet, and they are the two that matter. "We will decide later" is the only answer that costs more than acting.

IF AI MEMORY SERVICES COME UP (Mem0, Zep, OpenMemory — or Claude Code's own auto-memory): they are an emerging DISTRIBUTION channel, not an enforcement layer — a shared memory can make team conventions ambient across sessions and repos, which is attractive at the run rung, but recalled memory is layer 1: it informs, it never enforces, and it recalls probabilistically. Two honest caveats: provenance and currency are harder to audit than a pinned file (which copy is authoritative? when did it change?), so if the team adopts one, the standard's HOME stays the governance repo and memory is a projection of it; and the enforcing layers — hooks, gates — still need the deterministic files either way. Good fit: preferences and recurring context; wrong fit: the law.

~3 min.

## Slide 26 · What leaves this room _(Wrap & Retro)_

WHAT THIS SLIDE TEACHES: what must be in each PR before leaving (the checklist and the reflection note), plus the retro — and the instructor's own capture duties.

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

Close on the allow/ask/deny list — the thing every person applies tomorrow regardless of how far they got.

Read the ship checklist as one list; it mirrors the handout exactly.

Retro as a chat waterfall: type, hold, 3-2-1 send.

COPY THE CHAT BEFORE ENDING THE CALL — Meet deletes it, and the refusal texts + gate run URLs + table-talk lines + retro lines feed the capture entry.

INSTRUCTOR, within 24h: file the lab-capture entry (AI-Transformation-Playbook/04-labs/lab-capture-template.md) — outcomes, stuck points, timings, and the interactive-format observations (table talk, git-hook-first bridge): this session is the validation data point for that variant.

~5 min.

