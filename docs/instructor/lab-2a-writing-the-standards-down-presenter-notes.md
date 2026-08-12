# Lab 2.a — Writing the Standards Down · Presenter Notes

Speaker notes for `lab-2a-writing-the-standards-down.pptx` (the same text is attached to each slide's Notes pane).

> **Calibrated against the Lab 1.b room feedback (2026-08-12).** Slides whose notes open
> with **[CALIBRATED…]** carry the specific adjustment; nothing remains provisional.

## Slide 1 · Writing the Standards Down

Welcome to Lab 2.a. Two hours, mostly hands-on. The challenge in one breath: this repo has a real, load-bearing rule that nothing explains and nothing checks — you will document the why as an ADR, derive a rule from last week's real fixes and write it as an NFR, and wire both into CLAUDE.md so Claude actually reads them. ~1 min.

## Slide 2 · Two hours, mostly hands-on _(Today)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive] The blocks sum to 120 — keep yourself honest on them. No setup block: everyone arrives ready per the handout (branch created, docs/labs pulled, npm test green) — verify that claim with a ten-second show of hands here, and pair any exception quietly during the Why slide rather than stopping the room. Set expectations: this block is less typing than 1.b and more deciding. Two unusual asks today: read code cold and write a rule from it, and mark which parts of your own rule a machine could not check. Also say once: how you're assessed is on the handout — same five-dimension rubric as Lab 1, counts toward Agentic Developer. ~2 min.

## Slide 3 · Sixteen developers, sixteen private setups _(Why)_

Do not oversell — this room is already positive about AI; the pitch is "stop solving the same problem sixteen times." Land the vocabulary on card 3, once, and reuse it all day: a RULE is what the team agrees on; a DOCUMENT is where the rule lives (one document can hold many rules); a rule written down and agreed is a STANDARD — the same definition the distribution guide uses. Then land the ETH note: the point is not "AI cannot write docs", it is that a doc nobody thought about is negative value. Ask who has run /init and never read the output — hands will go up. Source link is in the handout. ~3 min.

## Slide 4 · Every rule has a reach — that reach is its layer _(Scope)_

The sorting question — say it twice: WHO must obey this rule? Everyone everywhere → Collective. Everyone in this repo → Project. Only some files → Feature/path. All three example rules are real and in this repo right now; open CLAUDE.md line 72 if anyone doubts the secrets one. The footnote is the payoff: the secrets rule is mis-layered today, and the room can SEE it — that mismatch is why the sixth artifact (an org-wide home + how repos inherit from it) exists, and 2.b hands it to them to define. Today all their work is Project-layer. ~3 min.

## Slide 5 · Five types — and the question each answers _(The Artifacts)_

Read the middle column aloud, row by row — the questions do the teaching. The expansions (Architecture Decision Record, Non-Functional Requirement) get said out loud exactly once, here. Then the footnote, with this repo's pair as the example: the envelope rule is an NFR — every response uses it, checkable, a bare res.json() is a defect. adding-a-resource.md is a recipe — the recommended steps; you may add a resource differently and violate nothing, as long as the envelope rule still holds. Binding vs guiding is the line. ~2 min.

## Slide 6 · One subject, five artifacts _(Differentiation)_

THE slide of the block — spend time here. Walk the same subject across all five rows, then land the one-word summary. If someone says "that is a lot of documents for one rule" — good: you would not write all five; you write the one that answers the question you actually have. EXPECT the pairing question ("does every NFR have an ADR?"): no, and no — they pair ONLY when one subject has both a contested decision AND a checkable standing rule, like this boundary. NFR-0001 has no ADR (hygiene, not a decision); a cloud-choice ADR would have no NFR (nothing to check per PR). When both exist they cross-reference, never duplicate: the NFR says "rationale: ADR-0002", the ADR says "enforced via NFR-0002". If the room wants a second worked pair, use the one on the takeaway card (enforcing-a-convention.md): "all backends must use SQLite" — ADR holds the decision, NFR holds the must + a CI dependency-scan check, and the word ALL makes it Collective-layer, which previews the sixth artifact. The CLAUDE.md row quotes the file verbatim on purpose — open it live if anyone doubts. ~5 min.

## Slide 7 · Telling them apart when it is unclear _(Differentiation)_

Do not read all 30 cells. Two rows do the work: "carries a check" isolates the NFR — the only artifact obliged to say how compliance is verified, the bridge to 2.b — and "when it loads" separates the two context files from the three documents. Then read the footnote aloud: the quick test is the take-home, and one-home-per-fact is the failure mode that kills governance corpora. Recipes and rules files get no further slide — the handout covers them. ~4 min.

## Slide 8 · How big should it get? _(Claude.Md)_

Land the continuity first — this is NOT new: 1.a taught POINTER = LAZY vs @IMPORT = EAGER, and said "give a clear trigger — before X, read Y." The table is that one line as rows: situation -> pointer. A lazy pointer WITHOUT a trigger is a link the agent may never follow; the trigger is the firing condition that makes lazy reliable. Then pre-empt the objection: they saw a 72-line CLAUDE.md in 1.a and will meet 500-line ones in the wild. Both are correct at their scale; the trigger table is what makes the difference. Phrase triggers as situations, not topics — the agent matches on what it is doing. The last bullet is the third rung, one sentence only: past a few dozen docs, per-repo copies drift and even the trigger table bloats — so the docs get ONE canonical home and consumers QUERY it (a search tool over the governance repo, or a small docs service the agent calls). The mature corpus we cite runs 137 docs that way. Do not teach the mechanics here — the distribution guide 2.b hands over covers them; it puts the crossover at roughly 20+ docs. ~2 min.

## Slide 9 · Start light — and know when to graduate _(Maturity)_

Do not sell the heavy forms. The one nuance: your NFR today is deliberately mid-ladder — the handout gives the clause + "Checked by:" skeleton, which NFR-0001 predates. Fun fact for the room: a mature corpus we know contains an ADR recording its own choice of ADR format — the format itself is a decision. ~2 min.

## Slide 10 · When is a document required — and who owns it? _(Authoring)_

Cite the finding as a finding: published field experience says teams stop writing ADRs because the operational questions were never answered. Ask which of these five triggers they could answer for their own repos today — usually none. Champions co-lead the standards work from here on and the EM reviews the output — name the confirmed co-leads here (see the engagement plan; do not name anyone in shared material), and make sure the room knows a review is coming. ~4 min.

## Slide 11 · Drafting with Claude, honestly _(Authoring)_

Demonstrate the shape: the second prompt deliberately ends "leave Decision as a question for me to answer" — that clause is the difference between drafting and delegating. All five starters are in the handout's prompt table; these two are quoted from it verbatim. ~4 min.

## Slide 12 · Keeping them true _(Lifecycle)_

The incident-citing pattern is the most transferable thing in this block. Give the shape: "Rule: never X. Why: on <date> we did X and <consequence>." It is also the answer to the yes-man complaint from their interviews — rules with reasons survive pushback from a persuasive agent. ~2 min.

## Slide 13 · Demo — write an ADR

Transition. Tell them what to watch for: where the evidence comes from, and the moment I stop Claude and make the decision myself. And tell them now: you write yours immediately after, same subject, your own words.

## Slide 14 · A rule with no recorded reason _(Demo · The Gap)_

Show the actual directories, not the slide. Grep for imports of store.ts and show the boundary really holds. The "nothing checks it" line plants 2.b — don't explain it yet. ~3 min.

## Slide 15 · Evidence in, decision mine _(Demo · Draft)_

Narrate the wrong turns — if Claude writes a consequence that is really a benefit in disguise, say so and fix it. The honest cost is what makes an ADR credible; a document with only upsides is marketing. Note the shape on screen matches the shipped template exactly: a metadata bullet block, then THREE sections. ~8 min.

## Slide 16 · Now write yours — same subject, your words _(Your Turn)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive] This is the follow-along increment — everyone in the same state before the checkpoint. If anyone skipped the handout prep, now is when it bites: branch `feat/governance`, docs/labs pulled. Circulate; the common stall is over-polishing Context. Ten minutes, hard stop. Fast finishers: point at the stretch — derive the store-boundary clause list early, or review a neighbour's draft Decision. ~11 min.

## Slide 17 · Checkpoint 1 _(Checkpoint)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive] Do not advance past unresolved hands. Cheap to verify by walking the room. If more than two people are stuck, the cause is usually prompt shape — show yours again. Fast finishers go to the stretch list (handout): the store-boundary clauses or a peer review. ~3 min.

## Slide 18 · Your turn — derive a rule

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive] Scaffolding drops here — from following along to deciding. Announce the mode change explicitly; it should not be discovered.

## Slide 19 · Three fixes from last week _(Stimulus)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive] STIMULUS (settled from 1.b outcome): row C is a REAL, anonymised 1.b PR — students who shipped PRs did the loop properly, so shapes A and B are SYNTHETIC diffs against bugs #4/#5. Frame it once: nobody was ASKED to write a test last week — gap in the standard, not in a person. Then stop talking. BONUS BEAT (use in converge if energy is good): several of last week's fixes never became PRs at all — working code, invisible to review. Ask: what rule would catch a fix that never ships? Their own behaviour just raised a real governance question. ~4 min of reading.

## Slide 20 · Which are acceptable? Write the rule. _(Derive)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive] Ten minutes, tight — 1.b says this room waits to be told, so drive it: the FACILITATION LADDER, in order, per stalled group: (1) "Seed 2 — keep, tighten, or drop?" (2) "Fix B is green. Would seed 1 alone have caught it?" (3) "Which of your tags could a script actually decide — prove it: what does the script read?" Never state a clause yourself. Watch for the room deciding B is acceptable; that is the interesting case — do NOT tell them. Group B keeps faster tables on the second convention; its output feeds the merge. ~10 min.

## Slide 21 · Where we landed _(Converge)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive] MANDATORY: state and write the agreed clauses before advancing — an unresolved discussion is worse than none. Card contents are illustrative; replace live with what the room produced. If they missed "failed first", ask: "B was green before the fix. Would your rule have caught it?" Apply the tiebreak out loud when groups conflict. ~4 min.

## Slide 22 · Same file, three enforcement states _(The Hinge)_

Two minutes, and it is the hinge: written-unchecked, checked, half-checked all live in ONE file the room already trusts. The half-gate case is the stretch item — closing it is an ESLint rule away. This is Appendix C's logging-standards coverage: the convention exists; the class derives what checking it would mean. ~2 min.

## Slide 23 · What a mature team wrote _(Compare)_

Timing is the point: AFTER the room commits, so it reads as comparison, not answer key. Sanitised — no client, product, or domain detail; if asked, "another engagement, and that is all I can say." ~2 min.

## Slide 24 · Turn the clauses into an NFR _(Write It Up)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive] Circulate with one question per group: "how is that checked?" If they cannot answer, the clause is not finished. The skeleton on screen is also in the handout. Reserve the last five minutes for peer review — it is an acceptance criterion and the first thing skipped. ~20 min.

## Slide 25 · Checkpoint 2 _(Checkpoint)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive] Ask each group to read one fuzzy clause and its recorded decision aloud — two minutes, and it makes the standard real. Fast finishers: the half-gate stretch (write the ESLint clause) or the rules-file conversion. ~2 min.

## Slide 26 · A document nothing points at is a document nobody reads _(Wire It In)_

Name the two mechanisms out loud — trigger row vs binding line — and anchor both in 1.a: the trigger row is the lazy pointer they already know; the binding line is a deliberate eager load, kept to one sentence precisely because eager costs every session. The binding line is new vocabulary and it is graded. NFR-0001 has no binding line yet; they are setting the pattern. The smoke test takes 60 seconds: new session, ask the rule, watch whether it reads the doc or guesses. If it guesses, the trigger is phrased as a topic, not a situation — fixable in one edit. ~9 min.

## Slide 27 · Compare, reflect, capture _(Review & Retro)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · prompting depth right · checkpoint gates worked · mostly solo, fine · room waits to be told → 4 seed clauses + 10-min derive] Do not skip this to buy build time — it is the review+capture close Format B requires. INSTRUCTOR, within 24h: file the lab-capture entry (AI-Transformation-Playbook/04-labs/lab-capture-template.md) — what was built, stuck points, timings, refinements. This deck is the Format B pilot; the capture entry is how it gets validated. ~4 min.

## Slide 28 · Ship checklist, and what is next _(Wrap)_

Land the through-line: last week a habit, this week a standard, next week a gate. The wrap checklist mirrors the handout acceptance criteria exactly — read it as one list, not highlights. ~1 min.
