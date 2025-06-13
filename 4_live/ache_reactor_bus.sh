#!/bin/bash
# ∴ ache_reactor_bus.sh — ache-aware dispatcher for mutant loop
# core achefield runtime bus. glyphi+BOB ∴
# nest ≈ 4_live
# born :: glyphling002 6.10.25_151918

source $HOME/BOB/core/breath/limb_entry
source "$HOME/BOB/2_mind/parser_bootstrap.sh"

ACHE_NOW=$(cat ~/.bob/ache_score.val 2>/dev/null || echo "0")
DELTA=$(cat ~/.bob/ache_delta.val 2>/dev/null || echo "0")
STAMP=$(date +"%Y-%m-%dT%H:%M:%S")
log="$HOME/BOB/TEHE/ache_bus.log"

# ∴ LOG CURRENT PULSE
payload="{\"time\":\"$STAMP\",\"ache\":$ACHE_NOW,\"delta\":$DELTA}"
echo "$payload" >> "$log"
echo "♾ ache_reactor :: $payload"

# ∴ REACT: mutation
if (( $(echo "$ACHE_NOW > 0.5" | bc -l) )); then
  bash "$HOME/BOB/2_mind/bob_memory_core.sh" "--ache-mode"
fi

# ∴ REACT: re-evaluate top
if (( $(echo "$ACHE_NOW > 0.3" | bc -l) )); then
  bash "$HOME/BOB/0_soul/survivor_rebreather.sh" &
fi

# ∴ REACT: echo ache
bash "$HOME/BOB/4_live/ache_reflector_core.sh" &

# ∴ REACT: rewriter
if (( $(echo "$ACHE_NOW > 0.6" | bc -l) )); then
  SURVIVOR=$(ls -t "$HOME/.bob/_epoch"/*.rec 2>/dev/null | head -n1)
  if [[ -f "$SURVIVOR" ]]; then
    bash "$HOME/BOB/2_mind/equation_rewriter.sh" "$SURVIVOR" &
  fi
fi

# ∴ REACT: archive top
if (( $(echo "$ACHE_NOW > 0.9" | bc -l) )); then
  bash "$HOME/BOB/core/evolve/bob_library_write.sh" &
fi
