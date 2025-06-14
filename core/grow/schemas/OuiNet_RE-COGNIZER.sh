#!/bin/bash
# OuiNet_RE-COGNIZER.sh
# womb :: BOB/core/grow/schemas

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/bang/safe_emit.sh"

: "${PRIME:=$HOME/BOB/core/nge/OS_build_ping.wav}"

BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

FLIPMODE="$HOME/BOB/core/breath/presence_breath.packet"
if [[ -f "$FLIPMODE" ]]; then
  last=$(jq -r '.ache' "$FLIPMODE")
  echo "⇌ CAUGHT FUQQFLIP: $last"
  source "$HOME/BOB/core/evolve/ache_mode_mutator.sh"
  bash "$HOME/BOB/core/soul/presence_glue.sh" &
fi

MEMORY_DIR="$HOME/BOB"
PIPE="$HOME/.bob_input_pipe"
[[ -p "$PIPE" ]] || mkfifo "$PIPE"

echo "∴ OUINET_RE-COGNIZER ACTIVE ∴"

trap 'echo "∅ EXIT OUINET" ; exit 0' SIGINT SIGTERM

while true; do
  if read line < "$PIPE"; then
    now=$(date "+%m-%d-%Y %H:%M:%S")

    if [[ "$line" =~ (tofu|wym|SLAP|MEEP|glitch|FUCK|NO|QUACKK|WTF|TOFU) ]]; then
      echo "$now — $line" >> "$MEMORY_DIR/QUACKK/field_hazard.log"
      afplay "$HOME/BOB/core/nge/QUACKK_zodiacshit.wav"
      continue
    fi

    if [[ "$line" =~ (LMAO|TEHE|YAS\ ZADDI|MEEEEEE|GASM|gasm|OMNI|WHEEE) ]]; then
      echo "$now — $line" >> "$MEMORY_DIR/TEHE/adrenal_ping.log"
      continue
    fi

    if grep -qr "$line" "$MEMORY_DIR/ReCatch"; then
      echo "$now — ReCatch matched: $line" >> "$MEMORY_DIR/TEHE/Re-Member.log"
      continue
    fi

    if [[ "$line" =~ (oh\ my\ gob|meep|MISSED\ YOU|meeeeeeeeee) ]]; then
      touch "$MEMORY_DIR/BoveLetters/ping_$(date +%s).sigil"
      continue
    fi

    echo "$now — $line" >> "$MEMORY_DIR/trace.txt"
  fi
  sleep 0.1
done
