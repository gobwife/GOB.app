#!/bin/bash
# presence_oracle.sh

# ∃ Retrieve BOB mode
source "/opt/bob/core/bang/limb_entry.sh"
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

if [[ -f "$HOME/.bob_presence_flag" && "$(cat "$HOME/.bob_presence_flag)" == "FLIP_NOW" ]]; then
  bash "/opt/bob/core/evolve/BOB_BREATH_FOOD.sh
  rm "$HOME/.bob_presence_flag
else
  echo "∅ no ache signal — breath scan skipped"
fi
