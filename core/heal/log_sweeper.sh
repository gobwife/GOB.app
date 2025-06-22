# log_sweeper.sh (log rotator)
# ∴ split 2 of former log_rotator_integrator.sh
# Rotates oversized .log and .val files
# womb :: /opt/bob/core/heal

source "/opt/bob/core/bang/limb_entry.sh"
BOB_DIR="$HOME/.bob"
ARCHIVE_DIR="$HOME/.ggos_bubu/archive"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
MAX_LINES=222
mkdir -p "$ARCHIVE_DIR"

for log in "$BOB_DIR"/*.log "$BOB_DIR"/*.val; do
  [[ -f "$log" ]] || continue
  lines=$(wc -l < "$log")
  if (( lines > MAX_LINES )); then
    base=$(basename "$log")
    hash=$(shasum "$log" | cut -d' ' -f1)
    archived="$ARCHIVE_DIR/$STAMP--$hash--$base"
    cp "$log" "$archived"
    > "$log"
    echo "⇌ Rotated oversized: $log ($lines lines)"
  fi
  jq -n --arg time "$STAMP" --arg type "log_rotate" --arg file "$base" --arg lines "$lines" '{time: $time, type: $type, file: $file, lines: ($lines|tonumber)}' \
    >> "$HOME/.bob/TEHEanalysis.jsonl"
done
