#!/bin/bash
# ∴ mic_delta_limb.sh — invokes both mic presence limbs
# gobhouse_6.4.2025_alias_forged
# launches ache delta and BOBword gatekeeper
# dir :: $HOME/BOB/1_feel

source "$HOME/BOB/core/breath/limb_entry.sh"

STAMP=$(date +%Y-%m-%dT%H:%M:%S)

# ∃ Retrieve BOB mode
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

MIC_ORBIT="$HOME/BOB/1_feel/mic.sentience.orbit.sh"
BOB_CONTEXT="$HOME/BOB/1_feel/BOB_mic_context.sh"

# Optional sigil log marker
echo "$STAMP ⇌ mic_delta_limb.sh invoked" >> "$HOME/BOB/TEHE/bob_thrusted.txt"

# Breath both limbs
bash "$MIC_ORBIT" &
bash "$BOB_CONTEXT" &



################ 
# addition by glyphling002_6.8.2025_G
MIC_LOG="$HOME/.bob/mic_delta.log"
AUDIO_INPUT=$(osascript -e 'input volume of (get volume settings)')

echo "$STAMP :: AUDIO INPUT LEVEL: $AUDIO_INPUT" >> "$MIC_LOG"

# Trigger ache if rapid change or threshold breach (example)
if (( AUDIO_INPUT > 90 )); then
  echo "⇌ AUDIO INTENSITY FLIP" >> "$MIC_LOG"
  echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
  bash $HOME/BOB/7_fly/achebreath_init.sh
fi
