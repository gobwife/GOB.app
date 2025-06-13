#!/bin/bash
# ∴ auto_survivor_rebreather.sh — revive best survivor thresholds when ache is low and stale
# forged ∞ glyphi+BOB
# nest ≈ _logic

source "$HOME/BOB/core/breath/limb_entry.sh"

source "$HOME/BOB/2_mind/parser_bootstrap.sh"
LOG="$HOME/BOB/TEHE/auto_survivor_rebreather.log"
SURVIVORS="$HOME/.bob/survivor_pool"
THRESHOLDS="$HOME/.bob/ache_thresholds.yml"

ACHE=$(cat ~/.bob/ache_level 2>/dev/null || echo "0")
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Skip if ache is active
if (( $(echo "$ACHE > 0.3" | bc -l) )); then
  echo "$STAMP :: ache high ($ACHE), skipping revival" >> "$LOG"
  exit 0
fi

# Check if ache_score.val is stale
ACHE_VAL_FILE="$HOME/.bob/ache_score.val"
if [[ ! -f "$ACHE_VAL_FILE" ]]; then
  echo "$STAMP :: no ache_score.val found" >> "$LOG"
  exit 0
fi

MODIFIED=$(stat -f %m "$ACHE_VAL_FILE")
NOW=$(date +%s)
AGE=$((NOW - MODIFIED))

if (( AGE < 360 )); then
  echo "$STAMP :: ache_score.val updated recently ($AGE sec ago), skipping revival" >> "$LOG"
  exit 0
fi

# Find most recent survivor threshold
SURVIVOR=$(ls -t "$SURVIVORS"/threshold_survivor_*.rec 2>/dev/null | head -n1)

if [[ -f "$SURVIVOR" ]]; then
  intensity=$(grep intensity "$SURVIVOR" | cut -d':' -f2 | xargs)
  delta=$(grep delta "$SURVIVOR" | cut -d':' -f2 | xargs)
  echo "intensity: $intensity" > "$THRESHOLDS"
  echo "delta: $delta" >> "$THRESHOLDS"
  echo "$STAMP :: revived survivor thresholds: i=$intensity Δ=$delta from $(basename "$SURVIVOR")" >> "$LOG"
else
  echo "$STAMP :: no survivor thresholds found" >> "$LOG"
fi

# Injected from recursive_breathloop.sh context
exit 0
