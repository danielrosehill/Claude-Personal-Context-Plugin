---
name: context-review
description: Periodic maintenance of the store — staleness, contradictions, over-broad scopes, orphaned links, entries that should be split or merged, and anything the user wants removed. Use every few months, or when a brief surfaces something that is no longer true.
---

# personal-context: context-review

A background context store decays in a specific way: things stay true-looking after they stop
being true. A job that ended, a relationship that changed, a treatment that stopped. Stale
context is worse than absent context, because it is confidently wrong and nobody asked.

## Procedure

1. **Read everything.** Permitted here, as in `gap-scan`. Say so.

2. **Check, in this order:**

   | Check | Action |
   | --- | --- |
   | `review_after` passed | Ask: still true? |
   | `situation` older than 6 months | Ask directly; this one is nearly always stale |
   | `person` entries with `present`-ended periods | Ask whether the relationship still runs that way |
   | `care` entries with no end date | Ask whether it's ongoing |
   | Contradictions between entries | Present both, ask; never resolve by recency |
   | `related:` pointing at missing ids | Fix or drop the link |
   | One-way `related:` links | Make bidirectional |
   | Entries scoped `general` | Challenge each one — is it really read by *every* workspace? |
   | Entries over ~6 sentences | Propose a split |
   | Near-duplicate entries | Propose a merge, showing the merged result |
   | Entries with no history line | Backfill from `created` |

3. **Report** as a numbered list of proposed changes, grouped by kind, each with the current text
   and the proposed text. Let them accept individually — "yes to 1, 3 and 7" must work.

4. **Apply** through the write protocol, one entry at a time, history lines appended.

5. **Regenerate** `INDEX.md` header counts and date.

## Superseding rather than overwriting

When something has changed rather than been wrong, prefer a new entry plus a closing edit on the
old one:

- `period` entries get an end date rather than deletion.
- A former therapist's `care` entry gets `2022–2023` and stays.
- A relationship that ended keeps its `person` entry; the body says what it is now.

The store is a record of a life, not a snapshot of the present. Deleting the past to keep the
present tidy destroys most of what makes it worth having.

## Removal on request

If they want something gone, remove it — file, index line, and any `related:` references pointing
at it. Say what was removed and what still references it. No argument, no "are you sure", no
suggestion to lower the sensitivity instead.

## Rules

- **Ask before every change.** A review that silently tidies is indistinguishable from data loss.
- **Never delete history lines.** They are the record of what was believed and when.
- **Never resolve a contradiction by picking the newer entry.** Ask.
- **Do not use a review to go fishing.** New material comes from intake, ingestion or a
  workspace — not from a maintenance pass that starts asking questions about gaps it noticed.
  (`gap-scan` is where that belongs, and only on request.)
- Keep the run finite. Twenty proposals maximum; note that there are more and offer another pass.
