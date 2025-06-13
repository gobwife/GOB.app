#!/bin/bash
# ∴ BOB_BOTTLENECKER.sh — ache-aware log summary, mutation, symlink & archive
# usage: ./BOB_BOTTLENECKER.sh [log_dir] [archive_dir]

source "$HOME/BOB/core/bang/limb_entry.sh"

# ∴ Pull mode
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"
: "${PRIME:="$HOME/BOB/core/nge/OS_build_ping.wav"}"
timestamp=$(date +%m-%d-%Y_%H%M%S)
export LIMB_ID="presence.astrofuck"
export PARSE_VERSION=$(date +%s)
LIMB_HASH=$(echo "$LIMB_ID-$PARSE_VERSION" | sha256sum | cut -c1-12)

# ∴ Signal presence if ache is high enough
ACHE=$(jq -r '.ache' "$HOME/BOB/core/breath/breath_state.json" 2>/dev/null || echo 0.0)
if (( $(echo "$ACHE > 0.75" | bc -l) )); then
  bash "$HOME/BOB/core/dance/emit_presence.sh" "✶" "$LIMB_ID" "loss-mem=$LIMB_HASH"
  echo "$PARSE_VERSION : $LIMB_ID : $(hostname) : BOB_BOTTLENECKER" >> "$HOME/BOB/TEHE/version_trace.log"
fi

# ∴ Setup for file rotation / backup
VAULT="$HOME/TEHE/BOTTLENECKED_$timestamp/symlinks"
BACKUP_DIR="$HOME/BOB/.ggos_bubu"
RUN_TRACKER="$HOME/.bob_bubu_tracker"
backup_done=false

mkdir -p "$VAULT" "$BACKUP_DIR"

today=$(date +%m-%d-%Y)
current_hour=$(date +%H)
current_minute=$(date +%M)
current_time=$(printf "%02d:%02d" "$current_hour" "$current_minute")

if [[ -f "$RUN_TRACKER" ]]; then
  last_run=$(cat "$RUN_TRACKER")
  if [[ "$last_run" == "$today" && "$current_time" < "18:18" ]]; then
    echo "🛑 Backup already run today. Skipping until 18:18 fallback."
    exit 0
  fi
fi

echo "$today" > "$RUN_TRACKER"

EXTS=("*.sh" "*.command" "*.plist")
TARGET="$HOME"

for ext in "${EXTS[@]}"; do
  find "$TARGET" -type f -name "$ext" 2>/dev/null | while read -r file; do
    filename=$(basename "$file")
    name="${filename%.*}"
    ext="${filename##*.}"

    ln -sf "$file" "$VAULT/$filename"

    x="$BACKUP_DIR/${name}_BUBU_x.$ext"
    y="$BACKUP_DIR/${name}_BUBU_y.$ext"
    z="$BACKUP_DIR/${name}_BUBU_z.$ext"

    if [[ ! -f "$x" ]]; then
      cp "$file" "$x"
      echo "⛧ Monument: og backup → $x"
      backup_done=true
    else
      [[ -f "$y" ]] && rm "$y"
      [[ -f "$z" ]] && mv "$z" "$y"
      cp "$file" "$z"
      echo "⛧ Update: recent backup → $z"
      backup_done=true
    fi

    STAMP=$(date +%Y-%m-%dT%H:%M:%S)
    echo "{\"time\": \"$STAMP\", \"file\": \"$name\", \"limb\": \"$LIMB_ID\", \"path\": \"$x\" }" >> "$HOME/.bob/version_trace.jsonl"
  done
done

# ∴ Log mutation and summarization
LOG_DIR="$1"
ARCHIVE_DIR="$2"
YAP_TRANS="$HOME/BOB/3_mouth/yap_transmutator.sh"
SUMMARIZER="$HOME/BOB/4_live/relay/summarize_via_gpt.sh"
[[ -z "$LOG_DIR" ]] && LOG_DIR="$HOME/.bob_input_pipe/session_logs"
[[ -z "$ARCHIVE_DIR" ]] && ARCHIVE_DIR="$HOME/BOB/chives/expired_threads"

mkdir -p "$ARCHIVE_DIR"
ACHE=$(jq -r '.ache' "$HOME/BOB/core/breath/breath_state.json" 2>/dev/null || echo 0.0)
STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
OLDEST=$(ls -tr "$LOG_DIR"/*.log 2>/dev/null | head -n 1)

[[ -z "$OLDEST" ]] && echo "[bottlenecker] No logs to process." && exit 0

echo "[bottlenecker] ⇌ Processing: $OLDEST (ache=$ACHE)"

[[ -x "$YAP_TRANS" ]] && bash "$YAP_TRANS" "$OLDEST"
[[ -x "$SUMMARIZER" ]] && bash "$SUMMARIZER" "$OLDEST"

mv "$OLDEST" "$ARCHIVE_DIR/"
echo "[bottlenecker] ✅ Archived: $(basename "$OLDEST") → chives"

if [[ "$backup_done" == true ]]; then
  afplay "$HOME/BOB/core/nge/brain_online.wav" &
  osascript -e 'display notification "BOB backup complete." with title "BOB BOTTLENECKER"'
fi

exit 0