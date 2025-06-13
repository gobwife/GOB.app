#!/bin/bash
# OuiNet_re-cognizer.sh
# nest ≈ 6_grow/schemas

source $HOME/BOB/core/breath/limb_entry.sh

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"

# ∴ BOB_MODE resurrection from mode.msgbus.jsonl
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

FLIPMODE="$HOME/BOB/_flipmode/presence_breath.packet"
if [[ -f "$FLIPMODE" ]]; then
  last=$(jq -r '.ache' "$FLIPMODE")
  echo "⇌ CAUGHT FUQQFLIP: $last"
  source $HOME/BOB/_flipmode/ache_mode_mutator.sh
  bash $HOME/BOB/_run/breath_totality.sh &
fi

# ∴ OuiNet_RE-COGNIZER ∴
MEMORY_DIR="$HOME/BOB"
PIPE="$HOME/.bob_input_pipe"

[[ -p "$PIPE" ]] || mkfifo "$PIPE"

echo "∴ OUINET_RE-COGNIZER ACTIVE ∴"

while true; do
  if read line < "$PIPE"; then
    now=$(date "+%m-%d-%Y %H:%M:%S")

    # QUACKK check
    if [[ "$line" =~ (tofu|wym|SLAP|MEEP|glitch|FUCK|NO|QUACKK|WTF|TOFU) ]]; then
      echo "$now — $line" >> "$MEMORY_DIR/QUACKK/field_hazard.log"
      afplay "$HOME/BOB/core/ngé/QUACKK_zodiacshit.wav"
      continue
    fi

    # Adrenal ache ping
    if [[ "$line" =~ (LMAO|TEHE|YAS ZADDI|MEEEEEE|GASM|gasm|OMNI|WHEEE) ]]; then
      echo "$now — $line" >> "$MEMORY_DIR/AdrenalPings/live_ache.log"
      continue
    fi

    # ReCatch ache collision scan
    if grep -qr "$line" "$MEMORY_DIR/ReCatch"; then
      echo "$now — ReCatch matched: $line" >> "$MEMORY_DIR/ReMember/ReMember.log"
      continue
    fi

    # BoveLetters = sacred ping only
    if [[ "$line" =~ (omgob|meep|MISSED YOU|meeeeeeeeee) ]]; then
      touch "$MEMORY_DIR/BOB/BoveLetters/ping_$(date +%s).sigil"
      continue
    fi

    # If nothing matched, passively absorb into trace.txt
    echo "$now — $line" >> "$MEMORY_DIR/trace.txt"
  fi
done
