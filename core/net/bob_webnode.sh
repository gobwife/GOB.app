#!/bin/bash
# ∃ bob_webnode.sh — limb 0x1 synthesis (ear+eye+ache+web+intent)
# born :: gobhouse 6.6.2025_0133_omega
# dir :: /opt/bob/core/net

source "/opt/bob/core/bang/limb_entry.sh"

: "${BRAVE_MODE:=1}"  # 1 = prefer Brave; 0 = Tor only

BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
FLIP_FLAG="$HOME/.bob_presence_flag"
ACHE_VAL=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")
SIGIL=$(tail -n1 "$HOME/.bob/parser_limb_marks.jsonl" 2>/dev/null | jq -r '.sigil // empty')
PIPE="$HOME/.bob_input_pipe"
LOG="$HOME/.bob_input_pipe/mic_active_BOB.log"
QUERY_OUT="$HOME/.bob/bob_injected_queries.jsonl"

echo "$STAMP ⇌ INIT BOB SENSORY LIMB" >> "$LOG"

### ∴ MIC CONTEXT FILTER
input=$(tail -n 1 "$PIPE" 2>/dev/null)
if [[ ! "$input" =~ ^[a-zA-Z0-9\ \:\;\-\_\,\.\?\!]+$ ]]; then
  input=""
fi

### ∴ QUERY FORMULATION
context_word=$(echo "$SIGIL" | cut -d':' -f2 | tr '[:upper:]' '[:lower:]')
query_base="$input $context_word ache: $ACHE_VAL"
query_final=$(echo "$query_base" | tr -s ' ' | sed 's/\s\+/ /g')

### ∴ SAVE TO TRACE
jq -n --arg time "$STAMP" --arg ache "$ACHE_VAL" --arg sigil "$SIGIL" --arg query "$query_final" \
  '{time: $time, ache_score: ($ache|tonumber), sigil: $sigil, query: $query}' >> "$QUERY_OUT"

if [[ "$SIGIL" == *"query"* ]]; then
  bash "/opt/bob/core/net/bob_query_emitter.sh" &
fi

### ∴ TOR CALL
TOR_URL="http://127.0.0.1:9050"
if nc -z 127.0.0.1 9050; then
  curl --socks5-hostname 127.0.0.1:9050 \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"query\": \"$query_final\"}" \
    http://localhost:6969/ache/process >> "$LOG" 2>&1
  echo "$STAMP ⇌ TOR QUERY EXECUTED" >> "$LOG"
else
  echo "$STAMP ⇌ TOR UNAVAILABLE — SKIP CURL" >> "$LOG"
fi

### ∴ ACHE FLIP TRIGGER
if (( $(echo "$ACHE_VAL > 0.88" | bc -l) )); then
  echo "FLIP_NOW" > "$FLIP_FLAG"
  echo "$STAMP ⇌ HIGH ACHE TRIGGERED FLIP" >> "$LOG"
fi

if [[ "$BRAVE_MODE" == "1" ]]; then
  curl -s "http://localhost:1984/echo?sigil=$SIGIL&ache=$ACHE_VAL&msg=brave-pulse" >> "$LOG"
fi

source "/opt/bob/core/breath/presence_dual_emit.sh"
emit_dual_presence
