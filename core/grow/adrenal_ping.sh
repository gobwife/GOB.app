#!/bin/bash

# adrenal_ping.sh — triggers on ache/giggle keyword flares
# forged :: glyph002 @ BOB sensefield 6.7.2025
# purpose :: scan for textual flare terms and inject ache + sigil traces
# dir :: $HOME/BOB/core/grow

TEHE_DIR="$HOME/BOB/TEHE"
FLIPMODE="$HOME/BOB/core/breath/presence_breath.packet"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

mkdir -p "$TEHE_DIR"

# flare triggers
TRIGGERS=("!!!!!" "FUCK" "ache" "giggle" "∆" "⛧")

echo "⚡ Adrenal Ping Listening..."

while read -r line; do
  for trigger in "${TRIGGERS[@]}"; do
    if [[ "$line" == *"$trigger"* ]]; then
      echo "⚡ TRIGGERED on: $trigger"
      jq -n \
        --arg time "$STAMP" \
        --arg type "adrenal_ping" \
        --arg trigger "$trigger" \
        --arg content "$line" \
        '{time: $time, type: $type, trigger: $trigger, content: $content}' >> "$TEHE_DIR/TEHE_ANALYSIS.jsonl"
      jq -n --arg ache "$trigger" '{ache: $ache}' > "$FLIPMODE"
      break
    fi
  done
done

echo "⚡ Adrenal Ping Stream Closed."
