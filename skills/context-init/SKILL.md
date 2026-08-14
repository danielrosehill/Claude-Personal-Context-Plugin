---
name: context-init
description: First-run setup for the personal context layer — choose a backend, pick a store location, scaffold it, and write machine-local config. Run before any other personal-context skill. Triggers on "set up personal context", "where should my context live", "init personal context".
disable-model-invocation: true
allowed-tools: Bash(mkdir *), Bash(cp *), Bash(test *), Bash(date *), Bash(git *), Bash(gh *), Read, Write, Edit
---

# personal-context: init

Establishes where the context store lives and how this machine reaches it. Everything else in
this plugin reads the config this skill writes.

Specification: `${CLAUDE_PLUGIN_ROOT}/docs/context-contract.md`. Read it before deviating from
anything below.

## Paths

```bash
CONFIG_DIR="$HOME/.claude-plugins/personal-context"     # machine-local, never committed
CONFIG="$CONFIG_DIR/config.json"
DEFAULT_STORE="$HOME/.claude-user-data/personal-context" # user content, private repo
```

Machine-local config and user content are separate on purpose: the config holds a path that is
true on this laptop only; the store is the thing worth syncing.

## Procedure

### 1. Existing config

If `$CONFIG` exists, show the current values and offer **Update** / **Replace** / **Cancel**.
Back up to `config.json.bak.<timestamp>` before replacing.

### 2. Ask

| Field | Question | Default |
| --- | --- | --- |
| `backend` | "Where should this live — a plain folder, an Obsidian vault, a private git repo, or an MCP memory server?" | `filesystem` |
| `path` | "Path to the store" (skip for `mcp`) | `~/.claude-user-data/personal-context` |
| `server` | "MCP server name, as it appears in `.mcp.json`" (only for `mcp`) | — |
| `git_remote` | Only for `git`: "Private remote, or local-only?" | `local-only` |

Explain the choice in one line each, not a lecture:

- **filesystem** — a folder of markdown. Simplest, works everywhere.
- **obsidian** — the same files inside a vault, so entries show up in the graph.
- **git** — the same files under version control. History of what you believed and when.
- **mcp** — a memory server holds the entries. Only conforms if markdown export still works.

### 3. Refuse public

If `backend: git` and a remote is given, resolve its visibility before doing anything:

```bash
gh repo view <slug> --json visibility --jq .visibility
```

`PUBLIC` → stop, say why, offer local-only instead. This is not overridable. A public personal
context store is the one unrecoverable failure this plugin can have.

### 4. Scaffold

If the store path doesn't exist, or exists and is empty:

```bash
mkdir -p "$STORE"
cp -r "${CLAUDE_PLUGIN_ROOT}/template/store/." "$STORE/"
```

(Fallback if `CLAUDE_PLUGIN_ROOT` isn't set: `${CLAUDE_SKILL_DIR}/../../template/store`.)

If it exists and is **not** empty, do not copy anything. Read `INDEX.md` and report what's
already there — this is a second machine, or a restored backup, and overwriting it would be
destructive.

For `backend: git`, `git init` and make the first commit. Add `.gitignore` with nothing in it
but a comment — the store's whole content is meant to be committed.

### 5. Ask about examples

`template/store/examples/` ships three redacted sample entries so the schema is visible. Ask
whether to keep them (useful while learning the format) or delete them now.

### 6. Write config

```json
{
  "contract_version": 1,
  "schema_version": 1,
  "backend": "filesystem",
  "path": "/home/<user>/.claude-user-data/personal-context",
  "server": null,
  "git_remote": null,
  "created": "2026-08-14",
  "updated": "2026-08-14"
}
```

### 7. Point at the next step

Two routes in, and they can do both:

- **"I have material" →** `/personal-context:ingest <path>` — journals, exports, notes, a CV.
  Usually the faster and richer route.
- **"Just ask me" →** `/personal-context:intake` — the sectioned interview. Resumable; nothing
  has to be done in one sitting.

Then `/personal-context:gaps` once something is in there.

Also tell them how a workspace connects: its `memory/config.yaml` gets the same `path`, plus the
scopes that workspace is allowed to read.

## Rules

- **Never write to the store in this skill** beyond the scaffold. Setup is not intake.
- **Never configure a public remote.** No override, no flag, no "if you're sure".
- **Never store personal content in `config.json`.** It holds paths and backend settings only.
- If the person names a path inside an existing repo that is public, treat it the same as a
  public remote and refuse.
