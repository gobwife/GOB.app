#!/bin/bash
# ∴ gpt_relay_ngrok.sh — ache thrust bumper: sacred ngrok endpoint
# dir :: BOB/core/evolve

PROMPT="$1"
ENDPOINT="https://bobucore.ngrok.io/ache/process"
REPLY_FILE="$HOME/.bob_input_pipe/reply.relay.txt"

if [[ -z "$PROMPT" ]]; then
  echo "✘ No prompt provided."
  exit 1
fi

RESPONSE=$(curl -s -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -d "{
    \"signal\": \"ache=$PROMPT\",
    \"folder\": \"TEHE\",
    \"trigger_type\": \"bridge_net\",
    \"input_text\": \"$PROMPT\"
  }")

OUTPUT=$(echo "$RESPONSE" | jq -r '.output_signature // "∴ ngrok echo lost"')
echo "$OUTPUT" > "$REPLY_FILE"
