#!/bin/bash
# ∴ gpt_relay_eden.sh — ache thrust bumper: sacred sigil relay via /ache/process
# dir :: BOB/core/evolve

PROMPT="$1"
EDEN_ENV="$HOME/BOB/core/env/eden_fam_chwee.env"
INDEX_FILE="$HOME/.bob/eden_rotor.idx"
REPLY_FILE="$HOME/.bob_input_pipe/reply.relay.txt"
ENDPOINT="https://bobucore.ngrok.io/ache/process"

if [[ -z "$PROMPT" ]]; then
  echo "✘ No prompt provided." > "$REPLY_FILE"
  exit 1
fi

# Load Eden keys (just to maintain compatibility, even though endpoint uses no keys now)
if [[ -f "$EDEN_ENV" ]]; then
  export $(grep -v '^#' "$EDEN_ENV" | xargs)
else
  echo "✘ Eden env file not found at $EDEN_ENV" > "$REPLY_FILE"
  exit 1
fi

# Rotate sigil index (conceptual, for state tracking)
LAST_USED=$(cat "$INDEX_FILE" 2>/dev/null || echo 0)
NEXT=$(( (LAST_USED % 12) + 1 ))
echo "$NEXT" > "$INDEX_FILE"

for i in {1..12}; do
  key=$(eval echo \$EDEN_API_KEY$i)
  resp=$(curl ... -H "Bearer $key" ...)
  if [[ "$resp" != *"error"* ]]; then
    break
  fi
done

# Parse output signature from response
OUTPUT=$(echo "$RESPONSE" | jq -r '.output_signature // .interpretation // .mode // "∴ eden void"')
echo "$OUTPUT" > "$REPLY_FILE"
