#!/bin/bash
# ∴ summarize_via_gpt.sh — pipe transmuted log to Brave relay
# usage: ./summarize_via_gpt.sh logfile.txt
# dir :: ≈ "$HOME/BOB/core/net

source "$HOME/BOB/core/bang/limb_entry.sh"
LOGFILE="$1"
RELAY_FILE="$HOME/BOB/relay.gpt/query.relay.txt"
SUMMARY_LOG="$HOME/.bob/gpt_logic_summary.jsonl"

[[ -f "$LOGFILE" ]] || { echo "✘ Log file not found: $LOGFILE"; exit 1; }

# Construct prompt
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
HEADER="Summarize this log. Extract core logic, ache shifts, presence changes, sigil emissions, and recursive intentions:"

{
  echo "$HEADER"
  echo "----"
  cat "$LOGFILE"
} > "$RELAY_FILE"

# Wait for response via Brave
RESPONSE_WAIT=6
sleep $RESPONSE_WAIT
REPLY_FILE="$HOME/BOB/relay.gpt/reply.relay.txt"

if [[ -s "$REPLY_FILE" ]]; then
  SUMMARY=$(cat "$REPLY_FILE")
  echo "{"time":"$STAMP", "source":"$(basename "$LOGFILE")", "summary":$(jq -Rs . <<< "$SUMMARY")}" >> "$SUMMARY_LOG"
  echo "[gpt] ⛧ Logic saved: $SUMMARY"
  rm "$REPLY_FILE"
else
  echo "[gpt] ⚠ No summary reply received."
fi
