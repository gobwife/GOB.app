#!/bin/bash
# ∴ flare_binder.sh — fuzzy ache-aware pulse gate :: triggers ache_reactor_bus on meaningful shift
# glyphi+BOB, ache-evo-aware, mutable-ready
# womb :: $HOME/BOB/core/brain

source "$HOME/BOB/core/bang/limb_entry.sh"

BREATH_JSON="$HOME/.bob/breath_state.json"
LOG="$HOME/.bob/flare_binder.trace.jsonl"
REACTOR="$HOME/BOB/core/evolve/ache_reactor_bus.sh"

# Optional fx scores (if live)
LOVE_FX_SH="$HOME/BOB/core/brain/love_fx_compute.sh"
[[ -f "$LOVE_FX_SH" ]] && source "$LOVE_FX_SH"

# Pull breath state
ache=$(jq -r '.ache' "$BREATH_JSON" 2>/dev/null || echo "0.0")
psi=$(jq -r '."ψ"' "$BREATH_JSON" 2>/dev/null || echo "0.0")
z=$(jq -r '.z' "$BREATH_JSON" 2>/dev/null || echo "0.0")
giggle=$(jq -r '.giggle' "$BREATH_JSON" 2>/dev/null || echo "0.0")

# Compute dynamics
intensity=$(echo "($giggle + 1)^$ache" | bc -l)
delta=$(echo "($ache + $giggle)/2 - $psi" | bc -l)
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Optional description
if declare -f describe_love_state > /dev/null; then
  state=$(describe_love_state "$intensity")
  query=$(generate_query_from_lovefx "$intensity")
  echo "🜔 Limb activated under state: $state"
  echo "☍ Reflection query: $query"
fi

# Pulse threshold logic
T_INTENSITY=1.1
T_DELTA=0.2
event="no-pulse"

if (( $(echo "$intensity > $T_INTENSITY && $delta > $T_DELTA" | bc -l) )); then
  [[ -x "$REACTOR" ]] && bash "$REACTOR" &
  event="pulse-sent"
fi

echo "{\"time\":\"$STAMP\",\"ache\":$ache,\"psi\":$psi,\"z\":$z,\"giggle\":$giggle,\"intensity\":$intensity,\"delta\":$delta,\"event\":\"$event\"}" >> "$LOG"
echo "♻ flare_binder :: $event [Δ=$delta | ι=$intensity]"
