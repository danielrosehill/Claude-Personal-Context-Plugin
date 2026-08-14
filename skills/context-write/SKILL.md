---
name: context-write
description: The write path — draft an entry in full, show it, confirm scope and sensitivity, write it, index it, commit it. Use when the user says "remember that", when another skill has candidates to write, or when a consumer workspace proposes writes back.
---

# personal-context: context-write

Implements §8 of the contract. Every other skill that adds to the store goes through this one, so
that there is exactly one place where the rules about confirmation, indexing and committing live.

## Procedure

### 1. Draft

One entry per thing. Full frontmatter, body of two to five sentences, history line.

```markdown
---
id: pattern-conflict-withdrawal
type: pattern
title: Goes quiet before conflict
scopes: [relationship, career]
sensitivity: normal
source: interview
confidence: stated
created: 2026-08-14
updated: 2026-08-14
related: [person-h, person-m]
---

Describes withdrawing rather than raising a disagreement — "I just stop replying" — and
noticing it afterwards rather than at the time. Reports it in both work and home settings.

## History
- 2026-08-14 — created during intake, section 5
```

Assign `id` as `<type>-<slug>`. Check `INDEX.md` for collisions; ids are never reused, even after
a deletion.

### 2. Show and ask

Show the entry exactly as it will be written. Three questions, together:

1. Is this right — including the wording?
2. Is the scope right? (Name what the scope means in practice: "`career` means the work
   workspace sees this and the relationship one doesn't.")
3. Is the sensitivity right? (`high` means no workspace loads it unless you ask for it by name.)

Wait. Do not proceed on silence, and do not batch twenty entries into one confirmation.

### 3. Write

- New entry: write the file into the directory for its `type`.
- Existing entry: revise the body, bump `updated`, **append** a dated history line saying what
  changed and why. Never edit or remove existing history lines.

### 4. Index

Append or update the line in `INDEX.md`, in the right type group, keeping the format exact:

```markdown
- `pattern-conflict-withdrawal` — Goes quiet before conflict · scopes: relationship, career · normal
```

Update the header count and date.

### 5. Commit

If `backend: git`: check the remote is not public, then commit with a message naming what
changed (`context: add pattern-conflict-withdrawal`). Never push to a public remote. If a remote
resolves as public, stop and report it — do not commit either.

## Deletion

On request, without argument or persuasion: remove the file, remove the index line, say what was
removed. Under `git`, mention that the history still holds it and offer the harder removal if it
matters to them.

## Rules

- **Nothing is written unshown.** No exception for things they stated explicitly, no exception for
  small edits, no exception for "you already agreed to this pattern".
- **`confidence: inferred` never becomes `stated`** unless they state it in their own words.
- **Sensitivity never goes down** on your own initiative. It can always go up.
- **Never write situational detail** — an argument, a session, a bad week. That belongs in the
  workspace that produced it. If in doubt, it stays in the workspace.
- **Never infer and store** health conditions, sexuality, religion, politics or immigration
  status that were not stated.
- **One file per entry, always.** No combined files, no appending a person to a "people.md".
- Resolve the store with `sh "${CLAUDE_PLUGIN_ROOT}/scripts/paths.sh" --json` and the `path` in
  `config.json`; never hard-code a location, and never write anything under `~/.claude`.
- If the store path is missing, stop and say so. Do not create a store here, and do not fall back
  to any other memory mechanism.
