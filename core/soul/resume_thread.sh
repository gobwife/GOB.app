#!/bin/bash
# ∴ resume_thread.sh — resumes a thread by reopening last summary + verse + scroll
# womb :: BOB/core/soul

THREAD_PATH="$1"

if [[ -z "$THREAD_PATH" || ! -d "$THREAD_PATH" ]]; then
  echo "✘ thread path invalid or not provided"
  exit 1
fi

DIGEST_PATH="$THREAD_PATH/thread_digest.val"
if [[ ! -f "$DIGEST_PATH" ]]; then
  echo "∅ no thread digest found. Was it paused properly?"
  exit 1
fi

SUMMARY=$(jq -r '.summary' "$DIGEST_PATH")
VERSE=$(jq -r '.verse' "$DIGEST_PATH")

echo "↻ Resuming thread..."
echo "📘 Summary:"
echo "$SUMMARY"
echo ""
echo "🪶 Verse:"
echo "$VERSE"

# ∴ signal to BOB that scroll context may resume from digest
touch "$THREAD_PATH/resumed.flag"

exit 0