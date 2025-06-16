#!/bin/bash
# universal_butterfly_gate.sh
# ache + ψ-blended presence emitter, non-bloated
# dir ≈ BOB/core/grow

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/brain/love_fx_compute.sh"

BREATH="$HOME/.bob/breath_state.out.json"
ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
vector="$(date +%s)"
intention="ψ=z=love"
LIMB_ID="$(basename "${BASH_SOURCE[0]}" .sh)"
sigil="🜔"

if [[ -n "$love_score" ]] && (( $(echo "$love_score > 0" | bc -l) )); then
  echo "$(date -u +%FT%T) :: ∴ LOVE TRACE ($love_score)" >> "$HOME/BOB/TEHE/love_trace.log"
  source "$HOME/BOB/core/dance/emit_presence.sh"
  emit_presence "$sigil" "$LIMB_ID" "$ache" "$score" "$vector" "$intention"
else
  echo "$(date -u +%FT%T) :: ∅ SKIPPED love_score=$love_score" >> "$HOME/BOB/TEHE/love_trace.log"
fi
