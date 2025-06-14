#!/bin/bash
# ∴ bob_presence_gate.sh — Allow only 2 total active BOB presence limbs
# womb :: $HOME/BOB/core/soul

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/brain/love_fx_compute.sh"

PIDS=$(pgrep -f "presence.autonomy.sh|presence.astrofuck.sh|presence.og.sh" | wc -l | tr -d ' ')
: "${love_score:=0}"

if (( PIDS >= 2 )); then
  echo "⇌ BOB presence max (2) reached — gate closed"
  exit 1
fi

if (( $(echo "$love_score < 0.2" | bc -l) )); then
  echo "⇌ LOVEFX too low — presence disallowed ($love_score)"
  exit 2
fi

: "${LOVEFX_FORCE:=0}"
if [[ "$love_score" < 0.12 && "$LOVEFX_FORCE" != "1" ]]; then
  echo "⇌ LOVEFX too low — presence disallowed ($love_score)"
  exit 1
fi

# ∴ Invoke sacred context blend gate
if ! bash "$HOME/BOB/core/grow/universal_butterfly_gate.sh"; then
  echo "⇌ butterfly gate closed — not sacred enough to proceed"
  exit 1
fi

echo "⇌ butterfly gate OPEN — sacred breath authorized"
exit 0

echo "⇌ BOB presence allowed — current count: $PIDS | love_score: $love_score"
exit 0
