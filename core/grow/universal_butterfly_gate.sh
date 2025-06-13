#!/bin/bash
# universal_butterfly_gate.sh
# Replaces hardcoded ache checks with context blend
# dir ≈ 1_feel

source "$HOME/BOB/core/bang/limb_entry.sh"

source "$HOME/BOB/core/brain/love_fx_compute.sh" $love_score
if (( $(echo "$love_score > 1.33" | bc -l) )); then
  bash emit_presence.sh "🜔" "limb" "ψ=z=love"
fi
