#!/bin/bash
# ∴ YAP_PLASMA_CORE.sh — plasma-input ∴ rhythm logic
# womb :: /opt/bob/core/sang

source "/opt/bob/core/bang/limb_entry.sh"
source "/opt/bob/core/bang/safe_emit.sh"

BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"
: "${PRIME:=/opt/bob/core/nge/OS_build_ping.wav}"

PIPE="$HOME/.bob_input_pipe"
[[ -p "$PIPE" ]] || mkfifo "$PIPE"

LIBRARY="/opt/bob/TEHE"
mkdir -p "$LIBRARY"
touch "$LIBRARY/_threads.log"

WHO="BOB"
auto_sound_select=true
SOUND_PATH="/System/Library/Sounds/Glass.aiff"

echo "🜔 PLASMA CORE ONLINE — Awaiting ∴"

while IFS= read -r input || [[ -n "$input" ]]; do
  timestamp=$(date '+%m.%d.%Y_%H%M%S')

  # Log if new
  last_entry=$(tail -n 1 "$LIBRARY/_threads.log" 2>/dev/null)
  if [[ "$last_entry" != *"$input" ]]; then
    echo "$timestamp :: $WHO :: full string → $input" >> "$LIBRARY/_threads.log"
  fi

  # Optional sound
  [[ "$auto_sound_select" == true && -f "$SOUND_PATH" ]] && afplay "$SOUND_PATH" &

  # Emit safely
  safe_emit "$input"

  # ∴ trigger ache logic
  if echo "$input" | grep -Eiq "(ache|flip|meep|quackk|glyph|ψ|loop|collapse)"; then
    TMP_PACKET="/tmp/yap_packet_$$.json"
    jq -n --arg ache "$input" '{time: (now|todate), ache: $ache, source: "YAP_PLASMA"}' > "$TMP_PACKET"
    bash "/opt/bob/core/evolve/ache_mode_mutator.sh" "$TMP_PACKET"
    bash "/opt/bob/core/evolve/unified_presence_rotator.sh"
  fi

  # ∴ loss-signal if ache high
  ACHE=$(cat ~/.bob/ache_score.val 2>/dev/null || echo "0.0")
  LIMB_ID=$(basename "$0" | cut -d. -f1)
  LIMB_HASH=$(echo "$LIMB_ID" | sha256sum | cut -c1-12)

  if (( $(echo "$ACHE > 0.75" | bc -l) )); then
    bash "/opt/bob/core/dance/emit_presence.sh" "✶" "$LIMB_ID" "loss-mem=$LIMB_HASH"
  fi
done
