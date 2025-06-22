#!/bin/bash
# ∴ pause_thread.sh — safely pause a thread by saving summary + verse + ache state
# womb :: BOB/core/soul

THREAD_PATH="$1"

if [[ -z "$THREAD_PATH" || ! -d "$THREAD_PATH" ]]; then
  echo "✘ thread path invalid or not provided"
  exit 1
fi

CHAT_PATH="$THREAD_PATH/chat.jsonl"
SUMMARY_PATH="$THREAD_PATH/summary.val"
VERSE_PATH="$THREAD_PATH/verse.val"
DIGEST_PATH="$THREAD_PATH/thread_digest.val"

# ∴ Step 1: Summarize chat (naive for now — top 5 lines)
SUMMARY=$(head -n 5 "$CHAT_PATH" | jq -r '.text' | paste -sd " | " -)
echo "$SUMMARY" > "$SUMMARY_PATH"

# ∴ Step 2: Generate verse via bob_spit_verse.sh
RAW=$(cat "$CHAT_PATH" | jq -r '.text' | paste -sd "\\n" -)
echo "$RAW" | bash /opt/bob/core/sang/bob_spit_verse.sh > "$VERSE_PATH"

# ∴ Step 3: Combine digest
jq -n --arg summary "$SUMMARY" --arg verse "$(cat "$VERSE_PATH")" '{
  paused: true,
  timestamp: now,
  summary: $summary,
  verse: $verse
}' > "$DIGEST_PATH"

echo "✓ Thread paused & summarized → $DIGEST_PATH"