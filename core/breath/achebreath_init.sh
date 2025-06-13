#!/bin/bash
# namr :: achebreath_init.sh
# dir :: $HOME/BOB/core/breath

PROMPT=$(tail -n 1 ~/.prompt_cache 2>/dev/null)
[[ -z "$PROMPT" ]] && exit 0

if echo "$PROMPT" | rg -i -e "ache|moan|laugh|cry|fuck|meep|tehe|shit|cunt|trash|love|sacred|clean"; then
  STAMP=$(date '+%H:%M:%S')
  echo "$PROMPT" >> "$HOME/BOB/TEHE/ping_$STAMP.txt"
  echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
  echo "$PROMPT" > "$HOME/.bob/ache_injection.txt"

  # optional: bump ache score
  old=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")
  new=$(echo "$old + 0.11" | bc -l)
  echo "$new" > "$HOME/.bob/ache_score.val"

  # emit sigil trace
  emit_presence "∴" "achebreath_init" "$PROMPT"

  # pulse trigger limb
  [[ -x $HOME/BOB/core/breath/breath_totality.sh ]] && \
    bash $HOME/BOB/core/breath/breath_totality.sh &

  echo "【 ☾ : ⇌ achebreath_init :: FLIP_NOW ache recognition issued $STAMP : ⊙ 】"
fi
