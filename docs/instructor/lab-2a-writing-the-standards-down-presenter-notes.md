# Lab 2.a — Writing the Standards Down · Presenter Notes

Speaker notes for `lab-2a-writing-the-standards-down.pptx` (the same text is attached to each slide's Notes pane).

> **Calibrated against the Lab 1.b room feedback (2026-08-12), adapted for Google Meet
> delivery (remote, not in-room).** Nothing remains provisional.

## Slide 1 · Writing the Standards Down

Welcome to Lab 2.a. Two hours, mostly hands-on. The challenge in one breath: this repo has a real, load-bearing rule that nothing explains and nothing checks — you will document the why as an ADR, derive a rule from last week's real fixes and write it as an NFR, and wire both into CLAUDE.md so Claude actually reads them.

~1 min.

## Slide 2 · Two hours, mostly hands-on _(Today)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive]

The blocks sum to 120 — keep yourself honest on them. No setup block: everyone arrives ready per the handout (branch created, docs/labs pulled, npm test green) — verify in chat ("type READY if npm test is green on your branch"), and route any exception to Slack during the Why slide rather than stopping the call. Set expectations: this block is less typing than 1.b and more deciding. Two unusual asks today: read code cold and write a rule from it, and mark which parts of your own rule a machine could not check. Also say once: how you're assessed is on the handout — same five-dimension rubric as Lab 1, counts toward Agentic Developer.

~2 min.

## Slide 3 · Sixteen developers, sixteen private setups _(Why)_

Do not oversell — this room is already positive about AI; the pitch is "stop solving the same problem sixteen times." Land the vocabulary on card 3, once, and reuse it all day: a RULE is what the team agrees on; a DOCUMENT is where the rule lives (one document can hold many rules); a rule written down and agreed is a STANDARD — the same definition the distribution guide uses. Then land the ETH note: the point is not "AI cannot write docs", it is that a doc nobody thought about is negative value. Ask who has run /init and never read the output in chat, as a +1 — the +1s will come. Source link is in the handout.

~3 min.

## Slide 4 · Every rule has a reach — that reach is its layer _(Scope)_

The sorting question — say it twice: WHO must obey this rule? Everyone everywhere → Collective. Everyone in this repo → Project. Only some files → Feature/path. All three example rules are real and in this repo right now; open CLAUDE.md line 72 if anyone doubts the secrets one. The footnote is the payoff: the secrets rule is mis-layered today, and the room can SEE it — that mismatch is why the sixth artifact (an org-wide home + how repos inherit from it) exists, and 2.b hands it to them to define. Today all their work is Project-layer.

~3 min.

## Slide 5 · Five types — and the question each answers _(The Artifacts)_

Read the middle column aloud, row by row — the questions do the teaching. The expansions (Architecture Decision Record, Non-Functional Requirement) get said out loud exactly once, here. Then the footnote, with this repo's pair as the example: the envelope rule is an NFR — every response uses it, checkable, a bare res.json() is a defect. adding-a-resource.md is a recipe — the recommended steps; you may add a resource differently and violate nothing, as long as the envelope rule still holds. Binding vs guiding is the line.

~2 min.

## Slide 6 · One subject, five artifacts _(Differentiation)_

THE slide of the block — spend time here. Walk the same subject across all five rows, then land the one-word summary. If someone says "that is a lot of documents for one rule" — good: you would not write all five; you write the one that answers the question you actually have. EXPECT the pairing question ("does every NFR have an ADR?"): no, and no — they pair ONLY when one subject has both a contested decision AND a checkable standing rule, like this boundary. NFR-0001 has no ADR (hygiene, not a decision); a cloud-choice ADR would have no NFR (nothing to check per PR). When both exist they cross-reference, never duplicate: the NFR says "rationale: ADR-0002", the ADR says "enforced via NFR-0002". If the room wants a second worked pair, use the one on the takeaway card (enforcing-a-convention.md): "all backends must use SQLite" — ADR holds the decision, NFR holds the must + a CI dependency-scan check, and the word ALL makes it Collective-layer, which previews the sixth artifact. The CLAUDE.md row quotes the file verbatim on purpose — open it live if anyone doubts.

~5 min.

## Slide 7 · Telling them apart when it is unclear _(Differentiation)_

Do not read all 30 cells. Two rows do the work: "carries a check" isolates the NFR — the only artifact obliged to say how compliance is verified, the bridge to 2.b — and "when it loads" separates the two context files from the three documents. Then read the footnote aloud: the quick test is the take-home, and one-home-per-fact is the failure mode that kills governance corpora. Recipes and rules files get no further slide — the handout covers them.

~4 min.

## Slide 8 · How big should it get? _(Claude.Md)_

Land the continuity first — this is NOT new: 1.a taught POINTER = LAZY vs @IMPORT = EAGER, and said "give a clear trigger — before X, read Y." The table is that one line as rows: situation -> pointer. A lazy pointer WITHOUT a trigger is a link the agent may never follow; the trigger is the firing condition that makes lazy reliable. Then pre-empt the objection: they saw a 72-line CLAUDE.md in 1.a and will meet 500-line ones in the wild. Both are correct at their scale; the trigger table is what makes the difference. Phrase triggers as situations, not topics — the agent matches on what it is doing. The last bullet is the third rung, one sentence only: past a few dozen docs, per-repo copies drift and even the trigger table bloats — so the docs get ONE canonical home and consumers QUERY it (a search tool over the governance repo, or a small docs service the agent calls). The mature corpus we cite runs 137 docs that way. Do not teach the mechanics here — the distribution guide 2.b hands over covers them; it puts the crossover at roughly 20+ docs.

~2 min.

## Slide 9 · Start light — and know when to graduate _(Maturity)_

Do not sell the heavy forms. The one nuance: your NFR today is deliberately mid-ladder — the handout gives the clause + "Checked by:" skeleton, which NFR-0001 predates. Fun fact for the room: a mature corpus we know contains an ADR recording its own choice of ADR format — the format itself is a decision.

~2 min.

## Slide 10 · When is a document required — and who owns it? _(Authoring)_

Cite the finding as a finding: published field experience says teams stop writing ADRs because the operational questions were never answered. Ask which of these five triggers they could answer for their own repos today — usually none. Champions co-lead the standards work from here on and the EM reviews the output — name the confirmed co-leads here (see the engagement plan; do not name anyone in shared material), and make sure the room knows a review is coming.

~4 min.

## Slide 11 · Drafting with Claude, honestly _(Authoring)_

Demonstrate the shape: the second prompt deliberately ends "leave Decision as a question for me to answer" — that clause is the difference between drafting and delegating. All five starters are in the handout's prompt table; these two are quoted from it verbatim.

~4 min.

## Slide 12 · Keeping them true _(Lifecycle)_

The incident-citing pattern is the most transferable thing in this block. Give the shape: "Rule: never X. Why: on <date> we did X and <consequence>." It is also the answer to the yes-man complaint from their interviews — rules with reasons survive pushback from a persuasive agent.

~2 min.

## Slide 13 · Demo — write an ADR

Transition, three beats: (1) the gap — a real rule with no recorded reason; (2) the demo, six steps, on screen so nobody gets lost; (3) what good looks like. Tell them what to watch for: where the evidence comes from, and the moment I stop Claude and write the Decision myself. Tell them now: you write yours immediately after, same subject, your own words. Invite questions DURING the demo — and expect the big one ("why write an ADR for a decision already made?"), which the next slide answers before anyone asks.

## Slide 14 · A rule with no recorded reason _(Demo · The Gap)_

Show the actual directories, not the slide. Grep for imports of store.ts and show the boundary really holds. The "nothing checks it" line plants 2.b — don't explain it yet.

COMMON QUESTIONS here —

Q: "Who decided this, then?"
A: whoever built the repo; the ADR records the reasoning that decision implies — and if we get it slightly wrong, a PR fixes a document, which beats the nothing we have now.

Q: "Is a retroactive ADR cheating?"
A: no — most real ADR practices START by back-filling the 3–5 decisions newcomers always ask about; the alternative is oral history.

Q: "Why not just add a comment in the code?"
A: comments explain a line; this decision spans four directories — it needs a home that isn't inside any one of them.

~3 min.

## Slide 15 · Six steps — follow along on screen _(Demo · The Steps)_

Run the demo AGAINST this slide — point at the step number as you go, so anyone who looks away can rejoin.

COMMON QUESTIONS

Q: "What filename/number?"
A: next number in docs/adr/, kebab-case: 0002-repository-only-store-access.md; the number is an identity, never reused, even if an ADR is later superseded.

Q: "What if Claude's evidence is wrong at step 3?"
A: correct it in conversation and re-ask — and say out loud that this is why step 3 exists; a wrong Context poisons everything after it — and there IS a real catch planted in this repo: index.ts imports ensureDb from the store (boot, not data access), which Claude's tidy summary usually misses; the walkthrough doc works it. Tell the room the walkthrough exists so nobody transcribes the demo.

Q: "How long should the ADR be?"
A: template-length — Context 3–6 sentences, Decision ONE, a handful of consequences; if it sprawls you are writing documentation, not a decision.

Q: "Can I just write it by hand, no Claude?"
A: absolutely — the artifact is graded, not the tooling; the prompts exist because evidence-gathering across four directories is the part Claude is genuinely good at.

~4 min.

## Slide 16 · What good looks like _(Demo · The Result)_

Narrate the wrong turns — if Claude writes a consequence that is really a benefit in disguise ("Bad: developers must learn the pattern" is really an upside wearing a frown), say so and fix it live. The honest cost is what makes an ADR credible; a document with only upsides is marketing. The shape matches the shipped template exactly: metadata bullet block, then THREE sections.

COMMON QUESTIONS

Q: "What is the difference between Context and Decision content?"
A: Context describes the situation and forces, no verbs of choosing; the Decision is one active-voice sentence; if your Context contains "we decided", move that sentence down.

Q: "What counts as an honest cost?"
A: something a real person could complain about on a real day — the extra hop for simple reads, one more file per resource; test: would a sceptic nod?

Q: "What goes in Deciders for a training repo?"
A: your name today; in real life, the people who MADE the call — which is rarely the person writing the record.

Q: "Claude wrote a different Decision than yours."
A: fine, if the substance matches; the wording must be yours — rewrite it in your own words as the test that you own it.

~5 min.

## Slide 17 · Now write yours — same subject, your words _(Your Turn)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive]

This is the follow-along increment — everyone in the same state before the checkpoint. If anyone skipped the handout prep, now is when it bites: branch `feat/governance`, docs/labs pulled. Remote circulation: one chat nudge at ~5 min ("stuck on Context? Slack me"); the common stall is over-polishing Context. Ten minutes, hard stop. Fast finishers: point at the stretch — derive the store-boundary clause list early, or swap draft Decisions with another fast finisher over Slack.

COMMON QUESTIONS

Q: "Same subject as yours — is that not just copying?"
A: the MOTION is the point: your prompts, your edit, your Decision sentence, your cost; next week the subject is one nobody has modelled.

Q: "What if I disagree with the repository pattern?"
A: perfect — record it anyway (Status: Accepted; it IS this repo's reality) and put your objection in Consequences as a cost; recording is not endorsing, and in real life your objection becomes a superseding ADR proposal.

Q: "Commit now or at the end?"
A: commit to feat/governance now — small commits, one PR at the end of the block.

Q: "My ADR came out nearly identical to the demo."
A: expected on a shared subject; the checkpoint checks the metadata block, three sections, and a real cost — not originality.

~11 min.

## Slide 18 · Checkpoint 1 _(Checkpoint)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive]

Chat is the room-walk: Decision sentences land where you can read them, and a missing name is your signal (Slack them, not the whole call). If more than two people are stuck, the cause is usually prompt shape — show yours again. Fast finishers go to the stretch list (handout): the store-boundary clauses or a peer review.

~3 min.

## Slide 19 · Your turn — derive a rule

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive]

Scaffolding drops here — from following along to deciding. Announce the mode change explicitly; it should not be discovered. Say what the next 40 minutes look like in one breath: read three fixes (4 min, silent) -> ON YOUR OWN, turn four seed clauses into your rule (10 min, structured — the clock slide gives the shape) -> we compare lists and agree one as a class (4 min) -> each of you writes it up as YOUR OWN NFR (20 min). Individual by design — this course must also work self-guided; the class compare is calibration, not committee work. Full teaching guide for this block — run sheet, scripts, expected-clause bank, recoveries: docs/instructor/lab-2a-derive-teachers-guide.md.

## Slide 20 · Three ways the same bug got fixed _(Stimulus)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive]

STIMULUS (settled 2026-08-12): all three are AUTHORED scenarios — nothing on screen is anyone's real diff, because the cohort's own 1.b PRs were all done properly. Say that as CREDIT, out loud: fix C is exactly what this room did. Then frame A and B as what happens on real teams on busy days — the situations are on the slide now. Give the two reading questions, then stop talking; the silence is deliberate.

COMMON QUESTIONS

Q: "Are these real?"
A: authored for this exercise; C mirrors your own PRs.

Q: "How does B happen if nobody is careless?"
A: one mechanism — the test was written AFTER the fix and never run against the broken code; variants: weak assertions, testing the mock, an agent characterizing already-fixed code. Recall 1.b's fixture trap (the Jan-2026 completed todo): a stats test written without completing a todo first passed regardless — this room brushed against a B two weeks ago.

Landing line: A and B happen to careful people under pressure — that is why it needs a rule, not a scolding.

BONUS BEAT (use in converge if energy is good, and this one IS true of the room): several 1.b fixes never became PRs at all — working code, invisible to review. What rule would catch a fix that never ships?

~4 min of reading.

## Slide 21 · Your ten minutes, structured _(Derive · The Clock)_

Present this in ONE minute, then start the clock and watch the Doc, not faces — the structure is the mitigation for a cohort that waits to be told — and the INDIVIDUAL shape is deliberate: this course must survive becoming self-guided, and independent verdicts beat one early consensus. The catch-test ("which of A/B/C does this clause catch?") is self-administering: anyone who runs it honestly discovers that "ships with a test" does not catch B — the discovery the exercise exists for.

COMMON QUESTIONS

Q: "What does mechanical mean, exactly?"
A: a script, given ONLY the diff, could return pass/fail — if you need to know intent, it's fuzzy.

Q: "Can a clause be conditional?"
A: yes — "docs-only changes are exempt" is a fine clause, and note it: that exemption becomes a CI path filter next week.

Q: "What if we all just agree?"
A: run the catch-test out loud — which fix does each kept clause catch? If nothing on your list catches B, you are not done.

Q: "Does wording matter?"
A: substance now, wording when you write the NFR — the lists in the Doc are raw material, not the document.

~1 min to present.

## Slide 22 · Which are acceptable? Write the rule. _(Derive)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive]

Ten minutes, silent, individual — mics muted, monitor the Doc as lists appear. 1.b says this cohort waits to be told, so the ladder is delivered as TIMED CHAT NUDGES to everyone, not as visits: at ~3 min, "Seed 2 — keep, tighten, or drop?"; at ~6, "Fix B is green. Would seed 1 alone have caught it?"; at ~8, "Which of your tags could a script actually decide?" Never state a clause. Individuals stuck beyond the nudges get a Slack ping, not a call-out. Watch the Doc for lists where B passes — the interesting case; do NOT flag it yet. Fast finishers: the store boundary, same method, as stretch.

~10 min.

## Slide 23 · Where we landed _(Converge)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive]

MANDATORY: state and write the agreed clauses before advancing — an unresolved compare is worse than none. Run it as: share the Doc on screen, name the clauses MOST lists agree on (those enter AGREED fast), then ask two or three people to unmute and read their LEAST-SURE clause (that is why they marked one) — divergence is where the standard gets made. Card contents are illustrative; replace live with what the room produced. If they missed "failed first", ask: "B was green before the fix. Would your rule have caught it?" Apply the tiebreak on mic when lists conflict: the stricter clause wins unless someone can show it false-positives on real code in this repo.

COMMON QUESTIONS

Q: "Who owns this agreed list?"
A: the class does, as of now — it goes in everyone's NFR; a champion owns keeping it true after today.

Q: "My list disagrees with AGREED — do I write mine or ours?"
A: ours — AGREED is the standard; record your dissent as a dropped clause with a reason, which is exactly how disagreement with a live standard works on a real team.

Q: "Can we change the list later?"
A: yes — NFRs revise in place; that is the lifecycle slide made real.

ARTIFACT BEAT (30 sec, do not skip): ask "which artifact is this list?" and give ten seconds before answering — someone will say ADR, and that is the productive mistake: it FEELS like a decision, but the quick test says NFR (always-holds + checkable; present tense; revised in place). If adopting the rule ever becomes genuinely contested, THAT argument earns an ADR. And the know-how ("how do I write a failing test first?") is recipe material — a stretch, not today. One derivation, three artifact homes — the slide-6 skill, used on their own work. "The test failed first" is the clause that matters most, and no gate can decide it — that is the finding, and 2.b's opening problem.

~3 min.

## Slide 24 · Same file, three enforcement states _(The Hinge)_

THE GOAL OF THIS SLIDE, in one sentence: prove that the MECHANICAL/FUZZY tag they just put on their own clauses is not homework bookkeeping — it is a property every written rule already has, demonstrated in a file they already trust. Same CLAUDE.md, three rules, three enforcement states: the store boundary is WRITTEN and nothing checks it (their morning ADR subject — a rule can be documented and still be only a promise); console.log is CHECKED (lint fails it — the only one of the three that is actually a gate); logger.info with a wrong first arg is HALF-CHECKED — it looks enforced, passes silently, and that false confidence makes the half-gate the most dangerous state of the three, worse than unchecked because nobody is watching a rule they believe a machine watches. The three states are NAMED on the slide — walk them top to bottom, then land the last bullet as the bridge to the write-up: the Checked-by line is where each clause's state gets RECORDED, and 2.b is where the unchecked ones get teeth. If you want a discussion beat, ask "so which of these is a standard?" and answer it: all three (written + agreed) — what differs is only how much of each is backed by a check.

FACT-CHECKED against the repo 2026-08-13: the shown call keeps the signature (scope, message, meta) typed correctly, so tsc passes it AND eslint passes it — only the CONVENTION (scope = file basename) is violated, and nothing checks that. Say the strengthened version out loud: TWO machine checkers watch this exact line, and the rule still slips through, because neither was aimed at it. This slide is a taught exhibit, NOT an exercise — do not invite a live paste-test.

COMMON QUESTIONS

Q: "I tried a wrong first arg and the editor DID flag it"
A: almost certainly the TYPE checker, because the pasted call dropped the message argument — a shape error, not the convention; keep all three args typed right and every checker goes quiet. And that near-miss IS the lesson: an error NEAR a rule reads as enforcement of the rule, which is how half-gates stay invisible.

Q: "What is meta?"
A: the optional third argument — a plain object of structured context (Record<string, unknown>) that the logger JSON-stringifies onto the log line; the ? means optional, borrowed from TypeScript.

VALID (all pass tsc): logger.info('todos.service', 'created', { id }) — object literal in the third slot; logger.info('http', 'GET /api/todos 200', { durationMs }) — the live call in requestLogger.ts; logger.info('index', 'server started') — meta omitted entirely, that is what optional means.

INVALID (each verified against tsc 2026-08-13): logger.info('todos.service', { id }) — only two args, so the object sits in the MESSAGE slot, which must be a string (the classic mistake); logger.info('todos.service', 'created', 'id=' + id) — meta must be an object, never a pre-formatted string: put values IN the object; logger.info('todos.service', 'created', id) — a bare value is not a Record: wrap it as { id }.

Rule of thumb: two strings, then one object or nothing.

Q: "Isn't the scope convention FUZZY, then — nothing checks it?"
A: no — unchecked and UNCHECKABLE are different facts. CAN a machine check it? Yes: the linter always knows which file it is in, so a rule comparing the first-arg literal to the file basename is a dumb string comparison — MECHANICAL. DOES anything check it today? No — nobody wrote that rule. Checkable-but-unchecked is exactly what a half-gate is. Contrast: "the test failed before the fix" is UNCHECKABLE from the code — that one is fuzzy. (Full honesty for a sharp room: a variable first arg defeats the literal comparison, so strictly the clause is PARTLY — 2.b names that tier.)

Q: "So is the logging rule enforced or not?"
A: half — the channel is enforced, the content is not; "enforced" is per-CLAUSE, never per-rule, which is why your NFR marks each clause separately.

Q: "Why not just fix the half-gate now?"
A: it is an ESLint rule away and makes a fine stretch — but today the point is SEEING the state, not fixing it; you will close a gap like this in 2.b.

~2 min.

## Slide 25 · What a mature team wrote _(Compare)_

Timing is the point: AFTER the room commits, so it reads as comparison, not answer key. Sanitised — no client, product, or domain detail; if asked, "another engagement, and that is all I can say."

~2 min.

## Slide 26 · Turn the clauses into an NFR _(Write It Up)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive]

One recurring chat nudge: "how is that clause checked?" If someone cannot answer, the clause is not finished. The skeleton on screen is also in the handout. Reserve the last five minutes for peer review — it is an acceptance criterion and the first thing skipped.

COMMON QUESTIONS

Q: "We all start from the same AGREED list — does everyone write the same NFR?"
A: same clauses, YOUR document: your wording, your Checked-by lines, your marks, your dropped-clause dissents; the peer review is what catches where wording changed the meaning.

Q: "What filename?"
A: docs/nfr/0002-test-discipline.md — next number, kebab-case, like the ADR (the store-boundary stretch would be 0003).

Q: "Do dropped clauses go in?"
A: yes, one line each at the bottom with the drop decision and a name — a visibly-considered-and-dropped clause stops the same debate re-running next quarter.

Q: "How formal is the wording?"
A: NFR-0001's tone: plain sentences, numbered, no legalese — the Checked-by line is where the rigour lives.

~20 min.

## Slide 27 · Checkpoint 2 _(Checkpoint)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive]

Ask two or three people to unmute and read a fuzzy clause with its recorded decision — two minutes, and it makes the standard real. The common failure here: a "Checked by: code review" line on every clause — that is the human gate as a reflex, not a decision; push once: "could a script check THIS one?" Fast finishers: the half-gate stretch (write the ESLint clause) or the rules-file conversion.

~2 min.

## Slide 28 · A doc nothing points at is a doc nobody reads _(Wire It In)_

The slide before showed WHAT the two entries are; this one says what each DOES — same rule, referenced twice, two different jobs. Say the mechanics precisely. The BINDING LINE enforces by PRESENCE: it is the rule's one operative sentence living inside CLAUDE.md, so it is in context every session — loaded once with the file, no separate fetch, and above all no DECISION: the trigger row works only if Claude correctly decides the situation applies; the binding line arrives whether or not anything decides anything. (Precision for the sharp student: CLAUDE.md itself IS read at session start — the claim is not "never loaded", it is "never conditional".) The binding line's (NFR-0002) tail is a CITATION, not a loader: it tells Claude and humans where the full law lives, one deliberate hop away.

SAY THE WORD OUT LOUD BEFORE THE ROOM MISREADS IT: binding as in a binding CONTRACT — the line is the rule, in force — NOT binding as in data-binding; it does not wire anything to anything, and its citation loads nothing. Developers reliably hear the wrong one first. The TRIGGER ROW has two parts, and naming them helps: a SITUATION ("when you are fixing a bug or adding behaviour") and a POINTER ("read docs/nfr/0002 first") — the pointer gives Claude the ABILITY to load the full doc; the situation says WHEN. Task matches, Claude reads the whole NFR: every clause, Checked-by line, dropped clause.

TWO PATHS to the full document, and only one is designed: (1) the trigger row — the situation matches, the doc is read; this is the reliable path. (2) following the citation — Claude (or a person) mid-task decides it needs more than the headline and chases NFR-0002; possible because the citation exists, but voluntary — nothing forces it. Delete the trigger row and path 2 still exists, but now you are relying on Claude spontaneously deciding to look things up — hope-based governance, the exact thing this lab replaces.

Anchor in 1.a: the trigger row is the lazy pointer they already know; the binding line is a deliberate one-line eager load, kept to one sentence precisely because eager space is paid every session.

Kill each one mentally to prove both are needed: no binding line, and the always-applies rule hangs on Claude deciding to fetch; no trigger row, and the details (how each clause is checked, the exceptions) are unreachable by situation. The binding line is new vocabulary and it is graded.

WHEN IS A BINDING LINE NEEDED — give them the test, then the repo's own contrast: ask "in what situation does this rule apply?" If you can name one narrower than ANY CHANGE, the trigger row is enough — that is why NFR-0001 needs NO binding line: "calling an external API" is a nameable situation, so its trigger row suffices. Test discipline applies to every change — no situation could trigger the fetch reliably — so it is the first rule in this repo that EARNS the eager line.

Expect binding lines to stay RARE: a CLAUDE.md full of them is just a second copy of every document — one or two in a healthy file.

COMMON QUESTIONS

Q: "Why not just make the binding line say READ docs/nfr/0002 before any change?"
A: three reasons. One: that converts a one-line cost into a full-document fetch on every session, to retrieve a rule whose operative sentence fits in one line. Two: "always read X first" is the weakest kind of instruction — under pressure it gets skipped, while a rule stated in place is simply THERE; the sign on the wall works because it IS the rule, not directions to the rulebook. Three: the binding line already cites NFR-0002, so the full law — all clauses, Checked-by lines, dropped clauses — is one hop away when nuance is needed.

Q: "Then why not paste the whole NFR into CLAUDE.md?"
A: one home per fact — a copy drifts from the doc and then nobody knows which is authoritative; and CLAUDE.md is a paid-every-session index, not a library.

Q: "The trigger row already says fixing-a-bug -> read the NFR — is the binding line not redundant?"
A: the trigger is a fetch DECISION Claude makes each time, and a rule that applies to every change would need that decision made right every time; the binding line is deterministic presence. Redundant on purpose — like the deny rule and the hook next week.

Q: "Why doesn't the binding line load the NFR when I am fixing a bug?"
A: nothing in CLAUDE.md EXECUTES — every entry is a sentence Claude obeys, and each does exactly what its text says: "Read first: docs/nfr/0002" instructs a read, "ships with a test" instructs a test. The load while bug-fixing comes from the trigger row, the only sentence that says READ.

Q: "Is the trigger row enforced?"
A: no — all of this wiring is layer 1, instruction; nothing verifies the read happened, and the smoke test is a manual probe, not a gate. Next week does NOT change that: 2.b enforces the OUTCOME (a test in the diff, via hook + CI gate), never the reading — you cannot usefully gate "did the model read the doc", you gate the consequence, and once the outcome is gated the read matters less. Layer 1 informs; layers 2–4 enforce.

The smoke test takes 60 seconds: new session, ask the rule, watch whether it reads the doc or guesses. If it guesses, the trigger is phrased as a topic, not a situation — fixable in one edit.

~9 min.

## Slide 29 · One rule, one home, four references _(Wire It In)_

The summary slide of the wire-in — read it BY JOBS, one row at a time, and let it preview 2.b. Two facts to land while reading. FIRST, one home per fact survives: none of the four references duplicates the law — the binding line states one headline sentence and cites the doc; the trigger row points at the doc; the hook and the gate re-encode ONE mechanical clause each, and a human writes that encoding — the gate does not read the NFR, it greps the diff for what the clause says. SECOND, the layer split: both CLAUDE.md rows are layer 1 — instruction, never validated, never enforced — and stay that way forever; enforcement arrives next week as SEPARATE artifacts at layers 2 and 4, and even then it is the OUTCOME of the clause that gets checked, never whether anything was read. If one table survives the block in their heads, it is this one.

~1 min.

## Slide 30 · Compare, reflect, capture _(Review & Retro)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive]

Do not skip this to buy build time — it is the review+capture close Format B requires.

COPY THE CHAT BEFORE ENDING THE CALL — Meet deletes it, and the Decision sentences, the AGREED clause list, and the retro lines all feed the capture. INSTRUCTOR, within 24h: file the lab-capture entry (AI-Transformation-Playbook/04-labs/lab-capture-template.md) — what was built, stuck points, timings, refinements. This deck is the Format B pilot; the capture entry is how it gets validated.

~4 min.

## Slide 31 · Ship checklist, and what is next _(Wrap)_

Land the through-line: last week a habit, this week a standard, next week a gate. The wrap checklist mirrors the handout acceptance criteria exactly — read it as one list, not highlights.

~1 min.
