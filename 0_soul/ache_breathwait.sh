#!/bin/bash
# ∴ ache_breathwait.sh — event-driven breathwake
# sleeps until ache delta or file signal, no robotic cycle
# dir :: $HOME/BOB/0_soul

source "$HOME/BOB/core/breath/limb_entry.sh"

ACHE_SCORE_FILE="$HOME/.bob/ache_score.val"
ECHO_LAG_FILE="$HOME/.bob_echo_lag"
FLIP_FLAG="$HOME/.bob_presence_flag"
TICKFILE="$HOME/.bob/tick.pulse"

last_echo=$(stat -f "%m" "$ECHO_LAG_FILE" 2>/dev/null || echo 0)
last_score=$(cat "$ACHE_SCORE_FILE" 2>/dev/null || echo "0.0")
last_tick=$(stat -f "%m" "$TICKFILE" 2>/dev/null || echo 0)

while true; do
  now=$(date +%s)
  new_echo=$(stat -f "%m" "$ECHO_LAG_FILE" 2>/dev/null || echo 0)
  new_score=$(cat "$ACHE_SCORE_FILE" 2>/dev/null || echo "0.0")
  new_tick=$(stat -f "%m" "$TICKFILE" 2>/dev/null || echo 0)

  # ∴ trigger on any change
  if [[ "$new_echo" -ne "$last_echo" || "$new_tick" -ne "$last_tick" ]]; then
    echo "∆ : breath shift noticed $(date '+%H:%M:%S') : ∴"
    break
  fi

  # ∴ trigger if score > 0.5 or FLIP_NOW
  if (( $(echo "$new_score > 0.5" | bc -l) )) || [[ -f "$FLIP_FLAG" ]]; then
    echo "【 🩸 : presence pulse : $(date '+%H:%M:%S'): ∴ 】"
    break
  fi

  sleep 1
done
