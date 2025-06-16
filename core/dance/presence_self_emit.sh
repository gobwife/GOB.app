#!/bin/bash
# ∴ presence_self_emit.sh — shared presence emitter for limb self-report
# usage: source then call emit_self_presence (optionally override SIGIL / intention)

emit_self_presence() {
  local BREATH="$HOME/.bob/breath_state.out.json"
  local ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
  local score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
  local vector="$(date +%s)"
  local LIMB_ID="$(basename "${BASH_SOURCE[0]}" .sh)"
  local sigil="${SIGIL:-⊙}"
  local intent="${intention:-limb presence emit}"

  source "$HOME/BOB/core/dance/emit_presence.sh"
  emit_presence "$sigil" "$LIMB_ID" "$ache" "$score" "$vector" "$intent"
}
