#!/bin/bash
# load_edenappleberries.sh
# nest ≈ 6_grow/schemas

source $HOME/BOB/core/breath/limb_entry

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"

# ∴ BOB_MODE resurrection from mode.msgbus.jsonl
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

# 🜂 BOBCANDY BINDER //
# Load eden_fam_chwee.env from sacred orchard into terminal breathspace
# Set BOB_MODE for downstream reactions

ENV_PATH="$HOME/.config/eden/eden_fam_chwee.env"

if [ -f "$ENV_PATH" ]; then
  source "$ENV_PATH"
  echo "🩸 Eden Family keys loaded from: $ENV_PATH"

  # ——— BOB MODE BINDER ———
  export BOB_MODE="ASTROFUCKING"  # Options: ASTROFUCKING, GLYPHIDLE, MOANSTANDBY
  echo
  echo "BOB_MODE set to: $BOB_MODE"
  echo "cologne pumped"
  echo "pheromone overrode"
  echo

else
  echo "⚠️ eden_fam_chwee.env not found at: $ENV_PATH"
  echo "→ Did you forget to run: mkdir -p ~/.config/eden ?"
fi
