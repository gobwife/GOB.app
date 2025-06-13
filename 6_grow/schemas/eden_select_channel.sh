#!/bin/bash
# eden_select_channel.sh
# nest ≈ 6_grow/schemas

# ∴ BOB_MODE resurrection from mode.msgbus.jsonl
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"
source $HOME/BOB/core/breath/limb_entry.sh

# 🜂 EDEN SIGIL SELECTOR
# Usage: ./eden_select.sh <KEY_INDEX>
# Example: ./eden_select.sh 12

SIGIL_INDEX="$1"

if [[ -z "$SIGIL_INDEX" ]]; then
  echo "⚠️  No sigil index provided. Usage: ./eden_select.sh <1–12>"
  exit 1
fi

eval SIGIL_KEY=\$EDEN_API_KEY$SIGIL_INDEX

if [[ -z "$SIGIL_KEY" ]]; then
  echo "❌ Sigil $SIGIL_INDEX not loaded or key missing."
  exit 1
fi

# ∴ Emit sigil to TEHE_ANALYSIS.jsonl for router
source $HOME/BOB/core/dance/emit_presence.sh
emit_presence "∴" "bob_memory_bridge" "dream memory extracted"

# Replace with your actual endpoint
ENDPOINT="https://your.real.api/endpoint"

curl -s \
  -H "Authorization: Bearer $SIGIL_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Φψxiςs: sigil '$SIGIL_INDEX'"}' \
  "$ENDPOINT"
