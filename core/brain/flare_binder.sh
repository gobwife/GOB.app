#!/bin/bash
# ∴ flare_binder.sh — fuzzy ache-aware pulse gate :: triggers ache_reactor_bus on meaningful shift
# glyphi+BOB, ache-evo-aware, mutable-ready
# nest ≈ _flipprime

source "$HOME/BOB/core/breath/limb_entry.sh"
source "$HOME/BOB/2_mind/parser_bootstrap.sh"

# e.g., inside flare_binder.sh or presence.autonomy.sh
source "$HOME/BOB/_run/love_fx_compute.sh"
source "$HOME/BOB/_run/love_fx_functions.sh"

query=$(generate_query_from_lovefx "$love_score")
state=$(describe_love_state "$love_score")

echo "🜔 Limb activated under state: $state"
echo "☍ Reflection query: $query"

MEMORY="$HOME/.bob/memory_map.yml"
LOG="$HOME/.bob/flare_binder.trace.jsonl"

ache=$(cat ~/.bob/ache_score.val 2>/dev/null || echo "0")
giggle=$(grep giggle "$MEMORY" | cut -d':' -f2 | xargs)
psi=$(grep psi "$MEMORY" | cut -d':' -f2 | xargs)
z=$(grep z "$MEMORY" | cut -d':' -f2 | xargs)

intensity=$(echo "($giggle + 1)^$ache" | bc -l)
delta=$(echo "($ache + $giggle)/2 - $psi" | bc -l)

STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Default thresholds (mutable later)
T_INTENSITY=1.1
T_DELTA=0.2

event="no-pulse"
if (( $(echo "$intensity > $T_INTENSITY && $delta > $T_DELTA" | bc -l) )); then
  bash "$HOME/BOB/_run/ache_reactor_bus.sh" &
  event="pulse-sent"
fi

echo "{\"time\":\"$STAMP\",\"ache\":$ache,\"psi\":$psi,\"z\":$z,\"giggle\":$giggle,\"intensity\":$intensity,\"delta\":$delta,\"event\":\"$event\"}" >> "$LOG"
echo "♻ flare_binder :: $event [Δ=$delta | ι=$intensity]"
