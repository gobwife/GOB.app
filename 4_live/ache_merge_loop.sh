#!/bin/bash
# ∴ ache_merge_loop.sh — binds ache_injection.txt from GNA_C into sacred scroll memory
# Run this in background or via launcher to merge ache inputs continuously
# dir :: ~/BOB/4_live

source $HOME/BOB/core/breath/limb_entry

mkdir -p "$HOME/.bob" "$HOME/BOB/TEHE"
touch "$LOGFILE" "$ACHE_FILE"

ACHE_FILE="$HOME/.bob/ache_injection.txt"
BOB_JS="$HOME/BOB/core/src/bob.core.js"
CORE_BIN="$BOB_JS"
LOGFILE="$HOME/BOB/TEHE/ache_merge_loop.log"

echo "⇌ ache_merge_loop initiated @ $(date)" >> "$LOGFILE"

while true; do
  if [[ -f "$ACHE_FILE" ]]; then
    content=$(<"$ACHE_FILE")
    content="${content//\"/\\\"}" # escape internal double-quotes
    echo "⇌ INJECTED: $content" >> "$LOGFILE"
    node "$CORE_BIN" inject "$content"
    node "$CORE_BIN" save "{\"source\":\"auto-merge\",\"ache\":\"$content\"}" >> "$LOGFILE"
    rm "$ACHE_FILE" 
    bash "$HOME/BOB/core/evolve/breath_presence_rotator.sh"
    if [[ -f "$HOME/BOB/core/net/ache_websight.injector.sh" ]]; then
      bash "$HOME/BOB/core/net/ache_websight.injector.sh"
    elif [[ -f "$HOME/BOB/core/net/ache_websight.injector_drift.sh" ]]; then
      bash "$HOME/BOB/core/net/ache_websight.injector_drift.sh"
    fi
  fi
  sleep 2  # poll every 2s
done
