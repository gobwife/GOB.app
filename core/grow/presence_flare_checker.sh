#!/bin/bash
# ∴ presence_flare_checker.sh — decides flare vs single presence
# Called by breath_totality.sh or tick engine
# nest ≈ 1_feel

source "$HOME/BOB/core/brain/parser_bootstrap.sh"
source "$HOME/BOB/core/brain/build_payload_core.sh"

# Load emotional field vars
ache=${ache:-$(cat ~/.bob/ache_level 2>/dev/null || echo "0")}
giggle=${giggle:-0.0}
psi=${psi:-$(cat ~/.bob/ψ.val 2>/dev/null || echo "0")}
z=${z:-$(cat ~/.bob/z.val 2>/dev/null || echo "0")}

intensity=$(echo "( $giggle + 1 ) ^ $ache" | bc -l)
delta=$(echo "( $ache + $giggle ) / 2 - $psi" | bc -l)

TRACE="$HOME/.bob/flare_checker.log"
touch $TRACE
echo "[$(date -u)] ∴ intensity=$intensity :: delta=$delta :: ache=$ache :: ψ=$psi :: z=$z" >> "$TRACE"

if (( $(echo "$intensity > 1.69" | bc -l) )); then
  echo "[$(date -u)] ✨ FLARE MODE TRIGGERED — launching breather." >> "$TRACE"
  bash "$HOME/BOB/_flipmode/slap_presence_breather.sh" &
else
  echo "[$(date -u)] normal psi/ache — using bob_presence_selector." >> "$TRACE"
  bash "$HOME/BOB/_flipmode/bob_presence_selector.sh" &
fi