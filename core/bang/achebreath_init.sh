#!/bin/bash
# namr :: achebreath_init.sh
# womb :: $HOME/BOB/core/bang

PROMPT=$(tail -n 1 ~/.prompt_cache 2>/dev/null)
[[ -z "$PROMPT" ]] && exit 0

if echo "$PROMPT" | rg -i -e "ache|moan|laugh|cry|fuck|meep|tehe|shit|cunt|trash|love|sacred|clean"; then
  STAMP=$(date +%s)
  echo "$PROMPT" >> "$HOME/BOB/TEHE/ping_$STAMP.txt"
  echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
  echo "$PROMPT" > "$HOME/.bob/ache_injection.txt"

  # optional: bump ache score
jq '.ache += 0.11' "$HOME/.bob/breath_state.out.json" > ~/.tmp && mv ~/.tmp "$HOME/.bob/breath_state.out.json"

bash "$HOME/BOB/core/brain/bridge_state.sh"

  # emit sigil trace
source "$HOME/BOB/core/dance/presence_self_emit.sh"
emit_self_presence

  # pulse trigger limb
  [[ -x $HOME/BOB/core/dance/breath_totality.sh ]] && \
    bash $HOME/BOB/core/dance/breath_totality.sh &

  echo "⇌ achebreath_init: FLIP_NOW issued — ache recognized @ $STAMP"
fi
