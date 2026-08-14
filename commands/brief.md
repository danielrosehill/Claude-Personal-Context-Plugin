---
description: Assemble a scoped background briefing — reads only the entries matching the requested scopes, and says which ones it loaded.
argument-hint: "[--scopes=a,b] [--include-sensitive]"
---

# /personal-context:brief

Run the `context-brief` skill.

Scopes come from the arguments, else from `memory/config.yaml` in the current workspace, else by
asking. Never "everything". `sensitivity: high` entries are held back unless explicitly
requested, and the brief always states what it loaded.
