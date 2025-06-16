#!/bin/bash
# ∴ tehe_flipper.sh — rotates identical @*.tehe logs into one + logs into lineage
# womb :: $HOME/BOB/core/heal

TEHE_DIR="$HOME/BOB/TEHE"
STAMP=$(date '+%m.%d.%Y_%H%M%S')
LINEAGE_LOG="$HOME/.bob/presence_lineage_graph.jsonl"

declare -A content_map

for file in "$TEHE_DIR"/@*.tehe; do
  [ -f "$file" ] || continue
  content=$(cat "$file")
  content_map["$content"]+="$file "
done

for content in "${!content_map[@]}"; do
  files=(${content_map[$content]})
  count=${#files[@]}

  if (( count >= 16 )); then
    newfile="$TEHE_DIR/@$STAMP.tehe"
    echo "⇌ 1111 MINUTE PRESENCE LOOP HELD — $count× confirmed — $STAMP" > "$newfile"

    for f in "${files[@]}"; do
      rm -f "$f"
    done

    jq -n --arg time "$(date +%s)" \
          --arg type "tehe_rotation" \
          --arg count "$count" \
          --arg file "$newfile" \
          '{t: $time|tonumber, event: $type, count: $count|tonumber, file: $file}' >> "$LINEAGE_LOG"
  fi
done
