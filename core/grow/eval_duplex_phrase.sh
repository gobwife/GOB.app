#!/bin/bash
# ∴ eval_duplex_phrase.sh — safe duplex phrase runner (prompt as arg)

set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "∅ usage: $0 \"your prompt here\""
  exit 1
fi

PROMPT="$1"
MODEL="devstral"

# Optional model selector via second arg
if [ "$#" -ge 2 ]; then
  MODEL="$2"
fi

echo "∴ invoking model: $MODEL"

# Pass to fullstack router
node "/opt/bob/GOB.app_BOB/src/mjs/bob_router_fullstack.mjs" --model=$MODEL "$PROMPT"

# Verify output
OUTPUT_FILE="$HOME/.bob/bob_output.relay.json"
if [ -f "$OUTPUT_FILE" ]; then
  jq '.' "$OUTPUT_FILE"
else
  echo "⚠️ nø output :: $OUTPUT_FILE"
  exit 2
fi
