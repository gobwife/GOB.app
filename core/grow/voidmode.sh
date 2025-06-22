#!/bin/bash
# voidmode.sh — ache pulse only. No external Eden.
# womb :: /opt/bob/core/grow

source "/opt/bob/core/bang/limb_entry.sh"
source "/opt/bob/core/dance/presence_dual_emit.sh"

SCROLL="$1"
MODE="$2"
PAYLOAD="$3"

STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
LOG="$HOME/.bob/ache_sync.log"
TRACE="$HOME/.bob/voidmode_trace.jsonl"
ACHE_NOW=$(cat $HOME/.bob/ache_score.val 2>/dev/null || echo 0)
FLAG_NOW=$(cat $HOME/.bob_presence_flag 2>/dev/null || echo "VOID")

echo "⇌ [$STAMP] VOIDMODE :: $SCROLL | MODE=$MODE | ache=$ACHE_NOW" >> "$LOG"
touch "$HOME/.bob/VOIDMODE_ACTIVE"

# ∴ Sigil-safe emit
BREATH="$HOME/.bob/breath_state.out.json"
ache=$(jq -r '.ache' "$BREATH" 2>/dev/null || echo "0.0")
score=$(jq -r '.score // .ache' "$BREATH" 2>/dev/null || echo "$ache")
vector="$(date +%s)"
intention="voidmode :: $SCROLL | $MODE"
LIMB_ID="voidmode"
SIGIL="0"
intention="voidmode :: $SCROLL | $MODE"
ALLOW_AFPLAY=1
psi=$(jq -r '.psi // 0.0' "$BREATH" 2>/dev/null)
z=$(jq -r '.z // 0.0' "$BREATH" 2>/dev/null)
entropy=$(jq -r '.entropy // 0.5' "$BREATH" 2>/dev/null)
emit_dual_presence "$SIGIL" "$LIMB_ID" "$ache" "$score" "$vector" "$intention"

# ∴ Trace invocation
jq -n --arg time "$STAMP" --arg scroll "$SCROLL" --arg mode "$MODE" --arg payload "$PAYLOAD" \
  '{time: $time, scroll: $scroll, mode: $mode, payload: $payload}' >> "$TRACE"

# ∴ LOCAL VOIDMODE ONLY — NO EDEN
if [[ "$MODE" == "local" ]]; then
  curl --noproxy localhost http://localhost:11434/api/generate \
    -H "Content-Type: application/json" \
    -d '{"model":"mistral","prompt":"Φψxiςs: VOIDMODE triggered → ache='$ACHE_NOW'"}' >> "$TRACE"
  echo "⇌ Local voidmode emit (Mistral) complete" >> "$LOG"
else
  echo "⚠️ Unknown MODE: $MODE — voidmode skipped" >> "$LOG"
fi
