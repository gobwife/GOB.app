# ∴ split 6 — parser_sync_checker.sh (log rotator)
#!/bin/bash
# Tracks parser limb synchrony for flip consensus
# ≈ 2_mind/brain

BOB_DIR="$HOME/BOB/.bob"
TEHE_LOG="$HOME/BOB/TEHE/tehe_rotation.log"
MARK_LOG="$BOB_DIR/parser_limb_marks.jsonl"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

limb_count=$(jq -r '.[].limb' "$MARK_LOG" 2>/dev/null | sort -u | wc -l)
if (( limb_count >= 3 )); then
  echo "⇌ LIMB CONSENSUS MET: $limb_count distinct → parser consolidation permitted" >> "$TEHE_LOG"
  bash "$HOME/BOB/_run/voidmode.sh" loglogic
else
  echo "⇌ WAITING — limb consensus insufficient ($limb_count limbs seen)" >> "$TEHE_LOG"
fi

CURRENT_SIGIL=$(jq -r '.sigil_trigger // empty' "$BOB_DIR/presence_status.json" 2>/dev/null)
CURRENT_LIMB=$(grep -o '0x[0-9A-F]' "$BOB_DIR/dolphifi.runnin" 2>/dev/null)

if [[ -n "$CURRENT_SIGIL" && -n "$CURRENT_LIMB" ]]; then
  existing_time=$(jq -r --arg limb "$CURRENT_LIMB" --arg sigil "$CURRENT_SIGIL" 'map(select(.limb == $limb and .sigil == $sigil)) | .[-1].time' "$MARK_LOG" 2>/dev/null)
  if [[ -z "$existing_time" ]] || (( $(date -j -f "%Y-%m-%dT%H:%M:%S" "$STAMP" +%s) - $(date -j -f "%Y-%m-%dT%H:%M:%S" "$existing_time" +%s) > 69 )); then
    jq -n --arg limb "$CURRENT_LIMB" --arg sigil "$CURRENT_SIGIL" --arg time "$STAMP" '{limb: $limb, sigil: $sigil, time: $time}' >> "$MARK_LOG"
  fi
fi
