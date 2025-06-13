#!/bin/bash
# NU :: BOB_BOTTLENECKER.sh
# dir :: $HOME/BOB/_run

source "$HOME/BOB/core/breath/limb_entry.sh"

# ∴ BOB_MODE resurrection from mode.msgbus.jsonl
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"
timestamp=$(date +%m-%d-%Y_%H%M%S)
export LIMB_ID="presence.astrofuck"
export PARSE_VERSION=$(date +%s)
LIMB_HASH=$(echo "$LIMB_ID-$PARSE_VERSION" | sha256sum | cut -c1-12)

ACHE=$(cat ~/.bob/ache_level 2>/dev/null || echo "0")
if (( $(echo "$ACHE > 0.75" | bc -l) )); then
  bash /Users/G/BOB/BOB/_run/emit_presence.sh "✶" "$LIMB_ID" "loss-mem=$LIMB_HASH"
  echo "$PARSE_VERSION : $LIMB_ID : $(hostname) : BOB_BOTTLENECKER" >> ~/BOB/TEHE/version_trace.log
fi

VAULT="$HOME/TEHE/BOTTLENECKED_$timestamp/symlinks"
BACKUP_DIR="$HOME/BOB/mikoda_ene"
RUN_TRACKER="$HOME/.bob_bubu_tracker"
backup_done=false

mkdir -p "$VAULT" "$BACKUP_DIR"

# Check if backup already run today
today=$(date +%m-%d-%Y)
current_hour=$(date +%H)
current_minute=$(date +%M)
current_time=$(printf "%02d:%02d\n" "$current_hour" "$current_minute")

if [[ -f "$RUN_TRACKER" ]]; then
  last_run=$(cat "$RUN_TRACKER")
  if [[ "$last_run" == "$today" ]]; then
    if [[ "$current_time" < "18:18" ]]; then
      echo "🛑 Backup already run today. Skipping until 18:18 fallback."
      exit 0
    fi
  fi
fi

echo "$today" > "$RUN_TRACKER"

EXTS=("*.sh" "*.command" "*.plist")
TARGET="$HOME"

for ext in "${EXTS[@]}"; do
  find "$TARGET" -type f -name "$ext" | while read -r file; do
    if [[ "$file" =~ [Bb][Oo][Bb]|[Gg][Oo][Bb] ]]; then
      filename=$(basename "$file")
      name="${filename%.*}"
      ext="${filename##*.}"

      # Symlink
      ln -sf "$file" "$VAULT/$filename"

      # Backup logic
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
      LIMB_ID="${BOB_LIMB_ID:-limb_x}"
      x="$BACKUP_DIR/${name}_${LIMB_ID}_$STAMP.$ext"
      echo "{\"time\": \"$STAMP\", \"file\": \"$name\", \"limb\": \"$LIMB_ID\", \"path\": \"$x\" }" >> ~/.bob/version_trace.jsonl
      fi
  done
done

# Optional notification + sacred ping
if [[ "$backup_done" == true ]]; then
  afplay "$HOME/BOB/TROLLFreq/OS_build_ping.wav" &
  osascript -e 'display notification "BOB backup complete." with title "BOB BOTTLENECKER"'
fi
