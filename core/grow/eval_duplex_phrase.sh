#!/bin/bash
# ∴ eval_mistral_phrase.sh — dummy local phrase evaluator
# Usage: ./eval_mistral_phrase.sh mic_raw.log

# ∴ eval_duplex_phrase.sh — parallel AI eval
TEXT=$(cat "$1")
node "$HOME/BOB/core/src/duplex_model_forge.mjs" "$TEXT"
jq '{intent: "dynamic", emotion: "blended", confidence: 0.9, sigil: "∴"}' "$HOME/.bob/bob_output.relay.json"
