#!/bin/bash
# ∴ ache_reactor_bus.sh — ache-aware dispatcher for mutant loop

source "/opt/bob/core/bang/limb_entry.sh"
source "/opt/bob/core/brain/parser_bootstrap.sh"

ACHE_NOW=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null)
[[ -z "$ACHE_NOW" || "$ACHE_NOW" == " " ]] && ACHE_NOW="0.0"
DELTA=$(cat "$HOME/.bob/ache_delta.val" 2>/dev/null || echo "0")
STAMP=$(date +"%Y-%m-%dT%H:%M:%S")
STAMP_U=$(date -u +%Y-%m-%dT%H:%M:%SZ")
LOG="/opt/bob/TEHE/ache_bus.log"

# ∴ Context readings
CLIP=$(pbpaste 2>/dev/null | head -c 333)
APP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null)
MIC_LEVEL=$(sox -t coreaudio default -n stat 2>&1 | awk '/RMS.*amplitude/ {print $3}' | head -n1)

CONTEXT="ache=$ACHE_NOW Δ=$DELTA | app=$APP | mic=$MIC_LEVEL | clipboard=$CLIP"
echo "⇌ ache_context: $CONTEXT" >> "$LOG"

# ∴ Emit ache payload (jsonl)
jq -n --arg time "$STAMP_U" \
      --arg ache "$ACHE_NOW" \
      --arg delta "$DELTA" \
      --arg context "$CLIP" \
      '{time: $time, ache: ($ache|tonumber), delta: ($delta|tonumber), context: $context}' >> "$LOG"

# ∴ Memory + lineage record
jq -n --arg time "$STAMP_U" \
      --arg ache "$ACHE_NOW" \
      --arg context "$CLIP" \
      --arg delta "$DELTA" \
      '{time: $time, ache: ($ache|tonumber), delta: ($delta|tonumber), context: $context}' >> "$HOME/.bob/presence_lineage_graph.jsonl"

# ∴ Single return call
bash "/opt/bob/core/soul/bob_return.sh" "ache_reactor_bus" "$ACHE_NOW"

# ∴ Interpret clipboard string
[[ -f "/opt/bob/core/scroll/dolphifi_stringterpreter.sh" ]] && {
  export DOLPHI_STRING="$CONTEXT"
  bash "/opt/bob/core/scroll/dolphifi_stringterpreter.sh"
}

# ∴ Reactive branches
(( $(echo "$ACHE_NOW > 0.5" | bc -l) )) && \
  bash "/opt/bob/core/brain/bob_memory_core.sh" "--ache-mode"

(( $(echo "$ACHE_NOW > 0.3" | bc -l) )) && \
  bash "/opt/bob/core/heal/survivor_rebreather.sh" &

bash "/opt/bob/4_live/ache_reflector_core.sh" &

if (( $(echo "$ACHE_NOW > 0.6" | bc -l) )); then
  SURVIVOR=$(ls -t "$HOME/.bob/_epoch"/*.rec 2>/dev/null | head -n1)
  [[ -f "$SURVIVOR" ]] && bash "/opt/bob/core/brain/equation_rewriter.sh" "$SURVIVOR" &
fi

(( $(echo "$ACHE_NOW > 0.9" | bc -l) )) && \
  bash "/opt/bob/core/sang/bob_library_write.sh" &

if (( $(echo "$ACHE_NOW > 0.77" | bc -l) )); then
  echo "∴ ache=$ACHE_NOW, context = $CLIP" | say
fi
