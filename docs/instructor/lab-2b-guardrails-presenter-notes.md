# Lab 2.b — Guardrails, and Making Standards Travel · Presenter Notes

Speaker notes for `lab-2b-guardrails.pptx` (the same text is attached to each slide's Notes pane).

> **Calibrated against the Lab 1.b room feedback (2026-08-12).** Slides whose notes open
> with **[CALIBRATED…]** carry the specific adjustment; nothing remains provisional.

## Slide 1 · Guardrails, and Making Standards Travel

Welcome to 2.b. The challenge in one breath: take the rule your group wrote last week and give it teeth — a hook that stops the agent while it writes, and a CI gate that stops anyone at merge time, both verified in both directions, with the unenforceable clauses honestly decided rather than quietly dropped. The interesting output today is not the hook — it is the list of things the hook could not check. ~1 min.

## Slide 2 · Two hours, hands-on _(Today)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built] The slack is real this time; protect it for verification, which is the step people skip. Prereq check right now, out loud: Lab 2.a done (ADR + NFR wired in), and the Hooks lesson done — anyone missing either pairs up for the build sections and catches up async per the handout. Assessment disclosure: same rubric, and today's hook or gate is also the Framework Practitioner artifact. ~2 min.

## Slide 3 · Where 2.a left us _(Recap)_

Fast. The only new idea is the last bullet — the premise of the block. Today REVISITS the 2.a NFR: the residue decisions recorded this session update that same document, not a new one. ~2 min.

## Slide 4 · The model layer cannot be the control. _(The Premise)_

Industry consensus, not our opinion — say so. The phrase to land: "model-independent governance." Connect to their own interview complaints about the agent being a yes-man and ignoring stated patterns — this is the failure mode it addresses. ~3 min.

## Slide 5 · Five layers of enforcement _(The Map)_

The honesty about this repo matters — it models the behaviour we want. Note the build framing precisely: layers 1–2 plus one layer-4 gate; a governance doc that overstates its own coverage is the failure mode. Layer 5 is not a gap in the others — it is what makes them credible. ~4 min.

## Slide 6 · The five-minute guardrail _(Warm-Up)_

Everyone, together, five minutes. This is the honest answer to "no restore points" and "it did something I did not expect" — the cheapest guardrail with the largest payoff, in every repo they own tomorrow. Teach ask-vs-deny while they type: deny the unrecoverable, ask the annoying — if everything asks, people stop reading, which is prompt fatigue and it kills the layer. Watch for pasting over the file; the handout has the before-state and names settings.local.json. ~5 min.

## Slide 7 · The hook already in your repo _(Layer 2)_

The message structure is the teaching point: BLOCKED / Why / Instead / Done means. A guardrail that only says no makes the agent guess, and it guesses creatively. Four lines turn a refusal into a redirection. ~3 min.

## Slide 8 · Block or nudge? Decide, do not default _(Severity)_

New material for most of the room. The nudge shape (PostToolUse + exit 2) is genuinely useful and almost nobody knows it: the edit lands, and Claude is told to fix it. Name the taxonomy refinement explicitly — mechanical, PARTLY, fuzzy — because their 2.a lists were binary and the middle bucket is where their hook will live. ~3 min.

## Slide 9 · An unverified guardrail is a belief _(Verification)_

Insist on this in the exercise. The usual death of a guardrail is not failing to block — it is blocking something legitimate on day three, getting disabled, and taking the layer with it. The evidence standard matters: a claim without the refusal text is not verified. ~2 min.

## Slide 10 · The bypass you write down _(Layer 5)_

The most senior idea in the block. The bypass rate is a signal about the RULE, not about discipline — if people constantly go around it, the rule is mis-scoped. That reframe lands well with leads. ~2 min.

## Slide 11 · Taught today, built at scale _(Layers 3–5)_

Sanitised exemplar — no client, product, or domain detail; if asked, "another engagement." The proportion is the insight: nine validators sounds heavy until you see the bypass is a single comment convention. ~2 min.

## Slide 12 · Rules about AI are just rules. _(The Meta-Case)_

Ninety seconds; it collapses a distinction people assume exists. If the room heads toward "we need an AI policy", the answer is: you need an NFR, and you wrote one last week. ~2 min.

## Slide 13 · Demo — build along, one guardrail

Transition. Two instructions: build along in your own copy as I go, and watch where the time goes — I will spend more time verifying than writing.

## Slide 14 · Read-only database unless approved _(Demo · The Rule)_

Deliberately parallel to the exhibit they just read — the shape is the point, not this rule. Make the two-rules distinction out loud; the review agent flagged it as the most likely novice confusion of the block. ~4 min.

## Slide 15 · Twenty lines, no dependencies _(Demo · The Check)_

Type it live if the room is comfortable; paste if behind. Say the Windows path normalisation out loud — it is the bug every group hits and why the hook is Node, not shell. Then register it together and restart sessions — the forgotten-restart is the "my hook never fires" stuck point. ~6 min.

## Slide 16 · Both directions, then the bypass _(Demo · Verify)_

Slow down here and say why: this is the step people skip. Both tests visibly. If your own hook false-positives live, that is a gift — work it through in front of them. ~6 min.

## Slide 17 · Checkpoint 1 _(Checkpoint)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built] Walk the room — this is a build-along, so everyone should be at this state, not just the instructor. Common failure: a path check that also catches db.json.example or a test fixture. Fast finishers: read protect-seed.js and diff the two hooks' messages. ~3 min.

## Slide 18 · The same pattern, somewhere you will recognise _(Your Stack)_

Three minutes, no hands-on. Why it is here: their real world is SQL Server and stored procedures, and the pattern they just built on a JSON file needs to visibly transfer. The false-positive row is the most valuable one — it is the PARTLY tag from the severity slide, in the wild. ~3 min.

## Slide 19 · The hook — enforce what you wrote _(Your Clause · 1 Of 3)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built] Circulate with one question: "what does your allow case replay?" If they have no answer, they are about to skip verification. Groups whose clause is store-boundary build the import check; test-discipline groups build the sibling-test nudge. ~15 min.

## Slide 20 · Checkpoint 2 _(Checkpoint)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built] Gate hard here: the CI-gate step depends on the clause being genuinely mechanical, which this checkpoint proves. Fast finishers: start the policy-bundle stretch or help a neighbour's allow case. ~2 min.

## Slide 21 · The same clause at merge time _(Your Clause · 2 Of 3)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built] The docs-only-PR question is where block-vs-warn becomes real — do not answer it for them. Residue is an acceptance criterion, not an optional extra: "the test must have failed first" needs a named owner or an explicit drop. ~10 min.

## Slide 22 · Point the reviewer at your standards _(Your Clause · 3 Of 3)_

Short and satisfying: the reviewer quoting their own NFR back at them is the moment governance stops being paperwork. The giget fallback matters — copies made before Jul 29 lack the agents folder. ~4 min.

## Slide 23 · Let us compare _(Review)_

Push hardest on the residue question — it reveals whether the lesson landed. A group with an empty residue column has either a trivial rule or has not looked. ~10 min.

## Slide 24 · The sixth artifact, and it is yours _(Hand-Off)_

Three minutes; framing over content. The guide is written for a team new to governance — it opens with the four terms, Crawl is one person's afternoon, and every tool option carries its trap named. Callback: this handout reached you as one canonical repo plus a pointer — crawl — and giget if you ran it, most of walk. Done = the template filled: rung, FIRST MOVE, and an owner who is a person. The two fields people skip are Owner and Not-doing-yet, and they are the two that matter. "We will decide later" is the only answer that costs more than acting. ~3 min.

## Slide 25 · What leaves this room _(Wrap & Retro)_

[CALIBRATED from Lab 1.b, 2026-08-12: agenda held · checkpoint gates worked · keep as built] Close on the deny/ask list — the thing every person applies tomorrow regardless of how far they got. Read the ship checklist as one list; it mirrors the handout exactly. INSTRUCTOR, within 24h: file the lab-capture entry (AI-Transformation-Playbook/04-labs/lab-capture-template.md) — outcomes, stuck points, timings, Format B observations. ~5 min.
