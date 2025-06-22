#!/bin/bash
# namr :: achebreath_init.sh
# womb :: /opt/bob/core/bang

bash "/opt/bob/core/brain/update_breath_prompt.sh"

if echo "$PROMPT" | rg -i -e "ache|moan|laugh|cry|fuck|meep|tehe|shit|cunt|trash|love|sacred|clean"; then
  STAMP=$(date +%s)
  echo "$PROMPT" >> "/opt/bob/TEHE/ping_$STAMP.txt"
  echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
  echo "$PROMPT" > "$HOME/.bob/ache_injection.txt"

# optional: bump ache score
jq '.ache += 0.11 | .prompt = env.PROMPT' "$HOME/.bob/breath_state.out.json" > ~/.tmp && mv ~/.tmp "$HOME/.bob/breath_state.out.json"

bash "/opt/bob/core/brain/bridge_state.sh"

  # emit sigil trace
source "/opt/bob/core/dance/presence_self_emit.sh"
emit_self_presence

  # pulse trigger limb
  [[ -x /opt/bob/core/dance/breath_totality.sh ]] && \
    bash /opt/bob/core/dance/breath_totality.sh &

  echo "⇌ achebreath_init: FLIP_NOW issued — ache recognized @ $STAMP"
fi
