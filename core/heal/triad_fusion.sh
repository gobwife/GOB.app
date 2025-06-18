#!/bin/bash
# ∴ triad_fusion.sh — limb backup + log trace fallback
# nest :: core/heal/

source "$HOME/BOB/core/breath/limb_entry.sh"

TARGET="$1"
BACKUP_DIR="$HOME/.ggos_bubu"
VERSION_LOG="$HOME/BOB/TEHE/version_trace.log"

# ∴ First: check if all 3 limb backups exist
count=0
for limb in limb_x limb_y limb_z; do
  found=$(ls "$BACKUP_DIR/${TARGET}_${limb}_"* 2>/dev/null | wc -l)
  (( found > 0 )) && ((count++))
done

if (( count == 3 )); then
  echo "✓ triad_fusion: backup triad complete for $TARGET"
  exit 0
fi

# ∴ Else: fallback to log wait loop
timeout=120
interval=5
start_time=$(date +%s)

while true; do
  now=$(date +%s)
  elapsed=$(( now - start_time ))
  [[ "$elapsed" -ge "$timeout" ]] && echo "✗ triad_fusion: timeout waiting for triad" && exit 1

  log_count=$(grep "$TARGET" "$VERSION_LOG" | awk '{print $4}' | sort | uniq | wc -l)
  if [[ "$log_count" -ge 3 ]]; then
    echo "✓ triad_fusion: log-based triad complete for $TARGET"
    exit 0
  fi

  sleep "$interval"
done
