# Personal context store

This is your background context layer: who is in your life, what has happened, how you want to
be spoken to. It exists so that scoped workspaces — one per issue, project or domain — can read
what they need instead of asking you again every time.

**These are your files.** Plain markdown, one entry per file, readable and editable by hand with
nothing running. Change a sentence you disagree with. Delete an entry you'd rather not have. It
takes effect the next time something reads the store, because there is no other copy.

## Layout

| Directory | Holds |
| --- | --- |
| `profile/` | Basics, and your current situation |
| `people/` | One file per person |
| `history/` | Chapters (`period`) and dated things that mattered (`event`) |
| `patterns/` | Recurring things, in your words |
| `care/` | Clinicians, diagnoses as reported, treatments tried, medication |
| `preferences/` | How you want to be engaged with |
| `facts/` | Durable, useful, fits nowhere else |
| `examples/` | Sample entries showing the format. Delete them whenever you like |

`INDEX.md` is the map — one line per entry. `scopes.yaml` defines your scopes.

## Two things worth understanding

**Scopes.** Each entry says which slices of life it belongs to; each workspace says which slices
it may read. The work workspace doesn't load the relationship material. If everything is scoped
`general`, that mechanism does nothing — keep `general` small.

**Sensitivity.** `high` means no workspace loads it unless you ask for it by name in that
session. Use it freely; nothing is lost by marking something sensitive.

## What does not belong here

The situational: an argument, a bad week, a session. That belongs to the workspace where it came
up. The test is whether it would still be true and useful somewhere else entirely.

## Keeping it private

Never a public repository, never uploaded, never shared as a bundle without checking what's in
it. If you version it with git, keep the remote private.

## Spec

The format is specified independently of any tool:
<https://github.com/danielrosehill/Claude-Personal-Context-Plugin/blob/main/docs/context-contract.md>
