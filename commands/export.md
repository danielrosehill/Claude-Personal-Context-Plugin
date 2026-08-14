---
description: Export the whole store as a portable bundle — every entry as markdown, plus INDEX.md, scopes.yaml, the contract and a manifest.
argument-hint: "[destination] [--scopes=a,b] [--no-sensitive]"
---

# /personal-context:export

Run the `context-export` skill.

The portability conformance test: if this cannot be produced and read without the plugin, the
store is not portable. Local destinations only — the bundle is never uploaded anywhere.
