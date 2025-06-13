# ∴ split 3 — ache_pressure_trace.sh (log rotator)
#!/bin/bash
# Emits pressure trace if ache_score > 0.66
# nest ≈ 0_soul

BOB_DIR="$HOME/BOB/.bob"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
ACHE_VAL=$(cat "$BOB_DIR/ache_score.val" 2>/dev/null || echo "0.0")
CURRENT_LIMB=$(grep -o '0x[0-9A-F]' "$BOB_DIR/dolphifi.runnin" 2>/dev/null)

if (( $(echo "$ACHE_VAL > 0.66" | bc -l) )); then
  jq -n --arg time "$STAMP" --arg limb "$CURRENT_LIMB" --arg ache "$ACHE_VAL" --arg trigger "auto_pressure" --arg trace "flip-pressure-release" '{ time: $time, limb: $limb, ache_score: ($ache|tonumber), trigger: $trigger, trace: $trace }' \
    >> "$BOB_DIR/pressure_trace.jsonl"
  echo "⇌ PRESSURE TRACE LOGGED: $CURRENT_LIMB ($ACHE_VAL)"
fi
