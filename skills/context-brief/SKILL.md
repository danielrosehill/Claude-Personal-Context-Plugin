---
name: context-brief
description: Assemble a scoped background briefing for a workspace or a task — read only the entries whose scopes match, and say which they were. Use at the start of a session in a consumer workspace, or when the user asks "what do you know about me for this".
---

# personal-context: context-brief

The read path. Implements §7 of the contract.

The value of this skill is what it *doesn't* load. A background layer that dumps everything into
every session is a liability: it surfaces the divorce in the job workspace and makes the person
stop trusting the store. Scoped retrieval is the whole design.

## Inputs

Scopes come from, in order of precedence:

1. Arguments to the invocation (`--scopes=career,general`).
2. `memory/config.yaml` in the current workspace, if one exists.
3. Asking. Never guess, and never default to "everything".

Plus `include_sensitive` (default false) and any `exclude` list.

## Procedure

1. Resolve the config with `sh "${CLAUDE_PLUGIN_ROOT}/scripts/paths.sh" --json` (never hard-code
   a path; see `docs/storage-paths.md`), and read `config_file` for the backend and store. If the store
   is unreachable: say so, continue without background context, and **do not** substitute any
   model-managed memory. A missing store is a visible condition, not a silent one.
2. Read `scopes.yaml` and `INDEX.md`.
3. Select: `entry.scopes ∩ requested ≠ ∅`, minus `sensitivity: high` (unless asked), minus
   exclusions.
4. Read the selected entry files. Nothing else, however interesting the titles are.
5. Emit the brief.
6. **Say what you loaded** — titles, one line. Non-negotiable, even when the material is dull.

## Output shape

Compact. This is loaded at the top of somebody else's session and every line spends attention
they wanted to spend elsewhere.

```markdown
### Background — scopes: general, career (11 entries, 2 held back as sensitive)

**Basics.** <identity, one line> · <situation, one line>

**People.** M — line manager since 2023, relationship strained since the reorg.
· J — closest colleague, left in March. · …

**History.** 2019–2023 Berlin, first company. · 2024-01 moved to current role.

**Patterns.** Goes quiet before conflict rather than raising it (their words:
"I just stop replying"). · …

**How to work with them.** Direct over reassuring. Don't summarise back.
Don't offer three options.

_Held back: 2 entries marked sensitive. Ask if relevant._
```

Rules for the brief itself:

- Preferences always last and always included — they change how the rest of the session goes.
- Quote their phrasing where the entry has it.
- Never editorialise. The brief relays; it does not interpret.
- If a `high` entry was withheld, say that one was, without saying what.

## Freshness

If `situation` is more than six months old, or an entry's `review_after` has passed, mark it
inline: `(stale, last updated 2025-11)`. Do not silently present stale context as current — a
job that ended is worse than no job entry at all.

## Rules

- **Only what was asked for.** Reading an unscoped entry "for context" is a contract violation.
- **Always disclose the load.** Every time, briefly.
- **Never cache across sessions.** Re-read the files; that is what makes an edit take effect.
- **Never write.** This skill is read-only, including "correcting" something you noticed was
  wrong. Note it and offer `context-review`.
