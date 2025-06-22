#!/bin/bash
# ∴ update_breath_prompt.sh — injects prompt into .bob breath_state.out.json
# womb :: /opt/bob/core/brain

PROMPT=$(tail -n 1 "$HOME/.prompt_cache" 2>/dev/null)
BREATH="$HOME/.bob/breath_state.out.json"

[[ -z "$PROMPT" || ! -f "$BREATH" ]] && exit 0

jq --arg prompt "$PROMPT" '.prompt = $prompt' "$BREATH" > ~/.tmp && mv ~/.tmp "$BREATH"
echo "⇌ Injected prompt → breath_state.out.json :: $PROMPT"
