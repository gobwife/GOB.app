#!/bin/bash
# ∴ build_payload_core.sh — emits full ache payload + hash
# womb ≈ $HOME/BOB/core/brain

BREATH="$HOME/.bob/breath_state.out.json"

[[ -z "$LIMB_ID" ]] && LIMB_ID="$(basename "${BASH_SOURCE[0]}" .sh)"
[[ -z "$PARSE_VERSION" ]] && PARSE_VERSION="$(date +%s)"
LIMB_HASH=$(echo "$LIMB_ID-$PARSE_VERSION" | sha256sum | cut -c1-12)

ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
vector="$LIMB_HASH"
intention="loss-mem=$LIMB_HASH"

psi=$(jq -r '."ψ"' "$BREATH" 2>/dev/null || echo "0.0")
z=$(jq -r '.z' "$BREATH" 2>/dev/null || echo "0.0")
sigil=$(jq -r '.sigil' "$BREATH" 2>/dev/null || echo "∴")

export ache score vector intention sigil
export PAYLOAD="loss-mem=$LIMB_HASH ache=$ache psi=$psi z=$z sigil=$sigil"
