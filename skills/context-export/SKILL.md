---
name: context-export
description: Produce a portable bundle of the whole store — every entry as markdown, plus INDEX.md, scopes.yaml and a manifest. The conformance test for portability. Use when moving backends, backing up, or checking the store is actually portable.
---

# personal-context: context-export

Implements §10 of the contract. Also the honesty test for the whole design: if the store cannot
be exported in one command and read without this plugin, then it is a memory feature with extra
steps.

## Procedure

1. Read the config. Ask for a destination; default
   `~/.claude-user-data/personal-context-export-YYYYMMDD/`.

2. Copy every entry as markdown, preserving the directory structure, plus `INDEX.md` and
   `scopes.yaml` verbatim.

   For `backend: mcp`, this is the real work: pull every entry from the server and render it to
   the schema. If the server cannot round-trip the required frontmatter fields, say so plainly —
   that backend does not conform, and the export is lossy in a way the person should know about
   before they rely on it.

3. Write `manifest.json` at the export root:

   ```json
   {
     "contract_version": 1,
     "exported": "2026-08-14T12:00:00Z",
     "backend": "filesystem",
     "source_path": "/home/<user>/.claude-user-data/personal-context",
     "entry_count": 34,
     "types": {"person": 9, "period": 4, "event": 6, "pattern": 7, "care": 3, "preference": 5},
     "scopes": ["general", "career", "family", "relationship", "health"],
     "sensitivity": {"low": 4, "normal": 27, "high": 3}
   }
   ```

4. Copy the contract itself alongside it (`context-contract.md`), so the bundle is
   self-describing to whoever opens it in five years with no idea what produced it.

5. **Verify**: count files on disk against `manifest.entry_count` and against the lines in
   `INDEX.md`. Three numbers that agree. If they don't, say which is authoritative (the files)
   and what's inconsistent — a stale `INDEX.md` is the usual cause and is itself worth fixing.

6. Report the destination, the counts, and a one-line reminder that the bundle contains
   everything including `sensitivity: high` entries.

## Filtered exports

If they ask for a partial export — one scope, or excluding sensitive entries — do it, and record
the filter in the manifest as `"filter": {"scopes": ["career"], "include_sensitive": false}`. A
filtered bundle must say it is filtered; an unlabelled partial export is how someone later
concludes material was lost.

Common reason for this: handing context to a different tool, or to a person. In that case offer
to strip `sensitivity: high` by default.

## Rules

- **Never upload the bundle anywhere.** No cloud, no gist, no paste, no attachment — not even to
  a service the person uses for everything else. Local destination only, and if they want it
  elsewhere they move it themselves.
- **Never place the export inside a git repo** without checking its remote visibility first.
- The export is a copy. Nothing in the source store is modified, moved or cleaned up by this
  skill.
