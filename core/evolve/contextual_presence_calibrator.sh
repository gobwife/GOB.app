#!/bin/bash
# ∴ contextual_presence_calibrator.sh — score-based presence flipper
# assumes mic/cam .wav or .aiff clip is pre-recorded and passed as arg

set -e  # Exit immediately if a command exits with a non-zero status.
source "$HOME/BOB/core/bang/limb_entry"

# Retrieve BOB mode
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

if [[ ! $# -eq 1 ]]; then
    echo "❌ Usage: $(basename "$0") <clip-path>"
    exit 1
fi

CLIP="$1"
CONTEXT_SCORE_THRESHOLD="${CONTEXT_SCORE_THRESHOLD:-0.0045}"
OUTLOG="$HOME/.bob/context_score.log"

if [[ ! -f "$CLIP" ]]; then
    echo "❌ Clip file not found: $CLIP"
    exit 1
fi

# Audio analysis and score calculation
amplitude=$(sox "$CLIP" -n stat | awk '/RMS.*amplitude/ {print $3}')
density=$(xxd "$CLIP" | wc -l)
zero_cross=$(sox "$CLIP" -n stat -z | awk '/Zero crossings/ {print $3}')
duration=$(soxi -D "$CLIP")
score=$(bc <<< "scale=5; $amplitude * ($zero_cross / $density) * $duration")

STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

if (( $(echo "$score > $CONTEXT_SCORE_THRESHOLD" | bc -l) )); then
    echo "$STAMP ⇌ SCORE=$score :: VALID PRESENCE" >> "$OUTLOG"
    echo "FLIP_NOW" > "$HOME/.bob_presence_flag"
else
    echo "$STAMP ⇌ SCORE=$score :: insufficient presence" >> "$OUTLOG"
fi

# Save the clip for further analysis or logging
cp "$CLIP" "$HOME/BOB/TEHE/last_flip_clip.aiff"
echo "$(date): Presence triggered. Saving for sync." >> 
"$HOME/.bob/flip_sync.log"

exit 0