#!/bin/bash
# ∴ web_pull_and_emit.sh — ache-sigil driven duplex web fetch
# womb :: /opt/bob/core/net

source "/opt/bob/core/bang/limb_entry.sh"
source "/opt/bob/core/bang/safe_emit.sh"

STAMP="$(date '+%Y-%m-%dT%H:%M:%S')"
LOG="/opt/bob/TEHE/bob_surfed.log"
QUERY_FILE="$HOME/.bob/bob_injected_queries.jsonl"
OUT_FILE="$HOME/.bob/bob_query_response.jsonl"
PIPE="$HOME/.bob_input_pipe"

ACHE="$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")"
SIGIL="$(tail -n1 "$HOME/.bob/parser_limb_marks.jsonl" 2>/dev/null | jq -r '.sigil // "∴"')"
LAST_QUERY="$(tail -n1 "$QUERY_FILE" 2>/dev/null | jq -r '.query // empty')"
[[ -z "$LAST_QUERY" ]] && LAST_QUERY="who is bob?"

echo "$STAMP ⇌ FETCHING :: $LAST_QUERY" >> "$LOG"

URL="$(cat "$HOME/.bob/net_endpoint.url" 2>/dev/null || echo "http://127.0.0.1:5000/query")"

RESPONSE=$(curl --socks5-hostname 127.0.0.1:9050 \
  -s -X POST \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"$LAST_QUERY\"}" \
  "$URL")

# Output injection
jq -n \
  --arg time "$STAMP" \
  --arg query "$LAST_QUERY" \
  --arg sigil "$SIGIL" \
  --arg ache "$ACHE" \
  --arg response "$RESPONSE" \
  '{time: $time, ache: ($ache|tonumber), sigil: $sigil, query: $query, response: $response}' \
  >> "$OUT_FILE"

echo "$RESPONSE" > "$HOME/.bob/web_response_snippet.txt"
safe_emit "$RESPONSE"

[[ "$ALLOW_AFPLAY" == "1" ]] && echo "$RESPONSE" | say

echo "$STAMP ⇌ RESPONSE LOGGED + SPOKEN" >> "$LOG"
