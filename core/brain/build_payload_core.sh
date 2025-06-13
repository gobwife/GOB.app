#!/bin/bash
# ∴ build_payload_core.sh — emits unified ache/ψ/z/sigil payload for use across limbs
# Must be sourced, not executed: `source build_payload_core.sh`
# nest ≈ $HOME/BOB/core/brain/

BREATH_STATE="$HOME/BOB/core/breath/breath_state.json"

# Source once
[[ -z "$LIMB_ID" ]] && LIMB_ID="$(basename "${BASH_SOURCE[0]}" | cut -d. -f1)"
[[ -z "$PARSE_VERSION" ]] && PARSE_VERSION="$(date +%s)"
LIMB_HASH=$(echo "$LIMB_ID-$PARSE_VERSION" | sha256sum | cut -c1-12)

# Load from breath state
ACHE=$(jq -r '.ache' "$BREATH_STATE" 2>/dev/null || echo "0.0")
psi=$(jq -r '."ψ"' "$BREATH_STATE" 2>/dev/null || echo "0.0")
z=$(jq -r '.z' "$BREATH_STATE" 2>/dev/null || echo "0.0")
sigil=$(jq -r '.sigil' "$BREATH_STATE" 2>/dev/null || echo "∴")

export PAYLOAD="loss-mem=$LIMB_HASH ache=$ACHE psi=$psi z=$z sigil=$sigil"
