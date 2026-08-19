# Lab 2.b — Guardrails, and Making Standards Travel · Presenter Notes

Speaker notes for `lab-2b-guardrails.pptx` (the same text is attached to each slide's Notes pane).

> **Calibrated against the Lab 1.b room feedback (2026-08-12), and restructured from team-lead
> feedback (2026-08-18): shorter demos told as a timeline (authoring → commit → merge), the git
> hook taught first as the vehicle for Claude hooks, and a table-talk beat. Google Meet delivery;
> tables are physical rooms on the participants' side.** Nothing remains provisional.

## Slide 1 · Guardrails, and Making Standards Travel

Welcome to 2.b. The challenge in one breath: pick one of this repo's written rules and give it teeth — a hook that stops (or nudges) the agent while it writes, and a CI gate that stops anyone at merge time, both verified in both directions. The win today is simple and real: a rule with teeth, proven to fire and proven to stay quiet.

~1 min.

## Slide 2 · Two hours, hands-on _(Today)_

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

ANNOUNCE THE ADJUSTMENT as deliberate, not an apology: "we restructured this session from your feedback — shorter demos, the guardrails you already run, and time to talk at your tables." Then the standing permission: side discussion at the tables is encouraged all session — mute unless addressing the call; the only structured moments are the checkpoints, which stay individual (paste your own evidence in chat). The blocks sum to ~110 — the slack is deliberate; protect it for verification, which is the step people skip. Prereq check right now, in chat: "type HOOKS-DONE if you did the Hooks lesson" — anyone missing it follows along on the shared screen for the build sections and catches up async per the handout (Slack for 1:1 help; Meet chat has no DMs). Assessment disclosure: same rubric, and today's hook or gate is also the Framework Practitioner artifact; helping your table mates counts FOR you on the Independence dimension, not against.

~2 min.

## Slide 3 · The law already on the books _(Recap)_

[CALIBRATED from review, 2026-08-19: reworked — no prior NFR assumed; the repo's own written rules are the stimulus]

Fast. The only new idea is the last bullet — the premise of the block. These three documents are also the MENU the exercise picks from later — say so: "remember these; you will choose one to enforce this afternoon."

~2 min.

## Slide 4 · The model layer cannot be the control. _(The Premise)_

Industry consensus, not our opinion — say so. Landing line (spoken): because the check does not depend on which model ran, it survives a model upgrade. The phrase: "model-independent governance." Connect to their own interview complaints about the agent being a yes-man and ignoring stated patterns — this is the failure mode it addresses.

~3 min.

## Slide 5 · Five layers of enforcement _(The Map)_

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

The honesty about this repo matters — it models the behaviour we want. Note the build framing precisely: layers 1–2 plus one layer-4 gate; a governance doc that overstates its own coverage is the failure mode. Layer 5 is not a gap in the others — it is what makes them credible.

SAY THE ORDER out loud: we meet layer 3 first, because the room already runs a commit-time hook at work — the familiar one explains the new one.

~3 min.

## Slide 6 · Where organizations start, and where this grows _(Where This Grows)_

[CALIBRATED from review, 2026-08-19: re-toned twice — org-level now; the earlier framings read as a maturity gap aimed at the room]

The table describes ORGANIZATIONS in general, deliberately — if someone says "that starting column is us", the answer is "that's everyone; it's the normal starting point, and it's why this session exists." Sanitised exemplar — no client, product, or domain detail; if asked, "another engagement." TONE RULE: never "they have it, you don't" — aspiration, not gap. The proportion is still the insight: nine validators sounds heavy until you see the bypass is a single comment convention — governance is not volume, it accretes one earned rule at a time. If the room heads toward "we need an AI policy", the answer is you need an NFR, and you wrote one last week.

~2 min.

## Slide 7 · The five-minute guardrail _(Warm-Up)_

Everyone, together, five minutes. This is the honest answer to "no restore points" and "it did something I did not expect" — the cheapest guardrail with the largest payoff, in every repo they own tomorrow. Teach ask-vs-deny while they type: deny the unrecoverable, ask the annoying — if everything asks, people stop reading, which is prompt fatigue and it kills the layer. The allow array is shown EMPTY on purpose: it is the third verdict's home — where you later promote the commands you never want to be asked about (npm test, npm run lint) — and empty is the right day-one default; earn entries into it. Remote verification: "paste the refusal line Claude gave you into chat" — and the paste-over-the-file failure shows up as "seed.json rule gone"; the handout has the before-state and names settings.local.json. This is config, not a hook — the hook arc starts on the next slide, at the layer they already know.

~5 min.

## Slide 8 · The hook you already know — watch one get built _(Demo · Layer 3)_

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

INSTRUCTOR-ONLY DEMO — the room watches; their replay is docs/labs/lab-2b-demo-2-git-hook-walkthrough.md and adding it to their copy is a stretch. Run it against this slide, call row numbers. Row 3 is the CROSS-PLATFORM BEAT (verified empirically 2026-08-19: the hook fires with the exec bit stripped): git runs husky's SHIM — core.hooksPath is .husky/_ — and the shim runs your file as an ARGUMENT to sh (sh -e), so the OS never executes the file: no chmod, no extension, no shebang, on any OS; on Windows, git ships its own sh plus grep and head. The anatomy to land, out loud, at row 4: AN EVENT FIRED A SCRIPT, AND THE EXIT CODE DECIDED — that sentence is the whole hook concept, and it repeats unchanged at authoring time and merge time. At row 6, the layer-5 teaching lands here now: there is always a bypass; undocumented bypasses are the real governance hole — not the missing gate, the escape hatch nobody wrote down; name the approver ("APPROVED-X: <reason + who>" beats a silent override); and count how often it fires — a bypass used weekly is a rule that is wrong, not a team that is lax.

COMMON QUESTIONS

Q: "Why not commitlint?"
A: commitlint is the grown-up version — a dependency that parses properly and scales to rule sets; five lines of grep teach the anatomy, and you graduate when the rule set grows.

Q: "We already run husky — start over?"
A: no — add a new file next to your existing pre-commit; hooks are per-event files, they compose.

Q: "Does --no-verify defeat the whole thing?"
A: locally, yes — that is exactly why the same rule runs again at merge time, where --no-verify does not exist.

Q: "Do the agent's commits hit this hook?"
A: yes — the agent runs git like anyone; the layers stack, they do not divide by author.

Q: "Windows — no .ps1 extension?"
A: hooks never go through Windows program resolution — git.exe finds and runs them itself, with the shell it ships; extension and exec bit are irrelevant on every OS, and PowerShell aliases cp so even the copy line is identical.

Q: "So chmod is NEVER needed?"
A: not with husky — RAW git hooks (.git/hooks, no husky) are executed directly by git and there chmod +x IS required, and the bit travels to teammates via git update-index --chmod=+x; the walkthrough carries that nuance.

Q: "Every commit fails with npm error Missing script: test?"
A: that is husky's STARTER pre-commit (npm test), not your hook — pre-commit runs BEFORE commit-msg, so it blocks first; delete it or add a test script (observed live on a real Windows repo, 2026-08-19).

Q: "Every commit blocked with command not found, code 127, or a syntax error?"
A: the hook file has Windows CRLF line endings — an editor default, or core.autocrlf converting at checkout; save as LF (VS Code: click CRLF in the status bar). Verified: a CRLF hook FAILS CLOSED — it blocks even valid commits.

~8 min.

## Slide 9 · Same anatomy, three moments in time _(The Bridge)_

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

THIS SLIDE IS THE VEHICLE — the git-hook demo exists so this table can make the Claude hook a variation on something the room already runs, not a new thing. Say the sentence: "everything you just watched is about to happen again — the event moves from your commit to the agent's tool call." Walk ONE column at a time, not one row: commit column is what they just saw; authoring column is the demo they are about to build; merge column is the gate they wire in the exercise. The protect-seed note is the callback: they were blocked by a Claude hook in Lab 1 without being told the word.

COMMON QUESTIONS

Q: "If CI catches it anyway, why the Claude hook?"
A: cost of the catch — at authoring time the fix is one message to an agent mid-task; at merge time it is a failed build after the work felt done. Same rule, cheaper moment.

Q: "Which layer do I pick for a new rule?"
A: the cheapest one that holds against the audience you are worried about — that question is the table-talk prompt coming shortly.

~3 min.

## Slide 10 · Claude hooks — the sixty-second refresher _(Refresher · Layer 2)_

[CALIBRATED from review, 2026-08-19: refresher added — the prereq Hooks lesson is weeks old for most of the room, and the severity slide assumes its vocabulary]

Sixty to ninety seconds down the left column, then point at the JSON: it is the SAME shape the handout gives for registering their exercise hook, shown here wired to protect-seed.js — the hook that blocked them in Lab 1. This is a REFRESHER, not first teaching — anyone who missed the Hooks lesson gets their teaching in the build-along. Other events exist (SessionStart, UserPromptSubmit, Stop) — name them only if asked; today is the two tool-call events. The exit-code bullet hands off to the next slide: WHICH event you register on is the severity decision. The new-session bullet previews the #1 stuck point of the exercise.

~3 min.

## Slide 11 · Block or nudge? Decide, do not default _(Severity)_

The room now knows both hook kinds, so this reads as the Claude-side refinement of the anatomy: git hooks have one lever (block or not); Claude hooks add WHICH EVENT, and that choice is the severity. The nudge shape (PostToolUse + exit 2) is genuinely useful and almost nobody knows it: the edit lands, and Claude is told to fix it.

WORKED POSTTOOLUSE EXAMPLE, say it out loud (it is on the exercise menu, so this foreshadows): a PostToolUse hook on Edit|Write watches for an edited server/src *.ts with no sibling *.test.ts. The agent writes todos.service.ts — the edit LANDS, PostToolUse cannot stop it — the hook exits 2, and its stderr goes straight to the agent: "NOTE: todos.service.ts has no sibling test — add or extend todos.service.test.ts before opening the PR." The agent reads that mid-task and writes the test without being asked. Why nudge, not block? The rule is PARTLY — a comment fix or a rename would false-positive a block; the nudge informs without ever interrupting legitimate work. Name the taxonomy explicitly — mechanical, PARTLY, fuzzy — because most of the exercise menu lives in the middle bucket, and that is where their hook will live too.

~3 min.

## Slide 12 · What rule would you add next? _(Table Talk)_

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

THE STRUCTURED BEAT the tables asked for — you go on mute and watch chat; a reporter per table types the line; solo attendees answer individually. If the team sends a topics list before the session, seed it here by reading two items aloud as candidate rules. Silence from a table → Slack someone at it, never a call-out on the open call. The chat lines are tomorrow's guardrail backlog — say so, and copy the chat before call end (it feeds the capture entry too). This beat doubles as the mental break before the 19-minute build-along. Expected shapes: formatting/lint rules land at commit; test-discipline and boundary rules split between authoring-nudge and merge-gate — both defensible, ask "who are you holding it against?"

~4 min.

## Slide 13 · Demo — build along, one guardrail

Transition. Two instructions: build along in your own copy as I go, and watch where the time goes — I will spend more time verifying than writing. Frame with the bridge: same anatomy as the git hook you just watched; the event is now the agent's tool call, the message file is now JSON on stdin, and non-zero is now exit 2.

## Slide 14 · Seven steps — build along on screen _(Demo · The Steps)_

Run the demo AGAINST this slide — call the step number as you go so anyone who drops can rejoin; on Meet nobody can glance at a neighbour's screen (though tables can — let them). STEP 6 IS THE TWO-MESSAGE BEAT and the demo's strongest minute — permission rules evaluate BEFORE PreToolUse hooks (verified live, 2026-08-19), so the deny answers first with the generic wall; pull the two db.json deny entries, NEW session, ask again — the hook answers with the four-part signpost; restore the entries. Say it: "the wall stops; the signpost redirects — and your clause this afternoon can ONLY be a hook, because deny rules match paths and hooks run logic."

COMMON QUESTIONS

Q: "The deny already blocks db.json — why would we ever need the hook?"
A: three reasons — the deny is a WALL (generic refusal; the agent knows it was stopped, not why, so it guesses creatively) while the hook is a SIGNPOST (BLOCKED / Why / Instead / Done redirects it to the sanctioned path); deny rules can only match paths while hooks run LOGIC — the exercise clauses (sibling test, import boundary) cannot be deny rules at all; and the layers fail independently — the warm-up's paste-over failure kills a deny rule silently while the hook stands.

Q: "Why three layers for one rule?"
A: they fail differently — the line informs a reader, the deny stops the common case cheaply, the hook explains itself when it fires; you will not always build all three.

Q: "My settings.json already has a hooks block — another one?"
A: no — add a second entry to the EXISTING PreToolUse array (the handout shows the merged shape).

Q: "Does the hook slow every edit?"
A: it runs per matched tool call, milliseconds; if a hook is slow, that is the hook's fault, not the mechanism.

Q: "Hook never fires?"
A: nine times in ten, no new session — hooks load at session start, the way git hooks arrive at npm install; the rest: matcher or path normalisation (Windows backslashes).

~3 min.

## Slide 15 · Read-only database unless approved _(Demo · The Rule)_

Deliberately parallel to protect-seed, which they met on the bridge slide and can read in the repo — the shape is the point, not this rule. Make the two-rules distinction explicitly; the review agent flagged it as the most likely novice confusion of the block.

~3 min.

## Slide 16 · Twenty lines, no dependencies _(Demo · The Check)_

Type it live if the room is comfortable; paste if behind. Call back the commit-msg hook as you type: same read-input → test → refuse shape — the input is JSON on stdin instead of a message file, and the block is exit 2 because exit codes are the contract everywhere. Say the Windows path normalisation out loud — it is the bug every cohort hits and why the hook is Node, not shell. Then register it together and restart sessions — the forgotten-restart is the "my hook never fires" stuck point.

~5 min.

## Slide 17 · Verify both directions, then the bypass _(Demo · Verify)_

[CALIBRATED from review, 2026-08-19: expanded — the old cards were fragments that assumed the story]

SAY THE FRAME FIRST, pointing at the lede: two failure modes, so two tests — an unverified guardrail is a belief. STEP 6 IS THE TWO-MESSAGE BEAT (slide 14 row 6): first ask — the DENY answers, the generic wall; pull the two db.json deny entries, NEW session, ask again — the HOOK answers, BLOCKED/Why/Instead/Done, the signpost; restore the entries. The hook's text is the evidence they save into the PR — that is what "demonstrated in a live agent run" means. STEP 7 IS THE HALF EVERYONE SKIPS — say why: novices prove the guardrail blocks and stop, but the killer failure is the FALSE POSITIVE discovered on Friday — it blocks legitimate work, someone disables the hook, and the layer dies. Silence + a green suite is a real test result, not an absence of one; and re-verify BOTH directions after every narrowing, because fixing a false positive often reopens the hole.

THE BYPASS CARD is not a third verification — it is writing down the LEGAL ROUTE for the thing the rule blocks: data changes happen by editing seed.json in a PR flagged to the instructor, then npm run reset-db. Callback to the git demo: every layer has an escape hatch (--no-verify there); an undocumented one is the real governance hole, so one line in CLAUDE.md next to the rule, with the approver named. If your own hook false-positives live, that is a gift — work it through on the shared screen.

~5 min.

## Slide 18 · Checkpoint 1 _(Checkpoint)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

Chat is the room-walk: refusal texts land where you can read them, and silence from a name is your signal to check in (Slack, not the whole call — though a table often fixes its own straggler before you get there; give it a beat). Common failure: a path check that also catches db.json.example or a test fixture. Fast finishers: read protect-seed.js and diff the two hooks' messages.

~3 min.

## Slide 19 · Pick a rule — the law is already written _(Your Rule · Pick One)_

[CALIBRATED from review, 2026-08-19: exercise reworked — pick any written rule; no NFR assumed, no default named]

PURE CHOICE on purpose — read all four rows aloud, then give the tables a quiet minute to pick; choosing at the table together is fine, clustering on one rule is fine. Every row traces to a doc the recap named — say the callback: "these are the laws from slide 3; you are hiring the police." Rescue detail per rule is in the teachers guide, never on screen. If someone brings their own rule, one filter only: can a script detect it from a file path or file content? Then build it.

~2 min.

## Slide 20 · The hook — give your rule teeth _(Your Rule · Build It)_

[CALIBRATED from review, 2026-08-19: simplified — build the hook, verify it, done; no severity essays, no residue ceremony]

FRAME IT IN ONE BREATH: the rule is already written; you are adding the police. Table talk during the build is welcome — compare approaches, debug a neighbour — but the artifact is individual: your rule, your hook, your evidence. Remote circulation = one whole-call chat nudge at ~7 min ("what does your allow case replay?" — no answer means verification is about to be skipped) + Slack for 1:1s. Rescue detail per menu rule is in the teachers guide — Slack it one piece at a time, never on screen.

COMMON QUESTIONS

Q: "Torn between rules?"
A: the sibling-test nudge is the gentlest start; the store boundary is the most satisfying block.

Q: "Do I need the hook AND the gate?"
A: yes — different audiences: the hook stops the agent, the gate stops anyone.

Q: "My detection regex is imperfect."
A: that is exactly what nudges are for — an imperfect block stops real work; an imperfect nudge costs one ignorable note.

~15 min.

## Slide 21 · Checkpoint 2 _(Checkpoint)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

Gate hard here: the CI-gate step reuses the same detection, which this checkpoint proves works. Fast finishers: build a second rule from the menu, or offer an allow-case replay to whoever asks in Slack.

~2 min.

## Slide 22 · Layer 4 already runs — your gate just joins it _(Layer 4 · Already Live)_

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

WHAT THIS SLIDE TEACHES — say it as one breath at the top: (1) layer 4 is not new, it already runs — lint, typecheck, tests ARE merge-time governance, so the gate you build next is one more check in an existing file, not a new platform; (2) merge time is the layer of last resort — --no-verify cannot skip it, a fresh clone cannot miss it, it holds against anyone merging, agent or human; (3) gap analysis, rehearsed live. Open the real file, one minute, then ask "what rule is written but never run?" and WAIT — someone will find format:check (a package.json script CI never calls); the skill being taught is the gap analysis, not prettier. Land the division of labour: the repo's review agent is explicitly told NOT to re-report what lint and typecheck already catch — non-AI guardrails are the floor; spend the AI layer on what only it can see. Connect to their world: their own Actions pipeline is this same layer, built in-house.

~3 min.

## Slide 23 · The same rule at merge time _(Your Rule · Merge Time)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

THE GOTCHA that will eat this step remotely: the gate runs on pull_request — a student who commits to their branch and waits will conclude it does not work. Say it before they start: push, open a draft PR, watch the check.

CONCRETE CORES for all four menu rules are in the teachers guide (rescue detail — Slack, never on screen); each is a diff-scoped grep, so pre-existing code never trips it. If someone notices their gate fires on a docs-only PR, nice catch — a path filter is the one-line fix; do not make it a required decision, keep the momentum on build-and-verify.

~10 min.

## Slide 24 · Checkpoint 3 _(Checkpoint)_

[CALIBRATED from team-lead feedback, 2026-08-18: shorter demos · git hook as the vehicle for Claude hooks · table talk]

The usual straggler is the draft-PR gotcha (a pushed branch alone runs nothing) and the shallow-clone diff failure (fetch-depth: 0). CI runs take a minute or two — use the wait to skim the chat links as they land. Fast finishers: a second menu rule, or the telemetry stretch.

~2 min.

## Slide 25 · Let us compare _(Review)_

[CALIBRATED from review, 2026-08-19: questions reworked for the pick-a-rule exercise]

Push hardest on the false-positive question — it reveals whether anyone actually ran the allow case. The last question bridges to the table-talk backlog from slide 12 — pull those chat lines back up if the room stalls. If a table had a good argument during the build, invite THAT to the mic — a disagreement about severity is better review material than a working demo.

~10 min.

## Slide 26 · The sixth artifact, and it is yours _(Hand-Off)_

Three minutes; framing over content. The guide is written for a team new to governance — it opens with the four terms, Crawl is one person's afternoon, and every tool option carries its trap named. Callback: this handout reached you as one canonical repo plus a pointer — crawl — and giget if you ran it, most of walk. Done = the template filled: rung, FIRST MOVE, and an owner who is a person. The two fields people skip are Owner and Not-doing-yet, and they are the two that matter. "We will decide later" is the only answer that costs more than acting.

IF AI MEMORY SERVICES COME UP (Mem0, Zep, OpenMemory — or Claude Code's own auto-memory): they are an emerging DISTRIBUTION channel, not an enforcement layer — a shared memory can make team conventions ambient across sessions and repos, which is attractive at the run rung, but recalled memory is layer 1: it informs, it never enforces, and it recalls probabilistically. Two honest caveats to give: provenance and currency are harder to audit than a pinned file (which copy is authoritative? when did it change?), so if the team adopts one, the standard's HOME stays the governance repo and memory is a projection of it; and the enforcing layers — hooks, gates — still need the deterministic files either way. Good fit: preferences and recurring context; wrong fit: the law.

~3 min.

## Slide 27 · What leaves this room _(Wrap & Retro)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built]

Close on the deny/ask list — the thing every person applies tomorrow regardless of how far they got. Read the ship checklist as one list; it mirrors the handout exactly. Retro as a chat waterfall: type, hold, 3-2-1 send.

COPY THE CHAT BEFORE ENDING THE CALL — Meet deletes it, and the refusal texts + gate run URLs + table-talk lines + retro lines feed the capture entry. INSTRUCTOR, within 24h: file the lab-capture entry (AI-Transformation-Playbook/04-labs/lab-capture-template.md) — outcomes, stuck points, timings, and the interactive-format observations (table talk, git-hook-first bridge): this session is the validation data point for that variant.

~5 min.

