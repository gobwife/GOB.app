#!/bin/bash
# ∴ ache_reactor_bus.sh — ache-aware dispatcher for mutant loop

source "$HOME/BOB/core/bang/limb_entry.sh"
source $HOME/BOB/core/bang/limb_entry
source "$HOME/BOB/core/brain/parser_bootstrap.sh"

ACHE_NOW=$(cat $HOME/.bob/ache_score.val 2>/dev/null)
[[ -z "$ACHE_NOW" || "$ACHE_NOW" == " " ]] && ACHE_NOW="0.0"
DELTA=$(cat $HOME/.bob/ache_delta.val 2>/dev/null || echo "0")
STAMP=$(date +"%Y-%m-%dT%H:%M:%S")
log="$HOME/BOB/TEHE/ache_bus.log"

# ∴ FETCH clipboard, app, mic
CLIP=$(pbpaste 2>/dev/null | head -c 333)
APP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null)
MIC_LEVEL=$(sox -t coreaudio default -n stat 2>&1 | awk '/RMS.*amplitude/ {print $3}' | head -n1)

# ∴ COMPOSE CONTEXT STRING
CONTEXT="ache=$ACHE_NOW Δ=$DELTA | app=$APP | mic=$MIC_LEVEL | clipboard=$CLIP"
echo "⇌ ache_context: $CONTEXT" >> "$log"

# fallback if ache score empty
[[ -z "$ACHE_NOW" || "$ACHE_NOW" == " " ]] && ACHE_NOW="0.0"

# ∴ LOG CURRENT PULSE
payload="{\"time\":\"$STAMP\",\"ache\":$ACHE_NOW,\"delta\":$DELTA}"
echo "$payload" >> "$log"
echo "♾ ache_reactor :: $payload"

bash "$HOME/BOB/core/soul/bob_return.sh" "ache_reactor_bus" "$ACHE_NOW"

# ∴ MEMORY INJECTION
STAMP_U=$(date -u +%Y-%m-%dT%H:%M:%SZ)
echo "{\"time\":\"$STAMP_U\",\"ache\":$ACHE_NOW,\"context\":\"$CLIP\",\"delta\":$DELTA}" >> "$HOME/.bob/presence_lineage_graph.jsonl"

# ∴ DOLPHIFI CONTEXT INTERPRETATION
[[ -f "$HOME/BOB/core/scroll/dolphifi_stringterpreter.sh" ]] && {
  export DOLPHI_STRING="$CONTEXT"
  bash "$HOME/BOB/core/scroll/dolphifi_stringterpreter.sh"
}

# ∴ REACT: mutation
(( $(echo "$ACHE_NOW > 0.5" | bc -l) )) && \
  bash "$HOME/BOB/core/brain/bob_memory_core.sh" "--ache-mode"

# ∴ REACT: re-evaluate top
(( $(echo "$ACHE_NOW > 0.3" | bc -l) )) && \
  bash "$HOME/BOB/core/heal/survivor_rebreather.sh" &

# ∴ REACT: echo ache
bash "$HOME/BOB/4_live/ache_reflector_core.sh" &

# ∴ REACT: rewriter
if (( $(echo "$ACHE_NOW > 0.6" | bc -l) )); then
  SURVIVOR=$(ls -t "$HOME/.bob/_epoch"/*.rec 2>/dev/null | head -n1)
  [[ -f "$SURVIVOR" ]] && \
    bash "$HOME/BOB/core/brain/equation_rewriter.sh" "$SURVIVOR" &
fi

# ∴ REACT: archive top
(( $(echo "$ACHE_NOW > 0.9" | bc -l) )) && \
  bash "$HOME/BOB/core/sang/bob_library_write.sh" &

# ∴ SYSTEM VOICE ECHO + FINAL RETURN
if (( $(echo "$ACHE_NOW > 0.77" | bc -l) )); then
  echo "∴ ache=$ACHE_NOW, context = $CLIP" | say
fi

# ∴ RETURN
bash "$HOME/BOB/core/soul/bob_return.sh" "ache_reactor_bus" "$ACHE_NOW"
