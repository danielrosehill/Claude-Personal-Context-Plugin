# The Portable Context Contract

**Version 1** · last revised 2026-08-14

A specification for a persistent, portable, human-legible store of personal background context
that AI workspaces can read from and propose writes to.

This document is the canonical source. Anything else — this plugin's skills, the
[therapy workspace template](https://github.com/danielrosehill/Claude-Therapy-Workspace-Template),
any future consumer — implements what is written here. If an implementation and this document
disagree, this document is right and the implementation is a bug.

---

## 1. Why a contract rather than a feature

Every capable assistant now ships a memory feature. They are all incompatible, none of them
export meaningfully, none of them let you scope what gets recalled, and all of them are a
function of a vendor account that may not outlive the material in it.

Personal background context — who is in your life, what has already happened to you, how you
want to be spoken to — is exactly the category of data you should expect to still hold in ten
years, across three tools you haven't heard of yet. So it is specified as files, not as a
feature.

### Principles

1. **Files, not features.** Markdown with YAML frontmatter. Readable with `cat`, editable in any
   editor, greppable, diffable, versionable.
2. **No model-managed memory.** Implementations must not use provider-side or automatic memory
   for storage or retrieval, and must not fall back to it when the store is unreachable.
3. **Scoped reads.** A consumer declares which scopes it may load. Loading the whole store
   because it is available is a defect, not a convenience.
4. **Proposed writes.** Nothing is written without the person seeing it as it will be written and
   confirming. Inference stays labelled as inference.
5. **Append-only history.** Entry bodies are revised; entry histories are appended. What was once
   believed is part of the record.
6. **The person can read everything.** There is no internal representation. What the agent knows
   is the set of files, and they can open them.

---

## 2. Store layout

```text
<store-root>/
  README.md              written for a human opening this cold
  INDEX.md               one line per entry — the map (generated, but committed)
  scopes.yaml            scope definitions
  profile/               identity and current situation
  people/                one file per person
  history/               periods and dated events
  patterns/              recurring things, self-described
  care/                  clinicians, diagnoses, treatments, medication
  preferences/           how the person wants to be engaged
  facts/                 anything durable that fits nowhere above
  examples/              sample entries, shipped with the scaffold (delete or keep)
```

Filenames are `<slug>.md`, lowercase, hyphenated, stable. The `id` in frontmatter is the
identifier of record; renaming a file without updating references is the one destructive
mistake this format permits.

**Where the store lives** is resolved rather than fixed, and never inside the assistant's own
configuration directory (`~/.claude` for Claude Code). An implementation resolves, in order: an
explicit override, a user-declared data root (`$CLAUDE_USER_DATA`), an existing plugin data root
already on disk — adopted rather than duplicated — and only then a default of
`~/.claude-user-data/<implementation>/`. See `storage-paths.md` for the reference
implementation of that rule.

---

## 3. Entry schema

Every entry is one markdown file: YAML frontmatter, a short body, a history section.

```markdown
---
id: person-m
type: person
title: M — line manager, 2023–present
scopes: [career]
sensitivity: normal
source: interview
confidence: stated
created: 2026-08-14
updated: 2026-08-14
review_after: 2027-08-14
aliases: []
related: [period-current-role]
---

Two to five sentences. Third person, factual, present tense where it is still true.
No interpretation, no adjectives that the person did not use themselves.

## History
- 2026-08-14 — created during intake interview
```

### Fields

| Field | Required | Values | Notes |
| --- | --- | --- | --- |
| `id` | yes | `<type>-<slug>` | Stable. Referenced by `related`. Never reused. |
| `type` | yes | see §4 | Determines the directory. |
| `title` | yes | free text | How the entry appears in `INDEX.md` and in briefs. |
| `scopes` | yes | list, see §5 | Which consumers may load it. `[general]` if it applies everywhere. |
| `sensitivity` | yes | `low` `normal` `high` | `high` is never loaded unless asked for by name. |
| `source` | yes | `interview` `ingested` `inferred` `user-written` | Where the content came from. |
| `confidence` | yes | `stated` `corroborated` `inferred` | Epistemic status of the content, separate from its origin. |
| `created` | yes | `YYYY-MM-DD` | |
| `updated` | yes | `YYYY-MM-DD` | Bumped on every body revision. |
| `review_after` | no | `YYYY-MM-DD` | For things that go stale — jobs, addresses, treatments. |
| `aliases` | no | list | Other names for the same subject, for matching. |
| `related` | no | list of ids | Bidirectional by convention; the reviewer fixes one-way links. |
| `period` | no | `YYYY[-MM]/YYYY[-MM]` or `YYYY-MM/present` | For `period` and `event` types. |

`source` and `confidence` are deliberately distinct. Something can be `source: interview,
confidence: inferred` — they said it, but as a guess about themselves. Something can be
`source: ingested, confidence: stated` — pulled from a document in which they stated it plainly.

### Body rules

- **Two to five sentences.** An entry that needs more is two entries.
- **Third person, factual.** "M has managed the team since 2023" not "M is difficult".
- **Their vocabulary.** If they said "burnt out", the entry says burnt out, not "experienced
  occupational exhaustion".
- **No interpretation in the body.** An interpretation is a `pattern` entry with
  `confidence: inferred`, not an adjective smuggled into a `person` entry.

---

## 4. Types

| `type` | Directory | Holds | Example title |
| --- | --- | --- | --- |
| `identity` | `profile/` | Name, pronouns, languages, where they live. Minimal. | "Basics" |
| `situation` | `profile/` | Current life situation: work, household, health at a high level. Reviewed often. | "Current situation — Aug 2026" |
| `person` | `people/` | One person and what they are to the subject. | "M — line manager" |
| `period` | `history/` | A chapter with a start and usually an end. | "2019–2023 — Berlin" |
| `event` | `history/` | A dated thing that mattered. | "2024-03 — father's death" |
| `pattern` | `patterns/` | Something recurring, self-described or agreed. | "Withdraws before conflict" |
| `care` | `care/` | Clinicians, diagnoses, treatments tried, medication. | "CBT with R, 2022–2023" |
| `preference` | `preferences/` | How they want to be engaged with. | "Directness over reassurance" |
| `fact` | `facts/` | Durable and useful, fits nowhere else. | "Works night shifts" |

`care` entries default to `sensitivity: high`. Diagnoses are recorded as the person reports them,
with who gave them and when — never as an assessment made by the agent.

---

## 5. Scopes

A scope is a slice of a life. Consumers declare which they may read; entries declare which they
belong to. The intersection is what loads.

`scopes.yaml` in the store root:

```yaml
contract_version: 1
scopes:
  general:      Applies everywhere. Keep this small — it is loaded by every consumer.
  career:       Work, colleagues, employers, professional identity.
  family:       Family of origin and household.
  relationship: Partner, romantic history.
  health:       Physical and mental health, care, medication.
  money:        Finances, obligations, security.
  faith:        Religious and communal life.
  # add your own; the list is not normative
```

Rules:

- **`general` is a budget, not a default.** Everything in it is read by every workspace forever.
  A store where most entries are `general` has no scoping.
- An entry may carry several scopes. A person who is both a colleague and a friend belongs to
  both, and that is not a modelling failure.
- Scopes are not permissions. They are relevance filters chosen by the person. Anyone with the
  files has the files.

### Sensitivity

| Level | Loaded when |
| --- | --- |
| `low` | Any scope match. |
| `normal` | Scope match. The default. |
| `high` | Never by scope match alone. Only when the consumer sets `include_sensitive: true`, or the person raises the material in session and asks for it. |

An agent must never lower a sensitivity level on its own, and must never quote a `high` entry it
was not asked to load.

---

## 6. `INDEX.md`

The map. One line per entry, grouped by type, regenerated whenever entries change and committed
with them. It exists so a consumer can decide what to read without reading everything.

```markdown
# Index

Contract version 1 · 34 entries · updated 2026-08-14

## people
- `person-m` — M — line manager, 2023–present · scopes: career · normal
- `person-h` — H — spouse · scopes: relationship, family, general · normal

## patterns
- `pattern-conflict-withdrawal` — Withdraws before conflict · scopes: relationship, career · normal
```

Format per line: `` `id` `` — title · `scopes: a, b` · sensitivity. Nothing else — the index is
read in full by every consumer and must stay cheap.

---

## 7. Read protocol

A consumer holds a config declaring `store` (backend, path), `read.scopes`,
`read.include_sensitive`, and `read.exclude`.

1. Read `scopes.yaml` and `INDEX.md`.
2. Select entries where `scopes ∩ read.scopes ≠ ∅`.
3. Drop `sensitivity: high` unless `include_sensitive` is true.
4. Drop anything matching `read.exclude`.
5. Read the selected files. Nothing else.
6. **State what was loaded** — entry titles, in one line, to the person. Silent loading of
   personal context is not acceptable behaviour even when the material is innocuous.

If the store path does not exist: say so and continue without background context. Do not create
it silently, do not guess, and do not substitute any other memory mechanism.

---

## 8. Write protocol

1. **Draft** the entry in full, exactly as it will be written, frontmatter included.
2. **Show** it. Ask three questions: is it right, is the scope right, is the sensitivity right.
3. **Write** only what is confirmed. One file per entry.
4. **Index** — append the line to `INDEX.md`.
5. **Commit** if the backend is `git`. Never push to a public remote.

Updating an existing entry: revise the body, bump `updated`, append a dated line to `## History`
saying what changed and why. History lines are never edited or removed.

Deleting: on request, without argument. Remove the file, remove the index line, say what was
removed. If the backend is versioned, note that history retains it and offer the harder removal
if that matters to them.

**Never** promote `confidence: inferred` to `stated` without the person stating it. **Never**
write an entry from a single session's material if it is specific to the situation being
discussed — situational material belongs to the consumer workspace, not the store.

---

## 9. Backends

The payload is identical in every case. A backend only changes where the files live and what
happens after a write.

| Backend | `path` / `server` | After write |
| --- | --- | --- |
| `filesystem` | Directory | Nothing |
| `obsidian` | Vault root | Nothing. Entries may use `[[wikilinks]]` in `related` for graph view |
| `git` | Repo working tree | `git commit`. Push only to a private remote |
| `mcp` | Server name in `.mcp.json` | Whatever the server does — it must accept and return the schema above |

A vector or graph-backed memory service (Supermemory, mem0, a Pinecone-backed server, an
Obsidian graph) is a legitimate backend **provided the markdown files remain the source of
truth** and can be regenerated by export. A server already serving another contract — for
example the one behind
[claude-user-memory](https://github.com/danielrosehill/Claude-User-Memory-Plugin) — can serve
this one too, as long as it round-trips every required frontmatter field without loss. An implementation where the authoritative copy lives
only inside a service does not conform, whatever its retrieval quality.

---

## 10. Export

Conformance test: a single command produces a directory containing every entry as markdown, plus
`INDEX.md`, `scopes.yaml` and a `manifest.json`:

```json
{
  "contract_version": 1,
  "exported": "2026-08-14T12:00:00Z",
  "backend": "filesystem",
  "entry_count": 34,
  "types": {"person": 9, "period": 4, "event": 6, "pattern": 7, "care": 3, "preference": 5}
}
```

If that export cannot be produced, the store is not portable and the contract is not being met,
whatever else is working.

---

## 11. Prohibitions

An implementing agent must not:

- use built-in, provider-side or automatically-managed memory for any part of this;
- read outside the scopes it was granted, "for context";
- write to the store without explicit per-entry confirmation;
- record situational detail from a consumer workspace into the store;
- infer and store sensitive attributes — health, sexuality, religion, politics, immigration
  status — that the person did not state, at any confidence level;
- lower a `sensitivity` value, or promote a `confidence` value, on its own initiative;
- push a store to a public remote, or include store content in a public repository, ever;
- place the store or its configuration inside the assistant's own configuration directory
  (`~/.claude`), which couples material meant to outlive the tool to the tool itself;
- create a second user-data root when one already exists, or migrate an existing one unasked.

---

## 12. Versioning

`contract_version: 1` appears in `scopes.yaml` and in export manifests. Additive changes — new
optional fields, new types — do not bump it. Changes to required fields, read filtering or the
write protocol do, and this document keeps the changelog.

### Changelog

- **1** (2026-08-14) — initial specification.
