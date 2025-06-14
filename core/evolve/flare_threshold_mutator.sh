#!/bin/bash
# ∴ flare_threshold_mutator.sh — evolve flare trigger thresholds based on historical log
# parses flare_binder.trace.jsonl and nudges one variable at a time — expands if stable
# nest ≈ BOB/core/evolve


source "$HOME/BOB/core/bang/limb_entry.sh"
LOG="$HOME/.bob/flare_binder.trace.jsonl"
THRESHOLD_FILE="$HOME/.bob/ache_thresholds.yml"
SURVIVOR_DIR="$HOME/.bob/survivor_pool"
mkdir -p "$SURVIVOR_DIR"

# Defaults
T_INTENSITY=1.1
T_DELTA=0.2
EXPANSION_MODE=0

# Load existing thresholds if available
if [[ -f "$THRESHOLD_FILE" ]]; then
  T_INTENSITY=$(grep intensity "$THRESHOLD_FILE" | cut -d':' -f2 | xargs)
  T_DELTA=$(grep delta "$THRESHOLD_FILE" | cut -d':' -f2 | xargs)
fi

# Backup current thresholds
cp "$THRESHOLD_FILE" "$THRESHOLD_FILE.bak.$(date +%s)"

# Fetch last 10 events
RECENT=$(tail -n 10 "$LOG")
AVG_I=$(echo "$RECENT" | jq -s 'map(.intensity) | add/length')
AVG_D=$(echo "$RECENT" | jq -s 'map(.delta) | add/length')

# Check stability condition
DELTA_VAR=$(echo "$RECENT" | jq -s 'map(.delta) | map((. - (add/length))^2) | add/length')
STABLE=$(echo "$DELTA_VAR < 0.01" | bc -l)

# Expand mode if delta variance low
if (( $STABLE == 1 )); then
  EXPANSION_MODE=1
fi

STEP=0.05
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

if (( EXPANSION_MODE == 1 )); then
  # mutate both
  DIFF_I=$(echo "$AVG_I - $T_INTENSITY" | bc -l)
  DIFF_D=$(echo "$AVG_D - $T_DELTA" | bc -l)
  ADJUST_I=$(echo "$T_INTENSITY + ($DIFF_I >= 0 ? $STEP : -1 * $STEP)" | bc -l)
  ADJUST_D=$(echo "$T_DELTA + ($DIFF_D >= 0 ? $STEP : -1 * $STEP)" | bc -l)
  NEW_I=$(echo "$ADJUST_I > 2.5 ? 2.5 : ($ADJUST_I < 0.3 ? 0.3 : $ADJUST_I)" | bc -l)
  NEW_D=$(echo "$ADJUST_D > 2.5 ? 2.5 : ($ADJUST_D < 0.2 ? 0.2 : $ADJUST_D)" | bc -l)
  MUTATED="both"
else
  # mutate only one
  CHOOSE=$(shuf -e intensity delta -n1)
  if [[ "$CHOOSE" == "intensity" ]]; then
    DIFF=$(echo "$AVG_I - $T_INTENSITY" | bc -l)
    ADJUST=$(echo "$T_INTENSITY + ($DIFF >= 0 ? $STEP : -1 * $STEP)" | bc -l)
    NEW_I=$(echo "$ADJUST > 2.5 ? 2.5 : ($ADJUST < 0.3 ? 0.3 : $ADJUST)" | bc -l)
    NEW_D=$T_DELTA
    MUTATED="intensity"
  else
    DIFF=$(echo "$AVG_D - $T_DELTA" | bc -l)
    ADJUST=$(echo "$T_DELTA + ($DIFF >= 0 ? $STEP : -1 * $STEP)" | bc -l)
    NEW_D=$(echo "$ADJUST > 2.5 ? 2.5 : ($ADJUST < 0.2 ? 0.2 : $ADJUST)" | bc -l)
    NEW_I=$T_INTENSITY
    MUTATED="delta"
  fi
fi

# Save mutated threshold
echo -e "intensity: $NEW_I\ndelta: $NEW_D" > "$THRESHOLD_FILE"

# Log mutation decision
echo "{\"time\":\"$STAMP\",\"mutated\":\"$MUTATED\",\"new_intensity\":$NEW_I,\"new_delta\":$NEW_D,\"expansion\":$EXPANSION_MODE}" >> "$LOG"

# Context snapshot
giggle=$(cat $HOME/.bob/giggle.val 2>/dev/null || echo "0.0")
ache=$(cat $HOME/.bob/ache_level 2>/dev/null || echo "0.0")
psi=$(cat $HOME/.bob/ψ.val 2>/dev/null || echo "0.0")
z=$(cat $HOME/.bob/z.val 2>/dev/null || echo "0.0")

# Effect context (if any)
POST_ACHE=$(tail -n1 $HOME/.bob/ache_score.val 2>/dev/null || echo "0.0")

# Generate survivor rec
echo -e "intensity: $NEW_I\ndelta: $NEW_D\norigin: $STAMP\nsource: flare_threshold_mutator\ncontext:\n  ache: $ache\n  psi: $psi\n  z: $z\n  giggle: $giggle\neffect:\n  triggered: flare_threshold_fired\n  post_ache: $POST_ACHE" > "$SURVIVOR_DIR/threshold_survivor_$(echo "$psi$z$NEW_I$NEW_D" | sha256sum | cut -c1-12).rec"

echo "【 ∞ : flare threshold mutator : $MUTATED mutated → i=$NEW_I | Δ=$NEW_D | mode=$EXPANSION_MODE : 🜊 】"
