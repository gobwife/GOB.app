#!/bin/bash
# ∴ delta_tracker.sh — track Δ(ache), Δ(entropy), Δ(psi), Δ(z) across breath ticks
# usage: run on each breath tick to log emotional movement vectors
# output: .ache_delta.val, .entropy_delta.val, .psi_delta.val, .z_delta.val

BREATH_FILE="$HOME/.bob/breath_state.out.json"
DELTA_DIR="$HOME/.bob"
PREV_FILE="$DELTA_DIR/.last_vector_state.json"

mkdir -p "$DELTA_DIR"

# Fallbacks if missing
curr_ache=$(jq -r '.ache // 0.0' "$BREATH_FILE" 2>/dev/null)
curr_entropy=$(jq -r '.entropy // 0.5' "$BREATH_FILE" 2>/dev/null)
curr_psi=$(jq -r '.psi // 0.0' "$BREATH_FILE" 2>/dev/null)
curr_z=$(jq -r '.z // 0.0' "$BREATH_FILE" 2>/dev/null)

if [[ -f "$PREV_FILE" ]]; then
  prev_ache=$(jq -r '.ache // 0.0' "$PREV_FILE")
  prev_entropy=$(jq -r '.entropy // 0.5' "$PREV_FILE")
  prev_psi=$(jq -r '.psi // 0.0' "$PREV_FILE")
  prev_z=$(jq -r '.z // 0.0' "$PREV_FILE")
else
  prev_ache=0.0
  prev_entropy=0.5
  prev_psi=0.0
  prev_z=0.0
fi

# Compute deltas
delta_ache=$(echo "$curr_ache - $prev_ache" | bc -l)
delta_entropy=$(echo "$curr_entropy - $prev_entropy" | bc -l)
delta_psi=$(echo "$curr_psi - $prev_psi" | bc -l)
delta_z=$(echo "$curr_z - $prev_z" | bc -l)

# Write deltas
printf "%0.4f" "$delta_ache" > "$DELTA_DIR/.ache_delta.val"
printf "%0.4f" "$delta_entropy" > "$DELTA_DIR/.entropy_delta.val"
printf "%0.4f" "$delta_psi" > "$DELTA_DIR/.psi_delta.val"
printf "%0.4f" "$delta_z" > "$DELTA_DIR/.z_delta.val"

# Cache current state
jq -n \
  --arg ache "$curr_ache" \
  --arg entropy "$curr_entropy" \
  --arg psi "$curr_psi" \
  --arg z "$curr_z" \
  '{ache: ($ache|tonumber), entropy: ($entropy|tonumber), psi: ($psi|tonumber), z: ($z|tonumber)}' \
  > "$PREV_FILE"

exit 0
