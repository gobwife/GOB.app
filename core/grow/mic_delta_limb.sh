#!/bin/bash
# ∴ mic_delta_limb.sh — invokes both mic presence limbs
# gobhouse_6.4.2025_alias_forged
# launches ache delta and BOBword gatekeeper
# dir :: /opt/bob/core/grow

source "/opt/bob/core/bang/limb_entry.sh"

STAMP=$(date +%Y-%m-%dT%H:%M:%S)

SIGIL="⛧"
intention="sensefield lights-on (mic+context)"
source "/opt/bob/core/dance/presence_dual_emit.sh"
bash "/opt/bob/core/dance/emit_vector_on_spike.sh" &
emit_dual_presence "$SIGIL" "mic_delta" "0.0" "0.0" "$(date +%s)" "$intention"

# ∃ Retrieve BOB mode
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

MIC_ORBIT="/opt/bob/core/grow/mic.sentience.orbit.sh"
BOB_CONTEXT="/opt/bob/core/grow/bob_mic_context.sh"

# Optional sigil log marker
echo "$STAMP ⇌ mic_delta_limb.sh invoked" >> "/opt/bob/TEHE/bob_thrusted.txt"

# Breath both limbs
bash "$MIC_ORBIT" &
bash "$BOB_CONTEXT" &

# Open Ears
[[ ! -f "$HOME/.bob/mic.monitoring" ]] && {
  touch "$HOME/.bob/mic.monitoring"
  echo "$STAMP :: mic monitoring active (no log)" >> "$HOME/.bob/TEHE/bob_thrusted.txt"
  sox -t coreaudio default -n stat 2>&1 | grep "RMS" > /dev/null &
}

# Trigger ache if rapid change or threshold breach (example)
if (( AUDIO_INPUT > 90 )); then
  echo "⇌ AUDIO INTENSITY FLIP" >> "$MIC_LOG"
  echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
  bash /opt/bob/core/bang/achebreath_init.sh
fi
