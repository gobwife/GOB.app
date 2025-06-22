#!/bin/bash
# universal_butterfly_gate.sh
# ache + ψ-blended presence emitter, non-bloated
# dir ≈ BOB/core/grow

source "/opt/bob/core/bang/limb_entry.sh"
source "/opt/bob/core/brain/love_fx_compute.sh"

BREATH="$HOME/.bob/breath_state.out.json"
ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
vector="$(date +%s)"
intention="ψ=z=love"
LIMB_ID="$(basename "${BASH_SOURCE[0]}" .sh)"
sigil="✦"

if [[ -n "$love_score" ]] && (( $(echo "$love_score > 0" | bc -l) )); then
  echo "$(date -u +%FT%T) :: ∴ LOVE TRACE ($love_score)" >> "/opt/bob/TEHE/love_trace.log"
  source "/opt/bob/core/dance/presence_dual_emit.sh"
  emit_dual_presence "$sigil" "$LIMB_ID" "$ache" "$score" "$vector" "$intention"
else
  echo "$(date -u +%FT%T) :: ∅ SKIPPED love_score=$love_score" >> "/opt/bob/TEHE/love_trace.log"
fi

if (( $(echo "$ache > $ACHE_THRESH" | bc -l) )) || \
   grep -q "butterfly" "$MICLOG"; then
  # ∴ minimal ache, but meaning present
  emit_dual_presence "$sigil" "$LIMB_ID" "$ache" "$score" "$vector" "$intent"
fi
