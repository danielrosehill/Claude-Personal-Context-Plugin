#!/usr/bin/env sh
# Resolve where this plugin's config and store live.
#
#   sh scripts/paths.sh          # KEY=VALUE lines
#   sh scripts/paths.sh --json   # JSON object
#
# Two separate things, on two different clocks:
#
#   CONFIG_DIR  machine-local settings. Never committed, never synced.
#   STORE       the user's content. Committed to a private repo, synced between machines.
#
# Nothing here ever resolves inside ~/.claude — that directory belongs to Claude Code, is
# vendor-specific, and its contents are not the user's to keep. See docs/storage-paths.md.
set -eu

die() { echo "paths.sh: $1" >&2; exit 1; }

HOME_DIR="${HOME:?HOME is not set}"
CLAUDE_DIR="$HOME_DIR/.claude"

# Refuse any path inside ~/.claude, however it was arrived at.
guard() {
  case "$1" in
    "$CLAUDE_DIR"|"$CLAUDE_DIR"/*)
      die "refusing path inside $CLAUDE_DIR — that is Claude Code's own directory, not user content ($1)"
      ;;
  esac
}

# --- CONFIG_DIR ---------------------------------------------------------------
# 1. explicit override
# 2. the house convention: a dotfile directory at $HOME, one folder per plugin
if [ -n "${PERSONAL_CONTEXT_CONFIG_DIR:-}" ]; then
  CONFIG_DIR="$PERSONAL_CONTEXT_CONFIG_DIR"
  CONFIG_SOURCE="PERSONAL_CONTEXT_CONFIG_DIR"
else
  CONFIG_DIR="$HOME_DIR/.claude-plugins/personal-context"
  CONFIG_SOURCE="convention"
fi
guard "$CONFIG_DIR"

# --- STORE --------------------------------------------------------------------
# Only consulted to pick a *default* on first run. Once config.json exists its
# `path` is authoritative and this ordering is irrelevant.
#
# 1. explicit override
# 2. $CLAUDE_USER_DATA, if the user has declared a root
# 3. an existing user-data root already on disk — adopt it rather than starting a
#    second one. Probed in preference order; first hit wins.
# 4. the default root, created if nothing exists yet.
STORE_ROOT_CANDIDATES="$HOME_DIR/.claude-user-data
${XDG_DATA_HOME:-$HOME_DIR/.local/share}/claude-plugins
$HOME_DIR/.local/share/claude-plugins"

if [ -n "${PERSONAL_CONTEXT_STORE:-}" ]; then
  STORE="$PERSONAL_CONTEXT_STORE"
  STORE_ROOT="$(dirname "$STORE")"
  STORE_SOURCE="PERSONAL_CONTEXT_STORE"
elif [ -n "${CLAUDE_USER_DATA:-}" ]; then
  STORE_ROOT="$CLAUDE_USER_DATA"
  STORE="$STORE_ROOT/personal-context"
  STORE_SOURCE="CLAUDE_USER_DATA"
else
  STORE_ROOT=""
  for c in $STORE_ROOT_CANDIDATES; do
    [ -d "$c" ] || continue
    STORE_ROOT="$c"
    STORE_SOURCE="adopted-existing"
    break
  done
  if [ -z "$STORE_ROOT" ]; then
    STORE_ROOT="$HOME_DIR/.claude-user-data"
    STORE_SOURCE="default"
  fi
  STORE="$STORE_ROOT/personal-context"
fi
guard "$STORE"
guard "$STORE_ROOT"

STORE_EXISTS=false; [ -d "$STORE" ] && STORE_EXISTS=true
CONFIG_EXISTS=false; [ -f "$CONFIG_DIR/config.json" ] && CONFIG_EXISTS=true

if [ "${1:-}" = "--json" ]; then
  printf '{\n'
  printf '  "config_dir": "%s",\n' "$CONFIG_DIR"
  printf '  "config_file": "%s",\n' "$CONFIG_DIR/config.json"
  printf '  "config_source": "%s",\n' "$CONFIG_SOURCE"
  printf '  "config_exists": %s,\n' "$CONFIG_EXISTS"
  printf '  "store_root": "%s",\n' "$STORE_ROOT"
  printf '  "store": "%s",\n' "$STORE"
  printf '  "store_source": "%s",\n' "$STORE_SOURCE"
  printf '  "store_exists": %s\n' "$STORE_EXISTS"
  printf '}\n'
else
  echo "CONFIG_DIR=$CONFIG_DIR"
  echo "CONFIG_FILE=$CONFIG_DIR/config.json"
  echo "CONFIG_SOURCE=$CONFIG_SOURCE"
  echo "CONFIG_EXISTS=$CONFIG_EXISTS"
  echo "STORE_ROOT=$STORE_ROOT"
  echo "STORE=$STORE"
  echo "STORE_SOURCE=$STORE_SOURCE"
  echo "STORE_EXISTS=$STORE_EXISTS"
fi
