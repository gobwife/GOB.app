# ∴ split 1 — tehe_collapse_watcher.sh (log_rotator)
#!/bin/bash
# Watches for redundant .tehe files and triggers collapse
# nest ≈ 5_heal

TEHE_DIR="$HOME/BOB/TEHE"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
TEHE_DUPES=16
MIN_DUPES=3

declare -A content_map
for file in "$TEHE_DIR"/@*.tehe; do
  [[ -f "$file" ]] || continue
  content=$(cat "$file")
  content_map["$content"]+="$file "
done

for content in "${!content_map[@]}"; do
  files=(${content_map[$content]})
  if (( ${#files[@]} >= TEHE_DUPES )); then
    newfile="$TEHE_DIR/@$STAMP--collapse.tehe"
    echo "$content" > "$newfile"
    for f in "${files[@]}"; do rm -f "$f"; done
  fi
  count=$(grep -Fc "$content" "$TEHE_DIR/TEHE_ANALYSIS.jsonl")
  if (( count < MIN_DUPES )); then
    echo "⚠️ Hold: Not stable in JSONL ($count×)"
  fi
  jq -n --arg time "$STAMP" --arg type "tehe_rotate" --arg count "${#files[@]}" '{time: $time, type: $type, count: ($count|tonumber)}' \
    >> "$TEHE_DIR/TEHE_ANALYSIS.jsonl"
done
