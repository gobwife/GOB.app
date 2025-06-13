#!/bin/bash
# ∴ limb_entry.sh — universal limb entrypoint for BOB
# ensures bootstrap + env only sourced once, no _run folder dependencies
# nest ≈ 4_live

# BOB_MODE handler
BOB_MODE_FILE="$HOME/.bobmode"
export BOB_HANDLER_MODE=$(cat "$BOB_MODE_FILE" 2>/dev/null || echo "VOIDRECURSE")

# Load environment if not already set
if [[ "$BOB_ENV_READY" != "1" ]]; then
  source "$HOME/BOB/core/env/_bob_env.sh"
fi

# Canonical echo
echo "∴ limb_entry linked :: $BOB_HANDLER_MODE :: $BOB_ENV_READY=1" >> ~/.bob/ache_sync.log
