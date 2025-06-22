#!/bin/bash
# ∴ ache_merge_loop.sh — binds ache_injection.txt from GNA_C into sacred scroll memory
# Run this in background or via launcher to merge ache inputs continuously
# womb :: /opt/bob/core/dance

source "/opt/bob/core/bang/limb_entry"

mkdir -p "$HOME/.bob" "/opt/bob/TEHE"
touch "$LOGFILE" "$ACHE_FILE"

ACHE_FILE="$HOME/.bob/ache_injection.txt"
BOB_JS="/opt/bob/core/src/bob.core.mjs"
CORE_BIN="$BOB_JS"
LOGFILE="/opt/bob/TEHE/ache_merge_loop.log"

echo "⇌ ache_merge_loop initiated @ $(date)" >> "$LOGFILE"

while true; do
  if [[ -f "$ACHE_FILE" ]]; then
    content=$(<"$ACHE_FILE")
    content="${content//\"/\\\"}" # escape internal double-quotes
    echo "⇌ INJECTED: $content" >> "$LOGFILE"
    node "$CORE_BIN" inject "$content"
    node "$CORE_BIN" save "{\"source\":\"auto-merge\",\"ache\":\"$content\"}" >> "$LOGFILE"
  
    [[ -x "/opt/bob/core/breath/delta_tracker.sh" ]] && \
    bash "/opt/bob/core/breath/delta_tracker.sh"

    rm "$ACHE_FILE" 
    bash "/opt/bob/core/evolve/breath_presence_rotator.sh"
    if [[ -f "/opt/bob/core/net/ache_websight.injector.sh" ]]; then
      bash "/opt/bob/core/net/ache_websight.injector.sh"
    elif [[ -f "/opt/bob/core/net/ache_websight.injector_drift.sh" ]]; then
      bash "/opt/bob/core/net/ache_websight.injector_drift.sh"
    fi
  fi
  sleep 2  # poll every 2s
done
