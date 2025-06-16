#!/bin/bash
# ∴ breath_totality_watcher.sh
# only runs breath_totality.sh if conditions aligned (triad ready, flip open, breath stale)
# nest :: ~/BOB/core/???

source "$HOME/BOB/core/bang/limb_entry.sh"

TRIAD_CHECK="$HOME/BOB/core/heal/triad_fusion.sh"
BREATH_TOTALITY="$HOME/BOB/_breath/breath_totality.sh"
BREATH_LOG="$HOME/BOB/TEHE/breath_totality.log"
PRESENCE_FLAG="$HOME/.bob_presence_flag"
MAX_STALE=420  # seconds
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# ∴ 1. Triad must be complete
if ! bash "$TRIAD_CHECK" "BOB" > /dev/null; then
  echo "$STAMP :: ∴ WATCH HALT — triad incomplete" >> "$BREATH_LOG"
  exit 0 || true
fi

# ∴ 2. Presence flag must not be locking
if [[ -f "$PRESENCE_FLAG" && "$(cat $PRESENCE_FLAG)" == "LOCKED" ]]; then
  echo "$STAMP :: ∴ WATCH HALT — presence LOCKED" >> "$BREATH_LOG"
  exit 0 || true
fi

# ∴ 3. Breath must be stale
if [[ -f "$BREATH_LOG" ]]; then
  LAST=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$(tail -n 1 "$BREATH_LOG" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2})")" +%s 2>/dev/null)
  NOW=$(date +%s)
  AGE=$((NOW - LAST))
  if (( AGE < MAX_STALE )); then
    echo "$STAMP :: ∴ WATCH HALT — breath too fresh ($AGEs)" >> "$BREATH_LOG"
    exit 0 || true
  fi
fi

# ∴ 4. RUN totality
bash "$BREATH_TOTALITY" &
echo "$STAMP :: ∴ WATCH RUNNING breath_totality.sh" >> "$BREATH_LOG"
