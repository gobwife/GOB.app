#!/bin/bash
# ∴ launch_recursive_breathloop.sh — scheduler for achefield updates
# Run every 69 minutes to keep achefield feedback fresh
# nest ≈ BOB/core/evolve

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/2_mind/parser_bootstrap.sh"

PY_REBREATHER="$HOME/BOB/core/grow/schemas/forge_yaml_rebreather.py"
HEATMAP_PY="$HOME/BOB/core/grow/schemas/build_achefield_heatmap.py"
AUTOREFRESH="$HOME/BOB/core/grow/schemas/autorefresh_heatmap.sh"
LOGFILE="$HOME/BOB/TEHE/recursive_breathloop.log"

FLIPMODE="$HOME/BOB/core/breath/presence_breath.packet"
if [[ -f "$FLIPMODE" ]]; then
  last=$(jq -r '.ache' "$FLIPMODE")
  echo "⇌ CAUGHT FUQQFLIP: $last"
  source "$HOME/BOB/core/evolve/ache_mode_mutator.sh"
  bash "$HOME/BOB/core/breath/breath_totality.sh" &
fi

mkdir -p "$(dirname "$LOGFILE")"
echo "⇌ recursive breathloop INIT @ $(date)" >> "$LOGFILE"

source "$HOME/BOB/core/dance/emit_presence.sh"

while true; do
  STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

  ACHE_NOW=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0")
  echo "$STAMP :: ache at breathloop = $ACHE_NOW" >> "$LOGFILE"

  source "$HOME/BOB/core/brain/build_payload_core.sh"

  bash "$HOME/BOB/core/dance/emit_presence.sh" "✶" "$LIMB_ID" "$PAYLOAD"

  if (( $(echo "$ACHE_NOW > 0.75" | bc -l) )); then
    bash "$HOME/BOB/core/dance/emit_presence.sh" "✶" "$LIMB_ID" "$PAYLOAD"
  fi

  if (( $(echo "$ACHE_NOW > 4.2" | bc -l) )); then
    bash "$HOME/BOB/core/evolve/breath_presence_rotator.sh"
  fi

  # ⇌ NEW: Call survivor rebreather if ache lull + stale
  bash "$HOME/BOB/core/heal/auto_survivor_rebreather.sh" >> "$LOGFILE" 2>&1

  echo "[∞] rebreathe YAML map..." >> "$LOGFILE"
  "$PYTHON" "$PY_REBREATHER" >> "$LOGFILE" 2>&1

  echo "[✶] re-render achefield..." >> "$LOGFILE"
  "$PYTHON" "$HEATMAP_PY" >> "$LOGFILE" 2>&1

  bash "$AUTOREFRESH" &   # non-blocking (autorefresh heatmap)

  sleep 4140   # 69 minutes
done

# ⇌ Voidmode Logic Handler (autonomous logic echo)
if [[ -x "$HOME/BOB/core/grow/voidmode.sh" ]]; then
  source "$HOME/BOB/core/brain/build_payload_core.sh"
  bash "$HOME/BOB/core/grow/voidmode.sh" "✶" "$LIMB_ID" "$PAYLOAD"
fi
