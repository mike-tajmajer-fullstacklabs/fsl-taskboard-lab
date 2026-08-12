# Lab 2.b — Guardrails · Presenter Notes

Speaker notes for `lab-2b-guardrails.pptx` (the same text is attached to each slide's Notes pane).

> Slides marked **[PROVISIONAL]** depend on the Lab 1.b room feedback — pacing, the
> stimulus diffs, and the derivation scaffolding. Everything else is settled.

## Slide 1 · Guardrails

Welcome to 2.b. Last week you wrote standards. Today you find out which parts of them a machine can actually hold, and what to do about the rest. Open with the honest framing: the interesting output of today is not the hook — it is the list of things the hook could not check. ~1 min.

## Slide 2 · Two hours, hands-on _(Today)_

**[PROVISIONAL]** This block has genuine slack because the distribution discussion moved out. Protect the verify-both-directions step — it is the one people skip and the one that separates a guardrail from a belief. ~2 min.

## Slide 3 · Where 2.a left us _(Recap)_

Fast. The only new idea on this slide is the last bullet, and it is the premise of the whole block. Do not re-teach 2.a. ~3 min.

## Slide 4 · The model layer cannot be the control. _(The Premise)_

This is the industry consensus, not our opinion — say so. The phrase worth landing is "model-independent governance": the check survives a model upgrade. Connect it to their own complaints from the interviews about the agent being a yes-man and ignoring stated patterns — that is exactly the failure mode this addresses. ~4 min.

## Slide 5 · Five layers of enforcement _(The Map)_

The honesty about the repo having only two layers matters — it models the behaviour we want from them. A governance doc that overstates its own coverage is the failure mode. Note that layer 5 is not a gap in the others, it is what makes them credible. ~4 min.

## Slide 6 · The five-minute guardrail _(Warm-Up)_

Everyone does this together, right now, five minutes. This is the honest answer to "there are no restore points" and "it did something I did not expect" from their interviews — the cheapest guardrail with the largest payoff, and it works in every repo they own tomorrow. Watch for people pasting over the file and destroying the seed rules; call it out before they start. ~5 min.

## Slide 7 · Why three verdicts and not two _(Layer 2)_

The prompt-fatigue point is the insight here. A permission scheme that asks about everything trains people to approve without reading, which is worse than a narrower scheme they actually attend to. ~3 min.

## Slide 8 · The hook already in your repo _(Layer 2)_

The message structure is the teaching point: BLOCKED / Why / Instead / Done means. A guardrail that only says "no" makes the agent guess, and it will guess wrong in a creative direction. Four lines turn a refusal into a redirection. ~4 min.

## Slide 9 · Block or nudge? Decide, do not default _(Severity)_

New material for most of the room. The nudge shape (PostToolUse + exit 2) is genuinely useful and almost nobody knows it exists: the edit lands, and Claude is told to fix it. Emphasise the footnote — over-blocking is how the whole layer gets disabled. ~4 min.

## Slide 10 · An unverified guardrail is a belief _(Verification)_

Insist on this in the exercise. The most common outcome of an unverified guardrail is not that it fails to block — it is that it blocks something legitimate on day three, gets disabled, and takes the whole layer with it. ~3 min.

## Slide 11 · The bypass you write down _(Layer 5)_

This is the most senior idea in the block and it is worth the time. The bypass rate is a signal about the RULE, not about discipline — if people are constantly going around it, the rule is mis-scoped. That reframe usually lands well with leads. ~3 min.

## Slide 12 · What we are teaching but not building today _(Layers 3–5)_

Sanitised exemplar — no client, product, or domain detail; if asked, "another engagement." The useful contrast is proportion: nine validators sounds like a lot until you notice their bypass mechanism is a single comment convention. Governance is not volume. ~3 min.

## Slide 13 · Rules about AI are just rules. _(The Meta-Case)_

Worth 90 seconds because it collapses a distinction people assume exists. If the room is heading toward "we need an AI policy", this is the answer: you need an NFR, and you already wrote one last week. ~2 min.

## Slide 14 · Demo — one guardrail, end to end

Transition. Tell them what to watch for: I will spend more time verifying than writing.

## Slide 15 · Read-only database unless approved _(Demo · The Rule)_

Deliberately parallel to the exhibit they just read — the point is that the shape is reusable, not that this rule is important. Keep the code minimal; the interesting slides are the next two. ~5 min.

## Slide 16 · Twenty lines, no dependencies _(Demo · The Check)_

Type it live if the room is comfortable; paste if you are behind. The one thing to say out loud is the Windows path normalisation — it is the bug every group will hit and the reason the hook is Node rather than a shell script. ~8 min.

## Slide 17 · Both directions, then the bypass _(Demo · Verify)_

Slow down here deliberately, and say why you are slowing down: this is the step people skip. Do both tests visibly. If your own hook has a false positive live, that is a gift — work it through in front of them. ~7 min.

## Slide 18 · Checkpoint _(Checkpoint)_

**[PROVISIONAL]** Walk the room. The common failure is a path check that also catches db.json.example or a test fixture. Two minutes of checking here saves the exercise. ~3 min.

## Slide 19 · The same pattern, somewhere you will recognise _(Your Stack)_

Four minutes, no hands-on. The reason it is here: their real world is SQL Server and stored procs, and the pattern they just watched on a JSON file needs to visibly transfer. The false-positive row is the most valuable one — do not skip it to save time. ~4 min.

## Slide 20 · Enforce the clause you wrote last week _(Your Turn)_

**[PROVISIONAL]** Thirty-five minutes. Circulate with one question: "what happens on a docs-only PR?" That is where the block-vs-nudge decision becomes real. Remind them the residue decision is an acceptance criterion, not an optional extra — "the test must have failed first" needs a named owner or an explicit drop. ~35 min.

## Slide 21 · Let us compare _(Review)_

Push hardest on the residue question — it is the one that reveals whether the lesson landed. A group with an empty residue column either has a trivial rule or has not looked hard enough. ~15 min.

## Slide 22 · One artifact left, and it is yours _(Hand-Off)_

Three minutes, and the framing matters more than the content. The guide (docs/best-practices/distributing-standards.md) is written for a team new to governance — it opens with the four terms on this slide, Crawl is a checklist one person can finish in an afternoon, and every tool option carries its trap named (semble needs --content docs; gh search code returns silent empty results). Callback: this handout reached you as one canonical repo plus a pointer — giget if you ran it — so the room has already used Crawl and Walk today without deciding anything. The third rung needs a decision. What "done" looks like: the template on the right, filled in — a rung, a first move, and an owner who is a person rather than a committee. The two fields people skip are Owner and Not-doing-yet, and they are the two that matter. "We will decide later" is the only answer that costs more than acting. ~3 min.

## Slide 23 · What leaves this room _(Wrap)_

Close on the deny/ask list, not the hook — it is the thing every single person can apply tomorrow regardless of how far they got today. Then the three continuations, with office hours named as the place for the first one: bring the repo, not a question. ~5 min.
