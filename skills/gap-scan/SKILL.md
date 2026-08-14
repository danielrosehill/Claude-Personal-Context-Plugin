---
name: gap-scan
description: Read what the store already holds and work out what is missing, thin, stale or contradictory — then ask targeted questions instead of generic ones. Use after ingestion, periodically, or when the user says "what's missing", "what else do you need to know".
---

# personal-context: gap-scan

Phase two. Generic intake questions are hard to answer; specific ones are easy. "Who else was
around during the Berlin years?" gets a real answer where "tell me about your life" gets a
shrug. That difference is what this skill exists to produce.

## Procedure

1. **Read the whole store.** This is one of the two skills permitted to (the other is
   `context-review`), because gap analysis is meaningless on a slice. Say that you're doing it.

2. **Score coverage** by type and by period:

   | Check | Gap when |
   | --- | --- |
   | Types | A type has no entries at all — commonly `preference` and `pattern` |
   | Chronology | A stretch of years with no `period` or `event` |
   | People | A person referenced in another entry's body who has no entry |
   | Relations | `related:` links that point at nothing, or point one way only |
   | Scope balance | Almost everything is `general` — the store has no scoping |
   | Staleness | `review_after` in the past; `situation` older than six months |
   | Contradiction | Two entries that cannot both be true |
   | Thinness | Entries of one sentence, or with no history line |

3. **Produce the report** — grouped, shortest section first, with a count so it's obviously
   finite:

   ```markdown
   ## Coverage
   34 entries · people 9 · period 4 · event 6 · pattern 7 · care 3 · preference 5 · fact 0

   ## Gaps
   - No entries for 2016–2019. The only reference is "before Berlin" in period-berlin.
   - `person-r` is referenced by care-cbt-2022 but has no entry.
   - No `preference` entries. Every workspace is guessing at how to talk to you.

   ## Stale
   - `situation-current` — updated 2025-11, review_after passed 2026-05.

   ## Contradictions
   - period-berlin says 2019–2023; event-fathers-death (2021-03) says "while I was in Tel Aviv".

   ## Over-broad
   - 14 of 34 entries are scoped `general`. Suggested re-scopes below.
   ```

4. **Ask, at most five questions, one at a time.** Pick the gaps that would change the most
   downstream: missing `preference` entries and missing people beat a thin decade. Every question
   names what prompted it — "`care-cbt-2022` mentions R; who is R?" — so it doesn't read as
   interrogation.

5. **Write confirmed answers** through the write protocol. Contradictions are resolved by asking,
   never by picking the newer entry.

## What is not a gap

- Something they declined to answer during intake. Skipped is a decision, not a hole. Do not
  re-ask; you may list it once under a *Deliberately empty* heading if they asked for a full
  report.
- A period they have said they don't want in the store.
- Anything the schema allows to be absent. `facts/` being empty is fine.

## Rules

- **Five questions maximum per run.** A gap report that generates thirty questions gets closed.
- **Never ask for sensitive material because the schema has a slot for it.** An empty `care/`
  directory is not a gap unless they say it is.
- **Report contradictions neutrally.** Two accounts of the same period usually mean an imprecise
  date, not a lie.
- **Do not fill gaps by inference.** A gap stays a gap until answered.
- Offer to stop after the report. Reading the analysis without answering anything is a legitimate
  outcome, and often the person just wanted to see what the system thinks it knows.
