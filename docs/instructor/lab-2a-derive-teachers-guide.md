# Lab 2.a teacher's guide — "Your turn: derive a rule" (Google Meet delivery)

How to run the 44-minute derivation block (deck slides 19–27), step by step, **over Google
Meet** — this class is remote, not in-room. Audience: instructors; **deliberately not linked
from any student-facing document** — it contains the expected-clause bank and the fix-B secret.
Companion to the slide notes, not a replacement: the notes carry the per-slide Q&A; this guide
carries the flow, the Meet mechanics, the scripts, and the recoveries.

Calibrated against the Lab 1.b delivery (2026-08-12 interview): this room's agenda held, its
checkpoint gates worked, and it **waits to be told** — every structural choice below (seed
clauses, the clock, the catch-test, the timed nudges) exists because open-ended derivation
would stall this cohort.

**The work is individual by design** — no breakout rooms, no group lists. Each student derives
their own clause list; the class compare that follows is calibration, not committee work. This
is deliberate: the course must also work self-guided, so nothing in the derive may depend on
having other people in the room. What the class adds is the compare — lists side by side, one
AGREED list — and that is the only shared step.

---

## 1. What this block is, in four sentences

Students read three fixes for the same bug and answer "which of these are acceptable?" — and the
answer, written as clauses, **is** the team's test-discipline standard. Each student derives
their own clause list solo, then the class puts the lists side by side and agrees ONE — and
every graded artifact (the NFR document) is individual, written in each student's own copy. The
pedagogical bet: a standard the room argued into existence gets followed; one an instructor
dictated gets routed around. Your job is to keep the argument moving and land it in writing —
never to supply a clause.

**The one secret to protect:** fix B (the tautological test) is the interesting case. Do not
name it. The catch-test is designed so students discover it themselves.

## 2. Remote mechanics — decide these before anything else

| Need                                 | Meet mechanism                                                                            | The gotcha                                                                                                                                   |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Each student's clause list           | **One shared Google Doc**, one heading per student, link pasted in chat before the derive | Lists typed only in chat are lost when the call ends — and the Doc is how you monitor everyone's progress without interrupting anyone        |
| Pacing the solo derive               | **Timed whole-call chat nudges** at ~3 / ~6 / ~8 min (§6) — the same clock for everyone   | Nudges go to the whole call, never to a name — a named nudge on an open call is a call-out                                                   |
| The AGREED list                      | You type it in the Doc's **AGREED** section at converge, screen-sharing the Doc           | **Meet chat is deleted when the call ends** — anything that must survive (the list, retro lines) lives in the Doc or gets copied out         |
| The three diffs                      | **In the shared Doc**, above the student sections — never in chat                         | Meet chat mangles code (no monospace) — anything needed DURING the derive must be in the Doc                                                 |
| "Would you merge it?"                | A **Meet poll** — three yes/no questions (Merge A? Merge B? Merge C?), pre-created        | Polls need the host to launch; if your Meet edition lacks polls, run it as a chat waterfall instead ("type three letters, Y or N for A/B/C") |
| Checkpoint verification              | **Paste into chat** — better than a show of hands: it's an artifact check by nature       | Ask for a specific pasteable line (see run sheet), not "done?"                                                                               |
| Simultaneous answers (artifact beat) | **Chat waterfall**: "type your answer, don't send — 3, 2, 1, everyone send"               | Prevents anchoring on the first loud answer                                                                                                  |
| 1:1 help                             | **Slack** (#extra-duty-solutions-ai-training or DM) — Meet chat has no private messages   | Say this out loud at derive start AND write-up start, or strugglers will sit silent                                                          |

**Call norms, announced once at the divider:** mics muted by default; unmute freely at
converge; cameras on for converge and the artifact beat, optional during silent reading, the
derive, and the write-up. Quiet stretches are deliberate — say so, or dead air reads as a
dropped connection.

**If a champion co-leads:** assign them the Doc and Slack — they watch every student section
fill (or not) while you hold the clock and the call. Brief them on exactly two things: the
nudge ladder (§6), and that they never state a clause. Without a co-lead, the Doc is your
second pair of eyes.

**Presence is traceable remotely — use that.** By converge, every attendee should have left a
trace: a poll vote, a Doc section with verdicts in it, a chat paste. Anyone with zero traces
gets a quiet Slack ping, not a call-out on the call.

## 3. Before the session — prep checklist

- [ ] The shared clause Doc created: title "Lab 2.a — derived clauses", the three §4 diffs at
      the top, the four seed clauses listed once below them, then **one heading per student
      (by name)** and an **AGREED (converge)** heading at the bottom; link ready to paste in
      chat. Sharing set to "anyone with the link can edit"
- [ ] Poll pre-created: "Would you merge fix A? / fix B? / fix C?" (yes/no each)
- [ ] Deck at slide 19; block minutes: stimulus 4 · clock 1 · derive 10 · converge 4 ·
      contrast 2 · compare 2 · write-up 20 · checkpoint 2
- [ ] The three nudge lines from §6 in a scratch buffer, ready to paste at ~3 / ~6 / ~8 min
- [ ] Sticky note to yourself: the compare slide (25) comes AFTER the class commits its list —
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

| T+   | Slide         | You                                                                                                                                                                                                                                                                                                                                                                                                | The room           | Watch for                                                                                                     |
| ---- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------- |
| 0:00 | 19 divider    | Announce the mode change: "scaffolding drops here — you decide." The 40-minute shape in one breath (slide notes). State the split on mic: _everything you produce today is yours alone; the class compare is calibration, not committee work._ Give the call norms (mics, cameras, deliberate quiet). Paste the Doc link, confirm access                                                           | Opens the Doc      | Anyone who hasn't found their name heading in the Doc — they'll be lost at the paste step                     |
| 0:02 | 20 stimulus   | Screen-share the slide; the §4 diffs are in the Doc. Announce the quiet on purpose: "four minutes of silent reading — this call goes quiet now, I'll speak at the timer." Post "T+4 = poll" in chat. Then **launch the poll**: Merge A? B? C?                                                                                                                                                      | Reads, votes       | Do not editorialize while results come in — especially not about B                                            |
| 0:05 | —             | Show poll results, no commentary beyond: "hold your reasons — you'll spend them in the derive." (B usually gets merged; say nothing)                                                                                                                                                                                                                                                               | Sees the spread    | Resist explaining the "right" votes — the derive exists to produce that argument                              |
| 0:06 | 21 clock      | Present the clock in ONE minute: 0–4 verdict each seed (keep/tighten/drop + tag) with the **catch-test** (a clause earns keep only if you can name which of A/B/C it catches) → 4–7 add your own → 7–9 mark the one you're LEAST sure about → 9–10 paste your list into the Doc under your name. Say once: _"stuck? Slack me — no DMs in Meet chat."_ Start the 10 minutes                         | Starts solo        | Anyone editing the seed list in place instead of their own section — redirect in chat, once, unnamed          |
| 0:07 | 22 derive     | **Mics stay muted; monitor the Doc, not faces.** Paste the §6 nudges into chat at ~3 / ~6 / ~8 min — whole call, never a name. A struggling student gets a Slack ping, not a call-out. Never state a clause                                                                                                                                                                                        | 10 min solo derive | A section with polished wording but no verdicts/tags — substance stalled behind editing. Empty sections at ~6 |
| 0:17 | 23 converge   | **Switch your screen-share to the Doc** — the lists are now side by side. Name the clauses MOST lists already agree on (fast wins), then ask two or three people to unmute and read their **least-sure clause** — that's where the standard gets made. You type the agreed clauses under **AGREED**. Tiebreak on mic when lists conflict (§6). Then the **artifact beat** as a chat waterfall (§6) | Defends, adjusts   | Nobody surfacing "failed first" — use the B nudge (§7)                                                        |
| 0:21 | 24 contrast   | Two minutes: same CLAUDE.md, three enforcement states. Their clauses have the same three states — that's what the tag was for                                                                                                                                                                                                                                                                      | Listens            | Don't let it grow — it's a hinge, not a lesson                                                                |
| 0:23 | 25 compare    | Show the mature NFR shape — **only now**. "What did you catch that they didn't?" — answers in chat                                                                                                                                                                                                                                                                                                 | Compares           | "Whose corpus is it?" → "another engagement, and that's all I can say"                                        |
| 0:25 | 26 write-up   | Start the 20 minutes, main room, mics muted, cameras optional. Say out loud again: _"stuck? Slack me."_ Every ~5 min, one whole-room nudge in chat: _"how is that clause checked?"_ Protect the final 5 for peer review: pairs by PR link order in chat                                                                                                                                            | Writes own NFR     | The "Checked by: code review" reflex (§7); silent strugglers — watch for who hasn't posted a PR link by T+40  |
| 0:42 | 27 checkpoint | Artifact check, chat edition: **"paste one clause + its Checked-by line into chat — fuzzy ones include the decision and a name."** Read them as they land; call out one good mechanical and one well-marked fuzzy                                                                                                                                                                                  | Pastes, verifies   | Fast finishers → stretch (half-gate ESLint clause; the store boundary, same method)                           |
| 0:44 | —             | **Copy the chat and the AGREED list out of Meet now** — chat dies with the call; the list feeds the lab capture                                                                                                                                                                                                                                                                                    | —                  | —                                                                                                             |

## 6. Scripts — use these words or better ones

**The nudge ladder** (paste into chat at ~3 / ~6 / ~8 min — whole call, escalating, never a
clause):

1. ~3 min: _"Seed 2 — keep, tighten, or drop? If you haven't verdicted a seed yet, start there."_
2. ~6 min: _"Fix B is green. Would your list, as written right now, have caught it?"_
3. ~8 min: _"Which of your tags could a script actually decide — what does the script read?
   Two minutes to paste."_

Fast finishers (a full section before ~6): Slack them the stretch — _"same method, second
subject: the store boundary. Derive it."_ Never announce the stretch on the call mid-derive; it
reads as pressure to the rest.

**The tiebreak** (lists conflict at converge): _"The stricter clause wins — unless someone can
show it false-positives on real code in this repo. Anyone?"_ Say it as a rule, apply it once,
and it runs itself.

**The artifact beat** (30 seconds at converge, do not skip — run as a chat waterfall): _"Which
of the five artifacts is this list? Type your answer in chat, don't send… 3, 2, 1 — send."_
Someone typed ADR — that's the productive mistake. _"It feels like a decision. Run the quick
test: must always hold, and we can say how it's checked — that's an NFR. Present-tense law,
revised in place. If adopting it ever becomes genuinely contested, THAT argument earns an ADR.
And 'how do I write a failing test first?' — that's recipe material."_ One derivation, three
artifact homes.

**The dissent line** (someone's list lost at converge): _"AGREED is what you write up — and
your version goes in the NFR as a dropped clause with a reason. That's how disagreeing with a
live standard works on a real team: recorded, not erased."_

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
your rule have caught it?"_ If still nothing, run the catch-test on the AGREED list on mic —
none catches B, and the call will feel the hole. Only if all of that fails, at converge, say:
_"there's a clause hiding in fix C's description"_ and point at the slide.

**The "Checked by: code review" reflex:** a list where every clause's check is "review" is the
human gate as a default, not a decision. Push once, in chat, to everyone: _"could a script check
that one?"_

## 8. Failure modes and recoveries (Meet edition)

| Symptom                                    | Recovery                                                                                                                                        |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| A student's Doc section is empty at ~6 min | Quiet Slack ping with ladder rung 1 — put them on seed 2; editing beats authoring. Never name them on the call                                  |
| Several sections empty at ~6 min           | The whole-call nudge isn't landing — unmute and say rung 1 out loud, once, then go quiet again                                                  |
| Someone finishes deriving in 5 minutes     | Slack them the catch-test audit ("which of A/B/C does each clause catch?"), then the store-boundary stretch — the B hole usually appears        |
| Lists conflict at converge                 | Tiebreak, applied out loud, once. Then it's a rule, not a debate                                                                                |
| The 10 minutes expire mid-thought          | Call the paste anyway — an unfinished list with verdicts beats a polished one without; converge fills the gaps                                  |
| Someone drops off the call                 | The Doc means they can rejoin without a recap; the derive and the NFR are individual anyway and complete async                                  |
| Chat floods during converge                | "Doc only for clauses; chat for questions" — one channel per purpose                                                                            |
| Converge running long                      | Cut the _discussion_, never the writing — the AGREED list is the non-negotiable output                                                          |
| Whole block running long                   | Cut order: contrast slide → compare slide → never converge, never the write-up's peer-review 5 minutes                                          |
| "Just tell us the right answer"            | "There isn't one until you write it. That's the difference between this and every other rule you've been handed"                                |
| Doc link doesn't open for someone          | Sharing was restricted — flip the Doc to "anyone with the link can edit" and re-paste; do this in the first minute, not mid-derive              |
| Nobody unmutes at converge                 | Name a section, not a volunteer: "whoever's least-sure clause is about test timing — walk us through it." A writer always has something to read |
| Everyone's list is identical (rare)        | Suspiciously clean — run the catch-test on it live; identical lists usually share the same B-shaped hole                                        |

## 9. After the session

- **The chat is gone when the call ends** — copy it, and the AGREED list, before leaving. The
  list goes into the lab-capture entry; it's the cohort-level artifact and next quarter's
  drift check
- Note which clauses students derived that the bank above doesn't have — catalog refinement
- Unfinished NFRs complete async with every acceptance criterion intact, including peer review
  and the reflection note (Slack is the support channel)
- 2.b opens on the fuzzy clauses this session recorded: "the test failed first" is deliberately
  unresolved today — do not resolve it here
