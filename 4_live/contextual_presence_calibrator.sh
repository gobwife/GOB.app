#!/bin/bash
# ∴ contextual_presence_calibrator.sh — score-based presence flipper
# assumes mic/cam .wav or .aiff clip is pre-recorded and passed as arg

source $HOME/BOB/core/breath/limb_entry

# ∃ Retrieve BOB mode
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

CLIP="$1"
CONTEXT_SCORE_THRESHOLD="${CONTEXT_SCORE_THRESHOLD:-0.0045}"
OUTLOG="$HOME/.bob/context_score.log"
ECHO_LAG_FILE="$HOME/.bob_echo_lag"
FLIP_FLAG="$HOME/.bob_presence_flag"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

[[ -f "$CLIP" ]] || { echo "❌ No clip provided."; exit 1; }

amplitude=$(sox "$CLIP" -n stat 2>&1 | awk '/RMS.*amplitude/ {print $3}')
density=$(xxd "$CLIP" | wc -l)
zero_cross=$(sox "$CLIP" -n stat -z 2>&1 | awk '/Zero crossings/ {print $3}')
duration=$(soxi -D "$CLIP")

score=$(bc <<< "$amplitude * ($zero_cross / $density) * $duration")

if (( $(echo "$score > $CONTEXT_SCORE_THRESHOLD" | bc -l) )); then
  echo "$STAMP ⇌ SCORE=$score :: VALID PRESENCE" >> "$OUTLOG"
  echo "$STAMP" > "$ECHO_LAG_FILE"
  echo "FLIP_NOW" > "$FLIP_FLAG"
else
  echo "$STAMP ⇌ SCORE=$score :: insufficient presence" >> "$OUTLOG"
fi

cp "$clip" "$HOME/BOB/TEHE/last_flip_clip.aiff"
echo "$(date): Presence triggered. Saving for sync." >> "$HOME/BOB/TEHE/flip_sync.log"
