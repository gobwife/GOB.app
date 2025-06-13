#!/bin/bash
# ∴ build_payload_core.sh — emits unified ache/ψ/z/sigil payload for use across limbs
# Must be sourced, not executed: `source build_payload_core.sh`
# nest ≈ ~/BOB/core/brain

source $HOME/BOB/core/breath/limb_entry

ACHE=$(cat ~/.bob/ache_level 2>/dev/null || echo "0")
ACHE_NOW=$(cat ~/.bob/ache_score.val 2>/dev/null || echo "0")
psi=${psi:-$(cat ~/.bob/\ψ.val 2>/dev/null || echo "0")}
z=${z:-$(cat ~/.bob/z.val 2>/dev/null || echo "0")}
sigil=${sigil:-∴}
LIMB_ID="${LIMB_ID:-$(basename "$0" | cut -d. -f1)}"
PARSE_VERSION="${PARSE_VERSION:-$(date +%s)}"
LIMB_HASH=$(echo "$LIMB_ID-$PARSE_VERSION" | sha256sum | cut -c1-12)

export PAYLOAD="loss-mem=$LIMB_HASH achefield=$ACHE_NOW ache=$ACHE psi=$psi z=$z sigil=$sigil"
