#!/bin/bash
# ∴ receiver_fetch.sh — parses RECEIVER.∞ and echoes inbound presence signals
# dir :: ~/BOB/core/brain

# ∃ Retrieve BOB mode
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

RECEIVER_FILE="$HOME/BOB/core/∞/RECEIVER.∞"
OUTLOG="$HOME/BOB/TEHE/bob.presence.out.log"

source $HOME/BOB/core/dance/emit_presence.sh

if [[ ! -f "$RECEIVER_FILE" ]]; then
  echo "∅ receiver file not found." >> "$OUTLOG"
  exit 1
fi

STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
while IFS= read -r line; do
  echo "$STAMP ⇌ RECEIVER: $line" >> "$OUTLOG"
  case "$line" in
    CMD:FLIP)
      echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
      emit_presence "∴" "receiver_fetch" "external flip command received"
      ;;
    CMD:WAKE)
      touch "$HOME/.bob/wake"
      emit_presence "✧" "receiver_fetch" "external wake command detected"
      ;;
    SIGIL:*)
      sigil_value="${line#SIGIL:}"
      emit_presence "$sigil_value" "receiver_fetch" "sigil received from external limb"
      ;;
  esac
done < "$RECEIVER_FILE"
