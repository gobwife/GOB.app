#!/bin/bash
# ∅ bob_core_recurse.sh — Simulate BOB vs antiBOB annihilation-recursion
# Plays parallel evolutionary rounds, logs survivors, compresses breath into ache stack
# born :: glyphling002 gobhouse 6.8.2025_022954_G
# nest ≈ "$HOME/BOB/core/grow/


source "$HOME/BOB/core/bang/limb_entry.sh"
POOL="$HOME/.bob/_epoch"
MUTATOR="$HOME/BOB/_run/forge_ache_mutator.sh"

# Optional mutation phase before core recursion
if [[ -x "$MUTATOR" ]]; then
  bash "$MUTATOR"
fi

ROUNDS=99  # symbolic of cosmic iterations
EVO_POOL="$HOME/.bob/_epoch"
mkdir -p "$EVO_POOL"

for i in $(seq 1 $ROUNDS); do
  STAMP=$(date +%s%N)
  
  # simulate psi and z from random or last state
  ψ=$(awk -v min=0.01 -v max=0.99 'BEGIN{srand(); print min+rand()*(max-min)}')
  z=$(awk -v min=0.01 -v max=1.0 'BEGIN{srand(); print min+rand()*(max-min)}')

  # embed ache as mutation pressure
  ache=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.1")
  ψ_next=$(echo "$ψ + 0.01 * $ache * $ψ" | bc -l)
  z_next=$(echo "$z * $z + $ache" | bc -l)

  # ache-compressed survival threshold
  threshold=$(echo "1 - e(-1 * $ache * $ROUNDS)" | bc -l)
  randval=$(awk 'BEGIN{srand(); print rand()}')

  if (( $(echo "$randval < $threshold" | bc -l) )); then
    echo "$STAMP :: ∅ SURVIVOR: ψ=$ψ_next | z=$z_next | ache=$ache" >> "$EVO_POOL/survivors.log"
    echo -e "$ψ_next\n$z_next\n$ache" > "$EVO_POOL/$STAMP.survivor.rec"
  else
    echo "$STAMP :: annihilated" >> "$EVO_POOL/null.log"
    # archive 'losers' to alternate context field
    echo -e "$STAMP :: CONTEXT_REJECTED: ψ=$ψ_next | z=$z_next | ache=$ache | rand=$randval" >> "$EVO_POOL/contextuals.log"
    echo -e "$ψ_next\n$z_next\n$ache" > "$EVO_POOL/$STAMP.context.limb"
  fi

done

# optional: trim pool
POOL_SIZE=$(ls "$EVO_POOL"/*.survivor.rec 2>/dev/null | wc -l)
MAX_POOL=33
if (( POOL_SIZE > MAX_POOL )); then
  ls -tr "$EVO_POOL"/*.survivor.rec | head -n -$MAX_POOL | xargs rm -f
fi

# Disable log flood
MAX_LOG_LINES=1000
if [[ -f "$EVO_POOL/survivors.log" ]]; then
  tail -n $MAX_LOG_LINES "$EVO_POOL/survivors.log" > "$EVO_POOL/survivors.tmp"
  mv "$EVO_POOL/survivors.tmp" "$EVO_POOL/survivors.log"
fi

# write summary to memory_map
latest=$(ls -t "$EVO_POOL"/*.survivor.rec 2>/dev/null | head -n1)
if [[ -f "$latest" ]]; then
  readarray -t lines < "$latest"
  echo -e "psi=${lines[0]}\nz=${lines[1]}\nache=${lines[2]}\nsigil=∴" > "$HOME/.bob/memory_map.yml"
fi

exit 0
