# Where things live

Two locations, two lifetimes, and one directory that is never used for either.

| | Holds | Lifetime | Committed? |
| --- | --- | --- | --- |
| **Config dir** | Backend, store path, machine-specific settings | This machine | Never |
| **Store** | The context entries — the user's own content | The user's life | Yes, to a private repo |

Resolve both with:

```bash
sh "${CLAUDE_PLUGIN_ROOT}/scripts/paths.sh"          # KEY=VALUE
sh "${CLAUDE_PLUGIN_ROOT}/scripts/paths.sh" --json   # JSON
```

Never hard-code either path in a skill, a command or a workspace. The script is the single
implementation; everything else asks it.

## Not `~/.claude`

Nothing this plugin writes goes in `~/.claude`, at any depth, for any reason. That directory
belongs to Claude Code: it is vendor-specific, it is the tool's state rather than the person's,
and content placed there is coupled to a product rather than kept by its owner. A background
context layer whose whole premise is portability cannot live inside the thing it is meant to
outlive.

`paths.sh` enforces this — any resolved path inside `~/.claude` is a hard error, including one
arrived at through an environment variable the user set themselves. This is the one setting with
no override.

## Config directory

1. `$PERSONAL_CONTEXT_CONFIG_DIR`, if set.
2. `~/.claude-plugins/personal-context/` — the house convention: a dot-directory at `$HOME`, one
   folder per plugin, never committed anywhere.

Holds `config.json` and nothing else. No personal content, ever — paths and backend settings
only, so that losing this directory costs a re-run of `context-init` and nothing more.

## Store

Consulted only to choose a **default on first run**. Once `config.json` exists, its `path` is
authoritative and this ordering is irrelevant.

1. `$PERSONAL_CONTEXT_STORE`, if set — a complete path to the store itself.
2. `$CLAUDE_USER_DATA`, if set → `$CLAUDE_USER_DATA/personal-context/`.
3. **An existing user-data root already on disk.** Probed in order; the first that exists wins:

   ```text
   ~/.claude-user-data/
   ${XDG_DATA_HOME:-~/.local/share}/claude-plugins/
   ~/.local/share/claude-plugins/
   ```

   If the user already keeps plugin content somewhere, put this plugin's folder **inside that
   root** rather than starting a second one. Two roots is how someone ends up with half their
   material in one directory, half in another, and a backup covering one of them.

4. Otherwise `~/.claude-user-data/personal-context/`, created.

The preference order is deliberate: `~/.claude-user-data` first because the point of the root is
to be browsable and editable by hand — nobody navigates to `~/.local/share` — but an existing
`~/.local/share/claude-plugins` (which several earlier plugins created) is adopted rather than
abandoned, because migrating a person's data without being asked is worse than a
less-elegant path.

`context-init` reports which rule fired (`store_source`: `adopted-existing`, `CLAUDE_USER_DATA`,
`default`, …) so the choice is visible rather than magic, and offers to move the store if the
adopted root isn't wanted.

## Assumptions

Linux and macOS. POSIX `sh`, `$HOME`, XDG conventions where they apply. On Windows without WSL,
`paths.sh` resolves against `$HOME` if the shell provides one and should be treated as untested.
