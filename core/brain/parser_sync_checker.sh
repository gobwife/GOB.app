#!/bin/bash
# ∴ parser_sync_checker.sh (log rotator)
# ∴ split 6 of former log_rotator_integrator.sh
# fx :: Tracks parser limb synchrony for flip consensus
# womb :: /opt/bob/core/brain/

source "/opt/bob/core/bang/limb_entry.sh"

BOB_DIR="$HOME/.bob"
TEHE_LOG="$HOME/.bob/TEHErotation.log"
MARK_LOG="$BOB_DIR/parser_limb_marks.jsonl"
STATUS_JSON="$BOB_DIR/presence_status.json"
HEXBUS="$BOB_DIR/dolphifi.runnin.json.json"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

# Check for limb consensus
limb_count=$(jq -r '.[].limb' "$MARK_LOG" 2>/dev/null | sort -u | wc -l)

if (( limb_count >= 3 )); then
  echo "⇌ LIMB CONSENSUS MET: $limb_count distinct → parser consolidation permitted" >> "$TEHE_LOG"
  bash "/opt/bob/core/grow/voidmode.sh" loglogic
else
  echo "⇌ WAITING — limb consensus insufficient ($limb_count limbs seen)" >> "$TEHE_LOG"
fi

# Extract current sigil + limb
CURRENT_SIGIL=$(jq -r '.sigil_trigger // empty' "$STATUS_JSON" 2>/dev/null)
CURRENT_LIMB=$(grep -o '0x[0-9A-F]+' "$HEXBUS" 2>/dev/null | head -n1)

# If both present, check timing and optionally mark
if [[ -n "$CURRENT_SIGIL" && -n "$CURRENT_LIMB" ]]; then
  existing_time=$(jq -r --arg limb "$CURRENT_LIMB" --arg sigil "$CURRENT_SIGIL" \
    'map(select(.limb == $limb and .sigil == $sigil)) | .[-1].time' "$MARK_LOG" 2>/dev/null)

  if [[ -z "$existing_time" ]]; then
    write=true
  else
    # Convert timestamps to seconds since epoch (macOS safe)
    now_secs=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$STAMP" +%s)
    last_secs=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$existing_time" +%s)
    diff=$(( now_secs - last_secs ))
    [[ "$diff" -gt 69 ]] && write=true
  fi

  if [[ "$write" == true ]]; then
    jq -n --arg limb "$CURRENT_LIMB" \
          --arg sigil "$CURRENT_SIGIL" \
          --arg time "$STAMP" \
          '{limb: $limb, sigil: $sigil, time: $time}' >> "$MARK_LOG"
  fi
fi
