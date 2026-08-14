# Claude Personal Context Plugin

Builds and maintains a **persistent, portable background context layer** about you — who is in
your life, what has already happened, how you want to be spoken to — so that every scoped
workspace can read it instead of asking you again.

Intake interview, ingestion of material you already have, gap analysis, scoped retrieval,
maintenance, and export. Your files, your store, a documented format.

[![Contract](https://img.shields.io/badge/Spec-Portable%20Context%20Contract-blue?style=flat)](docs/context-contract.md)
[![Workspace template](https://img.shields.io/badge/Consumer-Therapy%20Workspace%20Template-green?style=flat&logo=github)](https://github.com/danielrosehill/Claude-Therapy-Workspace-Template)
[![Index](https://img.shields.io/badge/Index-Mental%20Health%20Templates-purple?style=flat&logo=github)](https://github.com/danielrosehill/Claude-Mental-Health-Templates-Index)

---

## The problem

Workspaces work best when they are narrow — one issue, one domain, one question. Narrow
workspaces have one failure mode: you re-explain your life at the top of every one. Do that
three times and you stop opening new ones.

The usual fix is a memory feature. Those are vendor-specific, unexportable, unscoped, and tied
to an account. Personal background context is the last category of data that should be.

So: one store, outside every workspace, in plain markdown, at a path you choose.

```text
        ~/.claude-user-data/personal-context/     ← this plugin builds and maintains it
                              │
         ┌────────────────────┼────────────────────┐
         ▼                    ▼                    ▼
   career workspace    relationship ws.      grief workspace
   scopes: [general,   scopes: [general,     scopes: [general,
            career]              relationship]         family]
```

Each consumer declares which scopes it may read. The career workspace never loads the
relationship material, not because of a permission system, but because that is what it asked
for and what it says out loud that it loaded.

## Explicitly not a memory feature

The plugin refuses to use model-managed or provider-side memory, and instructs its consumers to
do the same. Everything durable is a file you can `cat`, edit and delete. See §1 and §11 of the
[contract](docs/context-contract.md).

## How it's built — two phases

**Phase 1 — give it what you already have.**
Most people have years of relevant material: journals, notes apps, message exports, old therapy
notes, a CV, letters. `/personal-context:ingest` reads what you point it at and proposes entries
with provenance. Nothing is written without you seeing it.

**Phase 2 — fill the gaps.**
`/personal-context:gaps` reads what exists, works out what's missing or stale against the
schema, and asks targeted questions instead of generic ones. Answering "who else was around
during 2019–2023?" is easier than answering "tell me about your life".

`/personal-context:intake` runs the sectioned interview if you'd rather start from a
conversation, or have nothing to ingest. It's resumable, and every section is skippable.

## Skills and commands

| Invoke | Does |
| --- | --- |
| `context-init` | Choose a backend, write config, scaffold the store |
| `intake-interview` | Sectioned, resumable interview — the conversational route in |
| `ingest` | Turn material you already have into entries, with provenance |
| `gap-scan` | Find what's missing, thin, stale or contradictory; ask about it |
| `context-brief` · `/personal-context:brief` | Assemble a scoped briefing for a workspace |
| `context-write` · `/personal-context:remember` | The write path: propose, confirm, write, index |
| `context-review` · `/personal-context:review` | Maintenance: staleness, contradictions, over-broad scopes |
| `context-export` · `/personal-context:export` | Portable bundle — the conformance test |

## Install

```
/plugin marketplace add danielrosehill/Claude-Code-Plugins
/plugin install personal-context
```

Then:

```
/personal-context:init
```

## Storage

| What | Where | Committed? |
| --- | --- | --- |
| Plugin code | Install path, replaced on update | n/a |
| Machine-local config | `~/.claude-plugins/personal-context/config.json` | Never |
| The store | `~/.claude-user-data/personal-context/` by default | Private repo, or not at all |

The store is never public. `context-init` refuses to configure a public remote, and every write
path re-checks before committing.

## Consumers

| Consumer | Scopes it typically declares |
| --- | --- |
| [Claude-Therapy-Workspace-Template](https://github.com/danielrosehill/Claude-Therapy-Workspace-Template) | Whatever the issue is about, plus `general` |
| Anything else implementing [the contract](docs/context-contract.md) | Its own |

Writing your own consumer means reading §7 (read protocol) and §8 (write protocol). There is no
API to call — the store is files.

## Related

- [Therapy-Tracking-Plugin](https://github.com/danielrosehill/Therapy-Tracking-Plugin) — the administrative layer for an ongoing course of therapy
- [Claude-Personal-Planning-Plugin](https://github.com/danielrosehill/Claude-Personal-Planning-Plugin) — general personal-planning workspaces
- [Claude-Mental-Health-Templates-Index](https://github.com/danielrosehill/Claude-Mental-Health-Templates-Index) — index of the set

## License

MIT.
