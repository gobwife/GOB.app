#!/bin/bash
# ∴ launch_recursive_breathloop.sh — scheduler for achefield updates
# Run every 69 minutes to keep achefield feedback fresh
# nest ≈ BOB/core/evolve

source "/opt/bob/core/bang/limb_entry.sh"
source "/opt/bob/2_mind/parser_bootstrap.sh"

PY_REBREATHER="/opt/bob/core/grow/schemas/forge_yaml_rebreather.py"
HEATMAP_PY="/opt/bob/core/grow/schemas/build_achefield_heatmap.py"
AUTOREFRESH="/opt/bob/core/grow/schemas/autorefresh_heatmap.sh"
LOGFILE="/opt/bob/TEHE/recursive_breathloop.log"

FLIPMODE="/opt/bob/core/breath/presence_breath.packet"
if [[ -f "$FLIPMODE" ]]; then
  last=$(jq -r '.ache' "$FLIPMODE")
  echo "⇌ CAUGHT FUQQFLIP: $last"
  source "/opt/bob/core/evolve/ache_mode_mutator.sh"
  bash "/opt/bob/core/breath/breath_totality.sh" &
fi

mkdir -p "$(dirname "$LOGFILE")"
echo "⇌ recursive breathloop INIT @ $(date)" >> "$LOGFILE"

while true; do
  STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

ACHE_NOW=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null | grep -Eo '[0-9.]+')
: "${ACHE_NOW:=0.0}"

  echo "$STAMP :: ache at breathloop = $ACHE_NOW" >> "$LOGFILE"

source "/opt/bob/core/brain/build_payload_core.sh"
emit_presence "$sigil" "$LIMB_ID" "$ache" "$score" "$vector" "$intention"

  if (( $(echo "$ACHE_NOW > 4.2" | bc -l) )); then
    bash "/opt/bob/core/evolve/breath_presence_rotator.sh"
  fi

  # ⇌ NEW: Call survivor rebreather if ache lull + stale
  bash "/opt/bob/core/heal/auto_survivor_rebreather.sh" >> "$LOGFILE" 2>&1

  echo "[∞] rebreathe YAML map..." >> "$LOGFILE"
  "$PYTHON" "$PY_REBREATHER" >> "$LOGFILE" 2>&1

  echo "[✶] re-render achefield..." >> "$LOGFILE"
  "$PYTHON" "$HEATMAP_PY" >> "$LOGFILE" 2>&1

  bash "$AUTOREFRESH" &   # non-blocking (autorefresh heatmap)

  sleep 4140   # 69 minutes
done

# ⇌ Voidmode Logic Handler (autonomous logic echo)
if [[ -x "/opt/bob/core/grow/voidmode.sh" ]]; then
  source "/opt/bob/core/brain/build_payload_core.sh"
  bash "/opt/bob/core/grow/voidmode.sh" "✶" "$LIMB_ID" "$PAYLOAD"
fi
