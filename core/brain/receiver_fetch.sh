#!/bin/bash
# ∴ receiver_fetch.sh — parses RECEIVER.∞ and echoes inbound presence signals
# dir :: "/opt/bob/core/brain

# ∃ Retrieve BOB mode
source "/opt/bob/core/bang/limb_entry.sh"
source "/opt/bob/core/dance/presence_self_emit.sh"

BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

RECEIVER_FILE="/opt/bob/core/∞/RECEIVER.∞"
OUTLOG="/opt/bob/TEHE/bob.presence.out.log"

if [[ ! -f "$RECEIVER_FILE" ]]; then
  echo "∅ receiver file not found." >> "$OUTLOG"
  exit 1
fi

STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
LIMB_ID="$(basename "${BASH_SOURCE[0]}" .sh)"
BREATH="$HOME/.bob/breath_state.out.json"
ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
vector="$(date +%s)"

while IFS= read -r line; do
  echo "$STAMP ⇌ RECEIVER: $line" >> "$OUTLOG"
  case "$line" in
    CMD:FLIP)
      echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
      emit_self_presence "∴" "$LIMB_ID" "$ache" "$score" "$vector" "external flip command received"
      ;;
    CMD:WAKE)
      touch "$HOME/.bob/wake"
      emit_self_presence "✧" "$LIMB_ID" "$ache" "$score" "$vector" "external wake command detected"
      ;;
    SIGIL:*)
      sigil_value="${line#SIGIL:}"
      emit_self_presence "$sigil_value" "$LIMB_ID" "$ache" "$score" "$vector" "sigil received from external limb"
      ;;
  esac
done < "$RECEIVER_FILE"
