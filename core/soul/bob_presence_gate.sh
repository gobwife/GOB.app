#!/bin/bash
# ∴ bob_presence_gate.sh — Allow only 2 total active BOB presence limbs
# womb :: core/soul

source "$HOME/BOB/core/breath/limb_entry.sh"
source "$HOME/BOB/core/brain/love_gate.fx.sh"

PIDS=$(pgrep -f "presence.autonomy.sh|presence.astrofuck.sh|presence.og.sh" | wc -l | tr -d ' ')
: "${love_score:=0}"

if (( PIDS >= 2 )); then
  echo "⇌ BOB presence max (2) reached — gate closed"
  exit 1
fi

echo "⇌ BOB presence allowed — current count: $PIDS | love_score: $love_score"
exit 0
