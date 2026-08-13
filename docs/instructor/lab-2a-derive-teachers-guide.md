# Lab 2.a teacher's guide — "Your turn: derive a rule" (Google Meet delivery)

How to run the 44-minute derivation block (deck slides 19–27), step by step, **over Google
Meet** — this class is remote, not in-room. Audience: instructors; **deliberately not linked
from any student-facing document** — it contains the expected-clause bank and the fix-B secret.
Companion to the slide notes, not a replacement: the notes carry the per-slide Q&A; this guide
carries the flow, the Meet mechanics, the scripts, and the recoveries.

Calibrated against the Lab 1.b delivery (2026-08-12 interview): this room's agenda held, its
checkpoint gates worked, and it **waits to be told** — every structural choice below (seed
clauses, the clock, the catch-test) exists because open-ended derivation would stall this cohort.

---

## 1. What this block is, in four sentences

Students read three fixes for the same bug and answer "which of these are acceptable?" — and the
answer, written as clauses, **is** the team's test-discipline standard. The group work produces
only a clause list; every graded artifact (the NFR document) is individual, written in each
student's own copy. The pedagogical bet: a standard the room argued into existence gets followed;
one an instructor dictated gets routed around. Your job is to keep the argument moving and land
it in writing — never to supply a clause.

**The one secret to protect:** fix B (the tautological test) is the interesting case. Do not
name it. The catch-test is designed so groups discover it themselves.

## 2. Remote mechanics — decide these before anything else

| Need                                 | Meet mechanism                                                                               | The gotcha                                                                                                                                                 |
| ------------------------------------ | -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Group work                           | **Two breakout rooms** (A: test discipline, B: store boundary), pre-configured, 10-min timer | You can only be in one room at a time — alternate ~2-min visits                                                                                            |
| Each group's clause list             | **One shared Google Doc**, one heading per group, link pasted in chat before breakouts       | Breakout-room chat does NOT carry back to the main room — a list typed in breakout chat is lost. The Doc also lets you monitor both groups without joining |
| The converged list                   | You type it in **main-room chat** (or the same Doc) at converge                              | **Meet chat is deleted when the call ends** — copy it out before you leave, it feeds the lab capture                                                       |
| "Would you merge it?"                | A **Meet poll** — three yes/no questions (Merge A? Merge B? Merge C?), pre-created           | Polls need the host to launch; results shown after all three close                                                                                         |
| Checkpoint verification              | **Paste into chat** — better than a show of hands: it's an artifact check by nature          | Ask for a specific pasteable line (see run sheet), not "done?"                                                                                             |
| Simultaneous answers (artifact beat) | **Chat waterfall**: "type your answer, don't send — 3, 2, 1, everyone send"                  | Prevents anchoring on the first loud answer                                                                                                                |
| 1:1 help during write-up             | **Slack** (#extra-duty-solutions-ai-training or DM) — Meet chat has no private messages      | Say this out loud at write-up start, or strugglers will sit silent                                                                                         |

## 3. Before the session — prep checklist

- [ ] Two breakout rooms configured; you know where the timer setting is
- [ ] The shared clause Doc created: title "Lab 2.a — derived clauses", headings **Group A
      (test discipline)**, **Group B (store boundary)**, **AGREED (converge)**; four seed
      clauses pasted under each group heading; link ready to paste in chat
- [ ] Poll pre-created: "Would you merge fix A? / fix B? / fix C?" (yes/no each)
- [ ] The three example diffs from §4 in a scratch file, ready to paste in chat or screen-share
- [ ] Under ~8 attendees: **one group, no breakout** — run the derive in the main room, drop
      the merge; the store boundary becomes stretch
- [ ] Deck at slide 19; block minutes: stimulus 4 · clock 1 · derive 10 · converge 4 ·
      contrast 2 · compare 2 · write-up 20 · checkpoint 2
- [ ] Sticky note to yourself: the compare slide (25) comes AFTER the room commits its list —
      shown earlier it becomes the answer key. And: **copy the chat before ending the call**

## 4. The three fixes — concrete diffs you can paste or share

Authored against Bug #4 from Lab 1.b (`stats.service.ts`: `COMPLETED_STATUS` was `'completed'`,
the domain status is `'done'`, so "Completed this week" always showed 0). Using the bug the room
actually fixed makes every example checkable against their own memory.

**Fix A — fixed under pressure, no test:**

```diff
- const COMPLETED_STATUS: string = 'completed';
+ const COMPLETED_STATUS: string = 'done';
```

One line, correct, obviously right — which is exactly why no test felt necessary. CI green.

**Fix B — fix + a test written afterwards, that also passes on the unfixed code:**

```diff
- const COMPLETED_STATUS: string = 'completed';
+ const COMPLETED_STATUS: string = 'done';
```

```ts
// stats.service.test.ts (new)
it('counts completed todos this week', () => {
  const summary = statsService.summary();
  expect(summary.completedThisWeek).toBe(0); // fixture's done todo is dated Jan 2026
});
```

The test is real, runs, and passes — **and it also passed before the fix**: the bug returned 0
and the fixture yields 0 either way. This is the authentic shape of 1.b's fixture trap, not an
invented strawman. Anyone who wrote a stats test in 1.b without completing a todo first wrote
this test.

**Fix C — failing test first (what the cohort's own PRs did):**

```ts
it('counts todos completed in the last 7 days', () => {
  todosService.complete('todo_a'); // stamps completedAt = now
  expect(statsService.summary().completedThisWeek).toBe(1); // RED before the fix
});
```

Then the same one-line fix, and the test goes green.

## 5. Minute-by-minute run sheet (Meet)

| T+   | Slide         | You                                                                                                                                                                                                                                                                                                                                       | The room          | Watch for                                                                                                    |
| ---- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------ |
| 0:00 | 19 divider    | Announce the mode change: "scaffolding drops here — you decide." The 40-minute shape in one breath (slide notes). State the split out loud: _the list is group work; the NFR is yours alone._ Paste the clause-Doc link in chat                                                                                                           | Opens the Doc     | Anyone who hasn't opened the Doc by the breakout — they'll be lost in the room                               |
| 0:02 | 20 stimulus   | Screen-share the slide; paste the §4 diffs in chat. "Four minutes, mics muted, read." Then **launch the poll**: Merge A? B? C?                                                                                                                                                                                                            | Reads, votes      | Do not editorialize while results come in — especially not about B                                           |
| 0:05 | —             | Show poll results, no commentary beyond: "hold your reasons — that's the group work." (B usually gets merged; say nothing)                                                                                                                                                                                                                | Sees the spread   | Resist explaining the "right" votes — the derive exists to produce that argument                             |
| 0:06 | 21 clock      | Present the clock in ONE minute: who writes in the Doc → verdict each seed (keep/tighten/drop + tag) with the **catch-test** (a clause earns keep only if you can name which of A/B/C it catches) → add your own → note your biggest disagreement. Open the breakouts, 10-min timer                                                       | Moves to rooms    | Groups that skip "who writes" — check the Doc after 2 min; an empty section means join that room             |
| 0:07 | 22 derive     | **Monitor the Doc; alternate ~2-min room visits.** In-room: use the ladder (§6) only if stalled. Between visits, the Doc tells you who is stuck without joining                                                                                                                                                                           | 10 min group work | A Doc section with polished wording but no verdicts/tags — substance stalled behind editing                  |
| 0:17 | 23 converge   | Close breakouts (auto-return). One voice per group reads its **biggest disagreement first**, then its list from the Doc. You type the agreed clauses under **AGREED** — in the Doc or chat, but somewhere everyone sees them accumulate. Tiebreak out loud when groups conflict (§6). Then the **artifact beat** as a chat waterfall (§6) | Defends, adjusts  | Nobody surfacing "failed first" — use the B nudge (§7)                                                       |
| 0:21 | 24 contrast   | Two minutes: same CLAUDE.md, three enforcement states. Their clauses have the same three states — that's what the tag was for                                                                                                                                                                                                             | Listens           | Don't let it grow — it's a hinge, not a lesson                                                               |
| 0:23 | 25 compare    | Show the mature NFR shape — **only now**. "What did you catch that they didn't?" — answers in chat                                                                                                                                                                                                                                        | Compares          | "Whose corpus is it?" → "another engagement, and that's all I can say"                                       |
| 0:25 | 26 write-up   | Start the 20 minutes, main room, mics muted, cameras optional. Say out loud: _"stuck? Slack me — Meet chat has no DMs."_ Every ~5 min, one whole-room nudge in chat: _"how is that clause checked?"_ Protect the final 5 for peer review: pairs by PR link order in chat                                                                  | Writes own NFR    | The "Checked by: code review" reflex (§7); silent strugglers — watch for who hasn't posted a PR link by T+40 |
| 0:42 | 27 checkpoint | Artifact check, chat edition: **"paste one clause + its Checked-by line into chat — fuzzy ones include the decision and a name."** Read them as they land; call out one good mechanical and one well-marked fuzzy                                                                                                                         | Pastes, verifies  | Fast finishers → stretch (half-gate ESLint clause; store-boundary track)                                     |
| 0:44 | —             | **Copy the chat and the AGREED list out of Meet now** — chat dies with the call; the list feeds the lab capture                                                                                                                                                                                                                           | —                 | —                                                                                                            |

## 6. Scripts — use these words or better ones

**The facilitation ladder** (stalled breakout; escalate in order, never state a clause):

1. "Seed 2 — keep, tighten, or drop?"
2. "Fix B is green. Would seed 1 alone have caught it?"
3. "Which of your tags could a script actually decide — prove it: what does the script read?"

**The tiebreak** (groups conflict at converge): _"The stricter clause wins — unless someone can
show it false-positives on real code in this repo. Anyone?"_ Say it as a rule, apply it once,
and it runs itself.

**The artifact beat** (30 seconds at converge, do not skip — run as a chat waterfall): _"Which
of the five artifacts is this list? Type your answer in chat, don't send… 3, 2, 1 — send."_
Someone typed ADR — that's the productive mistake. _"It feels like a decision. Run the quick
test: must always hold, and we can say how it's checked — that's an NFR. Present-tense law,
revised in place. If adopting it ever becomes genuinely contested, THAT argument earns an ADR.
And 'how do I write a failing test first?' — that's recipe material."_ One derivation, three
artifact homes.

**The landing line** (when someone asks how A or B happens): _"To careful people, on busy days.
That's why it needs a rule, and not a scolding."_

**The bonus beat** (converge, only if energy is good — and this one is true of this room):
_"Several of last week's fixes never became PRs at all. Working code, invisible to review. What
rule would catch a fix that never ships?"_

## 7. The expected-clause bank (never shown to students)

A converged list typically lands here. Use it to recognize completeness, not to steer:

| Clause                                                          | Tag                      | Notes                                                                                                                   |
| --------------------------------------------------------------- | ------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| A change under `server/src/**` ships with a test in the same PR | mechanical               | The anchor clause; catches A                                                                                            |
| The test failed before the fix                                  | **fuzzy**                | Catches B — **the clause that matters most, and no gate can decide it**. This is the finding, and 2.b's opening problem |
| Test file is co-located with the module                         | mechanical               | Seed 3 survives or tightens                                                                                             |
| Full suite green before the PR opens                            | mechanical               | Seed 4; usually kept as-is                                                                                              |
| Assertions test behaviour, not implementation                   | fuzzy                    | Often surfaces from fix B discussion                                                                                    |
| Docs-only changes are exempt                                    | mechanical (conditional) | If it appears, celebrate it — it becomes a CI path filter in 2.b                                                        |

**If nobody surfaces "failed first":** don't say it. Ask: _"B was green before the fix. Would
your rule have caught it?"_ If still nothing, run the catch-test on their kept clauses out loud
— none catches B, and the room will feel the hole. Only if all of that fails, at converge, say:
_"there's a clause hiding in fix C's description"_ and point at the slide.

**The "Checked by: code review" reflex:** a list where every clause's check is "review" is the
human gate as a default, not a decision. Push once, in chat, to everyone: _"could a script check
that one?"_

## 8. Failure modes and recoveries (Meet edition)

| Symptom                                        | Recovery                                                                                                         |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| A group's Doc section is empty after 2 minutes | Join that room. Ladder rung 1 — put them on seed 2; editing beats authoring                                      |
| One voice dominates a breakout                 | Hand the Doc to someone else: "you're on the list now — everyone else supplies clauses"                          |
| A group finishes deriving in 5 minutes         | In their room: catch-test audit out loud, then "add one clause the seeds missed" — the B hole usually appears    |
| Groups produce contradictory clauses           | Tiebreak, applied out loud, once. Then it's a rule, not a debate                                                 |
| Breakout timer expires mid-argument            | Let auto-return happen — the disagreement is the converge opener, not a loss                                     |
| Someone drops off the call                     | The Doc means they can rejoin without a recap; their NFR is individual anyway and completes async                |
| Chat floods during converge                    | "Doc only for clauses; chat for questions" — one channel per purpose                                             |
| Converge running long                          | Cut the _discussion_, never the writing — the AGREED list is the non-negotiable output                           |
| Whole block running long                       | Cut order: contrast slide → compare slide → never converge, never the write-up's peer-review 5 minutes           |
| "Just tell us the right answer"                | "There isn't one until you write it. That's the difference between this and every other rule you've been handed" |
| Only one group's worth of people               | Main room, no breakout, test-discipline only; the store boundary becomes stretch                                 |

## 9. After the session

- **The chat is gone when the call ends** — copy it, and the AGREED list, before leaving. The
  list goes into the lab-capture entry; it's the cohort-level artifact and next quarter's
  drift check
- Note which clauses the room derived that the bank above doesn't have — catalog refinement
- Unfinished NFRs complete async with every acceptance criterion intact, including peer review
  and the reflection note (Slack is the support channel)
- 2.b opens on the fuzzy clauses this session recorded: "the test failed first" is deliberately
  unresolved today — do not resolve it here
