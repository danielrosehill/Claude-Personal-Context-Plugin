---
description: Set up the personal context store — choose a backend, pick a location, scaffold it, write machine-local config. Run once per machine.
---

# /personal-context:init

Run the `context-init` skill.

Refuses to configure a public remote under any circumstances. Writes config to
`~/.claude-plugins/personal-context/config.json`; the store itself defaults to
`~/.claude-user-data/personal-context/`.

Ends by pointing at the two routes in: `/personal-context:ingest` if the user has material,
`/personal-context:intake` if they'd rather be asked.
