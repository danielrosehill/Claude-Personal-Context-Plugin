---
name: ingest
description: Turn material the user already has — journals, notes exports, message archives, old therapy notes, a CV, letters — into context entries with provenance. Use when the user points at files or a folder and says "read this", "here's my journal", "use these notes".
---

# personal-context: ingest

The faster route in. Most people have years of relevant material lying around; reading it beats
interviewing them about the same period.

## Before starting

Resolve paths (`sh "${CLAUDE_PLUGIN_ROOT}/scripts/paths.sh" --json`), read the config, read
`INDEX.md` (so you can update rather than duplicate), and ask two questions:

1. **What is this material?** A journal is not a message export is not a CV; the reading strategy
   differs, and knowing the genre prevents category errors.
2. **What date range does it cover?**

Then say what you're going to do: read, propose entries, and write nothing until they've seen
each one.

## What to extract

Look for the durable and skip the situational. The test from the contract: *would this still be
true and useful in a workspace about something else?*

| Extract | Leave |
| --- | --- |
| People, and how the relationship works | What someone said on a Tuesday |
| Chapters with dates | Individual days |
| Events the person themselves marks as significant | Every dated occurrence |
| Recurring patterns they name about themselves | Moods |
| Care history, treatments, what helped | Session-by-session detail |
| Stated preferences about how to be treated | Passing irritations |

A hundred-page journal usually yields ten to twenty entries. If you have sixty candidates, you
are transcribing rather than extracting.

## Provenance

Every entry produced here carries:

```yaml
source: ingested
confidence: stated        # if the person wrote it as fact about themselves
                          # inferred  if you concluded it from what they wrote
```

and a history line naming the file and, where the format allows, the location:

```markdown
## History
- 2026-08-14 — ingested from `journals/2021.md`, entries of 2021-03 to 2021-06
```

Provenance is the whole reason ingestion is trustworthy. An entry that cannot say where it came
from should not be written.

## Procedure

1. **Inventory first.** List the files, sizes, formats and date coverage. Show it. Large exports:
   agree an order and work in passes rather than reading everything into context at once.
2. **Read a pass.** One source, or one date range.
3. **Draft candidates.** Group by type. For each: the entry as it would be written, and the line
   or passage it came from.
4. **Review together.** They will correct a third of them, and the corrections are usually more
   informative than the entries.
5. **Write the confirmed ones** via the write protocol. Update `INDEX.md`.
6. **Report coverage** — which files were read, which weren't, and what date ranges are still
   dark. Feeds `gap-scan`.

## Merging with existing entries

If a candidate matches an existing entry (same person, same period, same pattern), **update
rather than duplicate**: revise the body, append a history line naming the new source, bump
`updated`. Match on `id` and `aliases` first, title second. When unsure whether two things are
the same person, ask — a wrongly merged person entry is hard to unpick later.

## Rules

- **Never write the raw material into the store.** The store holds entries; the journal stays
  where it is. Reference it by path.
- **Never infer sensitive attributes** — health conditions, sexuality, religion, politics,
  immigration status — from material where they were not stated. Not at any confidence level.
- **Quote sparingly and mark it.** A sentence of theirs is often the best body text; a page is a
  copy of the journal.
- **Old material is dated, not current.** Something true in 2019 goes in as a `period` or `event`,
  not as a `situation`. This is the most common ingestion error.
- **Heavy material:** if what you're reading is distressing, say so plainly before summarising it
  back at them, and ask whether they want it in the store at all.
- Ask before reading anything they did not explicitly point at, even if it sits in the same
  folder.
