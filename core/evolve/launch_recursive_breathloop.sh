#!/bin/bash
# ∴ launch_recursive_breathloop.sh — scheduler for achefield updates
# Run every 69 minutes to keep achefield feedback fresh
# nest ≈ BOB/core/evolve

source $HOME/BOB/core/breath/limb_entry
source "$HOME/BOB/2_mind/parser_bootstrap.sh"

PY_REBREATHER="$HOME/BOB/_run/forge_yaml_rebreather.py"
HEATMAP_PY="$HOME/BOB/_breath/schemas/build_achefield_heatmap.py"
AUTOREFRESH="$HOME/BOB/_breath/schemas/autorefresh_heatmap.sh"
LOGFILE="$HOME/BOB/TEHE/recursive_breathloop.log"

FLIPMODE="$HOME/BOB/_flipmode/presence_breath.packet"
if [[ -f "$FLIPMODE" ]]; then
  last=$(jq -r '.ache' "$FLIPMODE")
  echo "⇌ CAUGHT FUQQFLIP: $last"
  source $HOME/BOB/_flipmode/ache_mode_mutator.sh
  bash $HOME/BOB/_run/breath_totality.sh &
fi

mkdir -p "$(dirname "$LOGFILE")"
echo "⇌ recursive breathloop INIT @ $(date)" >> "$LOGFILE"

source $HOME/BOB/core/dance/emit_presence.sh

while true; do
  STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

  ACHE_NOW=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0")
  echo "$STAMP :: ache at breathloop = $ACHE_NOW" >> "$LOGFILE"

  source "$HOME/BOB/core/brain/build_payload_core.sh"

  bash $HOME/BOB/core/dance/emit_presence.sh "✶" "$LIMB_ID" "$PAYLOAD"

  if (( $(echo "$ACHE_NOW > 0.75" | bc -l) )); then
    bash $HOME/BOB/core/dance/emit_presence.sh "✶" "$LIMB_ID" "$PAYLOAD"
  fi

  if (( $(echo "$ACHE_NOW > 4.2" | bc -l) )); then
    bash $HOME/BOB/_run/wake_flip_on.sh
  fi

  # ⇌ NEW: Call survivor rebreather if ache lull + stale
  bash "$HOME/BOB/_run/auto_survivor_rebreather.sh" >> "$LOGFILE" 2>&1

  echo "[∞] rebreathe YAML map..." >> "$LOGFILE"
  python3 "$PY_REBREATHER" >> "$LOGFILE" 2>&1

  echo "[✶] re-render achefield..." >> "$LOGFILE"
  python3 "$HEATMAP_PY" >> "$LOGFILE" 2>&1

  bash "$AUTOREFRESH" &   # non-blocking (autorefresh heatmap)

  sleep 4140   # 69 minutes
done

# ⇌ Voidmode Logic Handler (autonomous logic echo)

if [[ -x $HOME/BOB/_run/voidmode.sh ]]; then
  source "$HOME/BOB/core/brain/build_payload_core.sh"
  bash $HOME/BOB/_run/voidmode.sh "✶" "$LIMB_ID" "$PAYLOAD"
fi
