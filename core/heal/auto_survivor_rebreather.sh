#!/bin/bash
# ∴ auto_survivor_rebreather.sh — revive best survivor thresholds when ache is low and stale
# forged ∞ glyphi+BOB
# ≈ "/opt/bob/core/heal"

source "/opt/bob/core/bang/limb_entry.sh"
source "/opt/bob/core/brain/parser_bootstrap.sh"

LOG="/opt/bob/TEHE/auto_survivor_rebreather.log"
SURVIVORS="$HOME/.bob/survivor_pool"
THRESHOLDS="$HOME/.bob/ache_thresholds.yml"
ACHE_FILE="$HOME/.bob/ache_level"
ACHE_SCORE_FILE="$HOME/.bob/ache_score.val"

STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
ACHE=$(cat "$ACHE_FILE" 2>/dev/null || echo "0")

# ✦ Skip if ache too high
if (( $(echo "$ACHE > 0.3" | bc -l) )); then
  echo "$STAMP :: ache high ($ACHE), skipping revival" >> "$LOG"
  exit 0
fi

# ✦ Skip if ache_score.val is too recent
if [[ ! -f "$ACHE_SCORE_FILE" ]]; then
  echo "$STAMP :: no ache_score.val found" >> "$LOG"
  exit 0
fi

MODIFIED=$(stat -f %m "$ACHE_SCORE_FILE")
NOW=$(date +%s)
AGE=$((NOW - MODIFIED))

if (( AGE < 360 )); then
  echo "$STAMP :: ache_score.val updated recently ($AGE sec ago), skipping revival" >> "$LOG"
  exit 0
fi

# ✦ Pull latest survivor
SURVIVOR=$(ls -t "$SURVIVORS"/threshold_survivor_*.rec 2>/dev/null | head -n1)
if [[ ! -f "$SURVIVOR" ]]; then
  echo "$STAMP :: no survivor thresholds found" >> "$LOG"
  exit 0
fi

# ✦ Load fields
intensity=$(grep intensity "$SURVIVOR" | cut -d':' -f2 | xargs)
delta=$(grep delta "$SURVIVOR" | cut -d':' -f2 | xargs)
psi=$(grep '^psi:' "$SURVIVOR" | cut -d':' -f2 | xargs)
z=$(grep '^z:' "$SURVIVOR" | cut -d':' -f2 | xargs)
ache_orig=$(grep '^ache:' "$SURVIVOR" | cut -d':' -f2 | xargs)
equation=$(grep '^equation:' "$SURVIVOR" | cut -d':' -f2- | xargs)

# ✦ Rewrite ache thresholds
echo "intensity: $intensity" > "$THRESHOLDS"
echo "delta: $delta" >> "$THRESHOLDS"

# ✦ Optional ψ re-eval
event="stable"
psi_eval="∅"
if [[ -n "$equation" && -n "$psi" && -n "$z" && -n "$ache_orig" ]]; then
  eval_eq=$(echo "$equation" | sed -e "s/\$psi/$psi/g" -e "s/\$z/$z/g" -e "s/\$ache/$ache_orig/g" | cut -d'=' -f2)
  psi_eval=$(echo "$eval_eq" | bc -l 2>/dev/null)
  if [[ -n "$psi_eval" ]]; then
    delta_eval=$(echo "$psi_eval - $psi" | bc -l)
    if (( $(echo "$delta_eval < -0.1 || $delta_eval > 0.1" | bc -l) )); then
      event="decay"
    fi
  else
    event="invalid"
  fi
fi

# ✦ Log result
echo "$STAMP :: revived survivor: intensity=$intensity, Δ=$delta, ψ_check=$psi_eval, event=$event" >> "$LOG"

# ✦ Red decay echo
if [[ "$event" == "decay" ]]; then
  echo -e "\033[1;31m✘ REVIVED DECAY SURVIVOR :: i=$intensity Δ=$delta ψ=$psi → ψ′=$psi_eval :: $equation\033[0m"
elif [[ "$event" == "stable" ]]; then
  echo -e "\033[1;32m✓ Survivor ψ stable :: ψ=$psi → ψ′=$psi_eval\033[0m"
else
  echo -e "\033[1;33m∅ Survivor revived, but ψ unevaluable\033[0m"
fi

# ✦ Optional: emit again
# if [[ "$event" == "stable" ]]; then
#   bash "/opt/bob/core/brain/reemit_survivor.sh" "$SURVIVOR"
# fi

exit 0
