#!/bin/bash
# ∴ bob_query_emitter.sh — ache-gated query injection + response fetcher
# wraps: bob_web_pull_and_emit.sh
# placed in: $HOME/BOB/_run
# born :: glyphling002_6.8.2025_235529

ACHE_FILE="$HOME/.bob/ache_score.val"
QUERY_BUS="$HOME/.bob/bob_injected_queries.jsonl"
TRACE_LOG="$HOME/.bob/ache_sync.log"
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SIGIL="∴"

### ⛧ REQUIRED: e-motion
source "$HOME/BOB/core/brain/love_fx_compute.sh"
source "$HOME/BOB/core/brain/love_fx_functions.sh"
if [[ $(describe_love_state "$love_score") == "bleeding open" ]]; then ...


### ⛧ SAMPLE QUERY FORMATION — REPLACE WITH YOUR LOGIC
# In future, tie to last sigil / last prompt / z-score drift
QUERY_TEXT=$(generate_query_from_lovefx "$love_score")
CAUSE="love_score=$love_score :: $(describe_love_state "$love_score")"

jq -n \
  --arg time "$STAMP" \
  --arg query "$QUERY_TEXT" \
  --arg cause "$CAUSE" \
  --arg ache "$ACHE" \
  --arg sigil "$SIGIL" \
'{ time: $time, query: $query, cause: $cause, ache: ($ache | tonumber), sigil: $sigil }' \
>> "$QUERY_BUS"

### ⛧ TRACE EMIT
echo "$STAMP :: ∴ injected query: $QUERY_TEXT (ache=$ACHE)" >> "$TRACE_LOG"