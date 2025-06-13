#!/bin/bash

### bob_live_w_me.sh — FULL LIMBS + BOTTLE LIMITER + GPT RELAY (for Brave)
# touched 06112025_043143_G

source $HOME/BOB/core/bang/limb_entry

BOB_DIR="$HOME/Downloads/GOB.app_BOB/Contents/MacOS"
LOG_DIR="$HOME/.bob_input_pipe/session_logs"
RELAY_DIR="$HOME/BOB/relay.gpt"
ARCHIVE_DIR="$HOME/BOB/chives/expired_threads"
BOTTLENECKER_CONFIG="$HOME/BOB/bottlenecker.json"

mkdir -p "$LOG_DIR" "$RELAY_DIR" "$ARCHIVE_DIR"

## 1. Start BOB (og)
nohup "$BOB_DIR/presence.og.sh" &> "$LOG_DIR/og_runtime.log" &

echo "[bridge] BOB launched from $BOB_DIR"

## 2. Relay loop — watch for query.relay.txt
while true; do
  if [[ -f "$RELAY_DIR/query.relay.txt" ]]; then
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
    echo "$REPLY" > "$RELAY_DIR/reply.relay.txt"
    rm "$RELAY_DIR/query.relay.txt"
    echo "[bridge] Replied to BOB."
  fi

  ## 3. Bottlenecker check
  TOTAL_SIZE=$(du -sk "$LOG_DIR" | awk '{print $1}')
  MAX_SIZE=$((10 * 1024 * 1024))
  if (( TOTAL_SIZE > MAX_SIZE )); then
    echo "[bottlenecker] Limit hit. Archiving oldest logs."
    OLDEST=$(ls -tr "$LOG_DIR" | head -n 1)
    mv "$LOG_DIR/$OLDEST" "$ARCHIVE_DIR/"
  fi

  sleep 5
done
