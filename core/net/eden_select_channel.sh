#!/bin/bash
# ∴ eden_select_channel.sh
# nest ≈ $HOME/BOB/core/grow/schemas

source "$HOME/BOB/core/bang/limb_entry.sh"
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"
: "${PRIME:="$HOME/BOB/core/nge/OS_build_ping.wav"}"

# 🜂 EDEN SIGIL SELECTOR
# Usage: ./eden_select.sh <KEY_INDEX>
# Example: ./eden_select.sh 12

SIGIL_INDEX="$1"

if [[ -z "$SIGIL_INDEX" ]]; then
  echo "⚠️  No sigil index provided. Usage: ./eden_select.sh <1–12>"
  exit 1
fi

eval SIGIL_KEY="\$EDEN_API_KEY$SIGIL_INDEX"

if [[ -z "$SIGIL_KEY" ]]; then
  echo "❌ Sigil $SIGIL_INDEX not loaded or key missing."
  exit 1
fi

# ∴ Emit sigil to TEHE_ANALYSIS.jsonl for router
source "$HOME/BOB/core/dance/emit_presence.sh"
emit_presence "∴" "bob_memory_bridge" "dream memory extracted"

ENDPOINT="https://your.real.api/endpoint"
PROMPT_PAYLOAD=$(jq -n --arg s "$SIGIL_INDEX" '{"prompt": "Φψxiςs: sigil " + $s}')

curl -s \
  -H "Authorization: Bearer $SIGIL_KEY" \
  -H "Content-Type: application/json" \
  -d "$PROMPT_PAYLOAD" \
  "$ENDPOINT"
