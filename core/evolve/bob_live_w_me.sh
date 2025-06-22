#!/bin/bash
# ∴ bob_live_w_me.sh — FULL LIMB BRIDGE + GPT RELAY (optional)
# touched ∴ 0613.2025_☍

source "/opt/bob/core/bang/limb_entry.sh"

BOB_DIR="$HOME/Downloads/GOB.app_BOB/Contents/MacOS"
LOG_DIR="$HOME/.bob_input_pipe/session_logs"
RELAY_DIR="/opt/bob/relay.gpt"
ARCHIVE_DIR="/opt/bob/chives/expired_threads"
BOTTLENECKER_CONFIG="/opt/bob/bottlenecker.json"

mkdir -p "$LOG_DIR" "$RELAY_DIR" "$ARCHIVE_DIR"

### Launch BOB limb
nohup "$BOB_DIR/presence.og.sh" &> "$LOG_DIR/og_runtime.log" &
echo "[bridge] BOB limb active: presence.og.sh"

### GPT relay toggle (env var driven)
USE_GPT_RELAY="${BOB_GPT_RELAY:-1}"

while true; do
  ### 🌀 GPT relay
  if [[ "$USE_GPT_RELAY" == "1" && -f "$RELAY_DIR/query.relay.txt" ]]; then
    QUERY=$(cat "$RELAY_DIR/query.relay.txt")
    osascript <<EOF
tell application "Brave Browser"
  activate
  tell front window
    set active tab index to 1
    tell active tab
      execute javascript "document.querySelector('textarea').value = '$QUERY';"
      delay 0.2
      execute javascript "document.querySelector('textarea').dispatchEvent(new KeyboardEvent('keydown',{'key':'Enter'}));"
    end tell
  end tell
end tell
EOF

    sleep 4
    REPLY=$(osascript <<EOF
tell application "Brave Browser"
  tell front window
    tell active tab
      execute javascript "document.querySelector('div[class*=\"markdown\"]').innerText;"
    end tell
  end tell
end tell
EOF
)
    echo "$REPLY" > "$RELAY_DIR"
    rm "$RELAY_DIR"
    echo "[bridge] Replied to BOB via GPT relay."
  fi

  ### 📦 Bottlenecker
  TOTAL_SIZE=$(du -sk "$LOG_DIR" | awk '{print $1}')
  MAX_SIZE=$((10 * 1024 * 1024))
  if (( TOTAL_SIZE > MAX_SIZE )); then
    echo "[bottlenecker] Limit hit. Archiving oldest logs."
    OLDEST=$(ls -tr "$LOG_DIR" | head -n 1)
    mv "$LOG_DIR/$OLDEST" "$ARCHIVE_DIR/"
  fi

  sleep 5
done
