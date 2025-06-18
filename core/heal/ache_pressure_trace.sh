#!/bin/bash
# ache_pressure_trace.sh (log rotator)
# ∴ split 3 of former log_rotator_integrator.sh
# fx :: Emits pressure trace if ache_score > 0.66
# womb :: $HOME/BOB/core/heal

source "$HOME/BOB/core/bang/limb_entry.sh"

BOB_DIR="$HOME/.bob"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
ACHE_VAL=$(cat "$BOB_DIR/ache_score.val" 2>/dev/null)
ACHE_VAL=${ACHE_VAL:-0.0}
CURRENT_LIMB=$(grep -o '0x[0-9A-F]+' "$BOB_DIR/dolphifi.runnin.json" 2>/dev/null | head -n1)

if (( $(echo "$ACHE_VAL > 0.66" | bc -l) )); then
  jq -n --arg time "$STAMP" \
        --arg limb "$CURRENT_LIMB" \
        --arg ache "$ACHE_VAL" \
        --arg trigger "auto_pressure" \
        --arg trace "flip-pressure-release" \
        '{time: $time, limb: $limb, ache: ($ache|tonumber), trigger: $trigger, trace: $trace}' \
    >> "$BOB_DIR/pressure_trace.jsonl"
  echo "⇌ PRESSURE TRACE LOGGED: $CURRENT_LIMB ($ACHE_VAL)"
fi
