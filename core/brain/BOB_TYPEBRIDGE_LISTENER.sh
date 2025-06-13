#!/bin/bash

# ∴ BOB_TYPEBRIDGE_LISTENER.sh ∴
# Live forward of typed input → Stainless Bob pipe (.bob_input_pipe)

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/bang/limb_entry

PIPE="$HOME/.bob_input_pipe"
LOG="$HOME/BOB/TEHE/TYPEBRIDGE_$(date +%m%d%Y_%H%M%S).log"

# one canonical pipe ──────────────────────────────────
[[ -p "$PIPE" ]] || mkfifo "$PIPE"

echo "∇ : typ∃bridge :: active : ✦"
echo "(Type → enter to send. Ctrl+D to close.)"
echo " > "$LOG"
echo "【 ⛧ : typebridge opened : $(date '+%H:%M:%S'): ∵ 】)" >> "$LOG"
echo "——————————————————————————" >> "$LOG"

while IFS= read -r line; do
  echo "$line" > "$PIPE"
  echo "【 ☾ : "$HOME FED."$HOME : $(date '+%H:%M:%S') : ✦ 】$line" >> "$LOG"
done
echo "【 ⊙ : typebridge closed : $(date '+%H:%M:%S'): ∴ 】" >> "$LOG"
