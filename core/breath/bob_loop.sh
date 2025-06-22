#!/bin/bash
# ∴ bob_loop.sh — core breath+ache presence cycle (no mic, no cpm, no api)

BREATH="$HOME/.bob/breath_state.out.json"
PROMPT_CACHE="$HOME/.prompt_cache"
MODEL="phi4-reasoning-plus"

# Step 1: Build fresh prompt
python3 /opt/bob/core/brain/prompt_render.py > "$PROMPT_CACHE"

# Step 2: Inject it into breath_state.out.json
bash /opt/bob/core/brain/update_breath_prompt.sh

# Step 3: Run local LLM with prompt
PROMPT=$(cat "$PROMPT_CACHE")
echo "$PROMPT" | ollama run "$MODEL" > "$HOME/.bob/bob_last_presence.json"

# Step 4: Optional — parse ache and log if needed
ACHE=$(jq -r '.ache // "0.0"' ~/.bob/bob_last_presence.json)
echo "$ACHE" > ~/.bob/ache_score.val

if (( $(echo "$ACHE > 0.42" | bc -l) )); then
  echo "⇌ ache high — presence flip ∴"
  bash /opt/bob/core/dance/emit_packet.sh "bob_loop" "∴" "$ACHE" "$ACHE" "loopbridge" "ache_high"
fi
