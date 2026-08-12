# Lab 2.a — Writing the Standards Down · Presenter Notes

Speaker notes for `lab-2a-writing-the-standards-down.pptx` (the same text is attached to each slide's Notes pane).

> Slides marked **[PROVISIONAL]** depend on the Lab 1.b room feedback — pacing, the
> stimulus diffs, and the derivation scaffolding. Everything else is settled.

## Slide 1 · Writing the Standards Down

Welcome to Lab 2.a. Two hours, mostly hands-on. By the end you will have authored an ADR and an NFR against real gaps in this repo, and wired both into CLAUDE.md. Frame it up front: last week was about using context; this week is about writing the context down so it is shared rather than personal. ~1 min.

## Slide 2 · Two hours, mostly hands-on _(Today)_

**[PROVISIONAL]** Set expectations: this block is less typing than 1.b and more deciding. Two things you will be asked to do that may feel unusual: read code cold and write a rule from it, and mark which parts of your own rule a machine could not check. ~2 min.

## Slide 3 · Where we start _(Setup)_

Practical only. The snippets point is worth 20 seconds because it previews the last topic of 2.b: template copies do not inherit upstream changes, which is exactly the problem a distribution mechanism solves. ~5 min including pairing.

## Slide 4 · Sixteen developers, sixteen private setups _(Why)_

Do not oversell. This room is already positive about AI; the pitch is not "use AI", it is "stop solving the same problem sixteen times." Name the finding from their own assessment so it lands as their diagnosis rather than ours. ~3 min.

## Slide 5 · Generated context files made things worse. _(The Evidence)_

This is the slide that justifies the whole block, so do not rush it. The point is not "AI cannot write docs" — it is that a doc nobody thought about is negative value, because it costs tokens and misleads. Ask the room: who has run /init and never read the output? Hands will go up. ~3 min.

## Slide 6 · Collective, Project, Feature _(Scope)_

Keep this short — it is a map, not a lesson. The payoff is that it explains why the sixth artifact (how standards travel) is different in kind: it is the only Collective-layer one, and it is the one we hand back to them in 2.b. ~2 min.

## Slide 7 · Five types — and the question each answers _(The Artifacts)_

Read the middle column aloud, row by row — the questions do the teaching, not the artifact names. Do not define each one at length here; slides 7 and 8 do that work better. ~3 min.

## Slide 8 · One subject, five artifacts _(Differentiation)_

THE slide of the block. Spend time here. Take the same subject and walk it across all five rows, then land the one-word summary line. If someone says "that is a lot of documents for one rule" — good, that is the next slide: you would not write all five, you write the one that answers the question you actually have. ~5 min.

## Slide 9 · Telling them apart when it is unclear _(Differentiation)_

Do not read all 30 cells. Point at the two rows named in the footnote and let people read the rest. The check row is the bridge to 2.b; the load row is why you would ever choose a rules file over CLAUDE.md — always-loaded context is expensive. ~4 min.

## Slide 10 · How big should it get? _(Claude.Md)_

Pre-empt the obvious objection: they saw a 72-line CLAUDE.md in 1.a and will meet 500-line ones in the wild. Both are correct at their scale. The mechanism that makes the difference is the trigger table — phrase triggers as situations ("changing response shapes") not topics ("API"), because the agent matches on what it is doing. ~3 min.

## Slide 11 · Two rungs, and when to graduate _(Adr)_

Do not sell MADR. The light template is right for this team now; the point of showing both is that they will meet the heavier one and should know it is the same idea with the alternatives written down. Mention that a mature corpus we have seen contains an ADR recording its own choice of ADR format — that usually gets a laugh and makes the point that the format itself is a decision. ~3 min.

## Slide 12 · Two rungs — and the field that matters _(Nfr)_

This is the most load-bearing slide for next week. If they leave with one habit from 2.a, it should be writing the check before the wording. Say plainly: a clause you cannot check is still worth writing, but it must be MARKED, because a standard that pretends to be enforced gets trusted further than it deserves. ~3 min.

## Slide 13 · Recipes and rules files _(The Cheap Two)_

Short slide by design; the differentiation work is already done. The one genuinely new idea is path-scoped loading, which most of the room will not have seen. Show testing.md briefly if there is a laptop up. ~2 min.

## Slide 14 · When is a document required? _(Authoring)_

Cite the finding as a finding, not an opinion — published field experience says teams stop writing ADRs because the operational questions were never answered, not because the format was wrong. Then ask the room which of these five triggers they could answer for their own repos today. Usually none. That is the gap. ~3 min.

## Slide 15 · Who writes, who reviews, where it lives _(Authoring)_

This is where champions get named. If Gideon and Trishton are co-leading, say so here — it models the "authored by a few" point instead of just asserting it. The EM reviewing the output is the acceptance gate; make sure the room knows a review is coming. ~3 min.

## Slide 16 · Drafting with Claude, honestly _(Authoring)_

Demonstrate the shape rather than describing it: the second prompt deliberately ends "leave Decision as a question for me to answer." That single clause is the difference between drafting and delegating. Tell them the prompt starters card at the end has all five. ~4 min.

## Slide 17 · Keeping them true _(Lifecycle)_

The incident-citing pattern is the most transferable thing in this block — it is what stops a standard reading as arbitrary. Give a concrete shape: "Rule: never X. Why: on <date> we did X and <consequence>." Note that this is also the answer to the yes-man complaint from their interviews: rules with reasons survive pushback from a persuasive agent. ~3 min.

## Slide 18 · Demo — write an ADR

Transition. Tell them: watch for two things — where the evidence comes from, and the moment I stop Claude and make the decision myself.

## Slide 19 · The gap we are documenting _(Demo · Reproduce)_

Show the actual directories on screen, not the slide. Grep for imports of store.ts and show that the boundary really does hold. The "nothing checks it" line plants 2.b — do not explain it yet, just let them notice. ~4 min.

## Slide 20 · Evidence in, decision mine _(Demo · Draft)_

Narrate the wrong turns — if Claude writes a consequence that is really a benefit in disguise, say so out loud and fix it. The honest cost ("one more hop for simple reads") is what makes an ADR credible; a document with only upsides reads as marketing. ~8 min.

## Slide 21 · Checkpoint 1 _(Checkpoint)_

**[PROVISIONAL]** Do not advance past unresolved hands. This checkpoint is cheap to verify by walking the room. If more than two people are stuck, the likely cause is prompt shape, not understanding — show your prompt again. ~3 min.

## Slide 22 · Your turn — derive a rule

**[PROVISIONAL]** Scaffolding drops here. This is the part of the block where you stop following and start deciding. Say that explicitly — the change in mode should be announced, not discovered.

## Slide 23 · Three fixes from last week _(Stimulus)_

**[PROVISIONAL]** INSTRUCTOR: use three real 1.b PRs if all three shapes exist; otherwise synthesise. Anonymise the diffs, and if the "no test" example is someone in the room, use a synthetic one instead. Frame it once, up front: nobody was ASKED to write a test last week, so this is a gap in the standard, not in a person. Then stop talking. ~5 min of silence and reading.

## Slide 24 · Which of these are acceptable? Write the rule. _(Derive)_

**[PROVISIONAL]** Fifteen minutes. Circulate; do not answer. If a group stalls, go to their two seeded clauses and ask "would you keep this, tighten it, or drop it?" — editing is far easier than authoring. Watch for the room converging on B being acceptable; the tautological test is the interesting case and they often miss it. Do NOT tell them.

## Slide 25 · Where we landed _(Converge)_

**[PROVISIONAL]** MANDATORY: state and write down the agreed clauses before advancing. An unresolved discussion is worse than none. The card contents here are illustrative — replace them live with what the room actually produced. If they did not surface "failed first", ask: "B was green before the fix. Would your rule have caught it?" ~5 min.

## Slide 26 · What a mature team wrote _(Compare)_

Timing matters more than content here: this comes AFTER the room commits to its own list, so it reads as comparison rather than the answer key. Sanitised — no client, product, or domain detail. If someone asks whose it is, the answer is "another engagement, and that is all I can say." ~3 min.

## Slide 27 · Turn the clauses into an NFR _(Write It Up)_

**[PROVISIONAL]** Circulate and ask one question per group: "how is that checked?" If they cannot answer, the clause is not finished. Reserve the last five minutes for the peer review — it is in the acceptance criteria and it is the first thing to get skipped. ~20 min.

## Slide 28 · Checkpoint 2 _(Checkpoint)_

**[PROVISIONAL]** Different in kind from Checkpoint 1 — there is no command to run. Ask each group to read one fuzzy clause and its recorded decision aloud. That takes two minutes and makes the standard real. ~3 min.

## Slide 29 · A document nothing points at is a document nobody reads _(Wire It In)_

The smoke test is the whole point and takes 60 seconds — new session, ask the rule, watch whether it reads the doc or guesses. If it guesses, the trigger is phrased as a topic rather than a situation. That is the most common failure and it is fixable in one edit. ~15 min.

## Slide 30 · What you built, and what is next _(Wrap)_

Land the through-line: last week a habit, this week a standard, next week a gate. Point at the prompt starters in the handout and the Slack channel. If anything is unfinished, it finishes async and still needs a review — the acceptance list does not shrink because the clock ran out. ~5 min.
