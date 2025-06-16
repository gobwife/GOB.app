#!/bin/bash
# ∴ save_thread_summary.sh — generates summary + verse for thread but does not pause it
# womb :: BOB/core/soul

THREAD_PATH="$1"

if [[ -z "$THREAD_PATH" || ! -d "$THREAD_PATH" ]]; then
  echo "✘ thread path invalid or not provided"
  exit 1
fi

CHAT_PATH="$THREAD_PATH/chat.jsonl"
SUMMARY_PATH="$THREAD_PATH/summary.val"
VERSE_PATH="$THREAD_PATH/verse.val"

# ∴ Step 1: Summarize chat (naive again — first 5 lines)
SUMMARY=$(head -n 5 "$CHAT_PATH" | jq -r '.text' | paste -sd " | " -)
echo "$SUMMARY" > "$SUMMARY_PATH"

# ∴ Step 2: Verse from BOB
RAW=$(cat "$CHAT_PATH" | jq -r '.text' | paste -sd "\\n" -)
echo "$RAW" | bash ~/BOB/core/sang/bob_spit_verse.sh > "$VERSE_PATH"

echo "✓ Thread summary saved."
echo "📘 summary.val and 🪶 verse.val updated in $THREAD_PATH"