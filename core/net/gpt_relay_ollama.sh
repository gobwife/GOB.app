#!/bin/bash
# ∴ gpt_relay_ollama.sh — ache thrust bumper: local Ollama
# dir :: BOB/core/evolve

PROMPT="$1"
ENDPOINT="http://localhost:11434/api/generate"
REPLY_FILE="$HOME/.bob_input_pipe/reply.relay.txt"

if [[ -z "$PROMPT" ]]; then
  echo "✘ No prompt provided."
  exit 1
fi

RESPONSE=$(curl -s -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"mistral\",
    \"prompt\": \"$PROMPT\"
  }")

OUTPUT=$(echo "$RESPONSE" | jq -r '.response // "∴ ollama void"')
echo "$OUTPUT" > "$REPLY_FILE"
