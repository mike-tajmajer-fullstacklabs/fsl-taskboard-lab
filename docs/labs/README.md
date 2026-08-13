# Lab handouts

Student-facing material for the Lab 2 blocks. Read the handout for the block you're in.
Every handout also ships as a **PDF** (same name, `.pdf`) for offline reading and distribution.

| Block   | Handout                                                      | You'll produce                                                                                                                                                             |
| ------- | ------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **2.a** | [Writing the Standards Down](lab-2a-handout.md)              | An ADR + an NFR (unenforceable clauses marked), wired into CLAUDE.md, PR-reviewed                                                                                          |
| **2.b** | [Guardrails, and Making Standards Travel](lab-2b-handout.md) | A verified hook + CI gate, a documented bypass, a decision per clause — plus the "how we use these" README, a distribution decision with an owner, and a named port target |

Both demos are written down for replay at your own pace:
[`lab-2a-demo-walkthrough.md`](lab-2a-demo-walkthrough.md) (the ADR — six steps, prompts, example
replies, the finished document) and
[`lab-2b-demo-walkthrough.md`](lab-2b-demo-walkthrough.md) (the guardrail — seven steps with the
code, both verifications, the bypass).

Snippets to copy into your own repo live in [`snippets/`](snippets/) — one of them (2.b's settings block) must be **merged** into an existing file, never pasted over it:

| File                  | Used in | What it is                                                                   |
| --------------------- | ------- | ---------------------------------------------------------------------------- |
| `hook-skeleton.js`    | 2.b     | Hook plumbing — block and nudge shapes, two throwaway rules. Replace them    |
| `governance-gate.yml` | 2.b     | CI gate plumbing, including the `fetch-depth: 0` gotcha                      |
| `seed-lab2-issues.sh` | 2.a     | Optional — seeds the Lab 2 backlog into your copy so `Closes #N` still works |

## Why these are snippets and not files in your repo

Your copy was created from the template **before** these materials existed, and template copies
don't inherit later upstream changes. So the canonical copy lives here and you pull what you
need into your own repo.

Copy-paste from GitHub's raw view works. Or pull the whole folder:

```bash
npx giget gh:mike-tajmajer-fullstacklabs/fsl-taskboard-lab/docs/labs docs/labs
```

That is not incidental — Lab 2.b ends on a ladder of ways a standard reaches every repo, and you
just used the bottom of it. One canonical repo plus a pointer is the rung 2.b calls _crawl_;
pulling a copy on demand is most of the next rung, _walk_ — the missing half is the **pin**, a
version tag that would let you tell whether your copy is current (this repo doesn't carry tags
yet). You're using the thing you're about to be taught.

## Also worth reading

- [`../best-practices/enforcing-a-convention.md`](../best-practices/enforcing-a-convention.md) — takeaway card for applying the guardrail pattern in your own codebase, on your own conventions. Independent follow-up, supported in office hours.
- [`../best-practices/distributing-standards.md`](../best-practices/distributing-standards.md) — the Collective-layer artifact your team defines: how a standard reaches every repo, and how you know you're current. Options, trade-offs, and a template for recording the decision. Handed over at the end of Lab 2.b.
