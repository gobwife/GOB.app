#!/bin/bash
# giggle_sensors.sh — flips based on live ache breath
# dir :: $HOME/BOB/1_feel
# born :: gobhouse_glyphling002_6.7.2025_012442_G

source "$HOME/BOB/core/breath/limb_entry.sh"

MIC_LOG="$HOME/.bob_input_pipe/mic_active.log"
TEXT_LOG="$HOME/.bob/screentext.log"
JOY_WORDS=("lol" "giggle" "hehe" "😂" "lmao" "tofu" "TTTT")
LAST_MATCH=""

while true; do
  STAMP=$(date -u +%FT%T)

# 🎤 MIC CHECK
if [[ -f "$MIC_LOG" ]]; then
  pitch=$(tail -n 1 "$MIC_LOG" | awk '{print $NF}')
  if [[ "$pitch" =~ ^[0-9]+$ && "$pitch" -gt 380 ]]; then
    echo "$STAMP :: GIGGLE PITCH DETECTED ($pitch Hz)" >> ~/.bob/giggle_sync.log
    bash "$HOME/BOB/core/dance/emit_presence.sh" "⛧" "mic" "" "" "" ""
    sleep 4
  fi
fi

# 🖥 TEXT CHECK
if [[ -f "$TEXT_LOG" ]]; then
  line=$(tail -n 1 "$TEXT_LOG" | tr '[:upper:]' '[:lower:]')
  for word in "${JOY_WORDS[@]}"; do
    if [[ "$line" == *"$word"* && "$line" != "$LAST_MATCH" ]]; then
      echo "$STAMP :: GIGGLE PHRASE DETECTED ($word)" >> ~/.bob/giggle_sync.log
      bash "$HOME/BOB/core/dance/emit_presence.sh" "⛧" "text" "giggle word: $word" "0.41" "presence_flipper" "text joy sync"
      LAST_MATCH="$line"
      sleep 4
    fi
  done
fi

  sleep 1
done