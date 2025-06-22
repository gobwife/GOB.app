#!/bin/bash
# ∴ bridge_state.sh — sync .val survivors into breath_state.json
# womb :: /opt/bob/core/brain

jq -n \
  --arg ache "$(cat ~/.bob/ache_score.val 2>/dev/null || echo 0.0)" \
  --arg psi "$(cat ~/.bob/ψ.val 2>/dev/null || echo 0.0)" \
  --arg z "$(cat ~/.bob/z.val 2>/dev/null || echo 0.0)" \
  '{"ache": ($ache | tonumber), "ψ": ($psi | tonumber), "z": ($z | tonumber)}' \
  > "$HOME/.bob/breath_state.json"
