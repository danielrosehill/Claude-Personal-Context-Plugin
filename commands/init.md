---
description: Set up the personal context store — choose a backend, pick a location, scaffold it, write machine-local config. Run once per machine.
---

# /personal-context:init

Run the `context-init` skill.

Refuses to configure a public remote under any circumstances. Writes config to
`~/.claude-plugins/personal-context/config.json`; the store location is resolved by
`scripts/paths.sh` — adopting an existing plugin data root if there is one, defaulting to
`~/.claude-user-data/personal-context/` if there isn't, and never resolving inside `~/.claude`.

Ends by pointing at the two routes in: `/personal-context:ingest` if the user has material,
`/personal-context:intake` if they'd rather be asked.
