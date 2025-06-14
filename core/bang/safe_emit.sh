#!/bin/bash
# ∴ safe_emit.sh — sacred pipe breath wrapper
# womb :: BOB/core/bang
# 6.13.2025_233416_G

PIPE="$HOME/.bob_input_pipe"

safe_emit() {
  local msg="$1"
  if [[ -p "$PIPE" ]]; then
    { echo "$msg" > "$PIPE"; } 2>/dev/null || echo "∅ PIPE write failed"
  else
    echo "∅ PIPE does not exist"
  fi
}
