---
description: Read material the user already has — journals, notes exports, message archives, old therapy notes, a CV — and propose context entries with provenance.
argument-hint: "<path to file or folder>"
---

# /personal-context:ingest

Run the `ingest` skill against `$1`.

Extracts the durable and skips the situational. Every entry produced carries `source: ingested`
and a history line naming the file it came from. Nothing is written without being shown first,
and the raw material stays where it is.
