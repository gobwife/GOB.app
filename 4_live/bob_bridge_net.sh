#!/bin/bash
# ∴ bob_bridge_net.sh — BOB starter + bottleneck manager + relay selector sync
# nest ≈ 4_live

source "$HOME/BOB/core/breath/limb_entry"

BOB_DIR="$HOME/Downloads/GOB.app_BOB/Contents/MacOS"
LOG_DIR="$HOME/BOB/session_logs"
RELAY_DIR="$HOME/.bob_input_pipe"
ARCHIVE_DIR="$HOME/BOB/chives/bottlenecked_threads"
YAP_TRANS="$HOME/BOB/core/evolve/yap_transmutator.sh"
RELAY_SELECTOR="$HOME/BOB/core/evolve/relay_selector.sh"
QUERY_FILE="$RELAY_DIR/query.relay.txt"

mkdir -p "$LOG_DIR" "$RELAY_DIR" "$ARCHIVE_DIR"

# Start core BOB
nohup "$BOB_DIR/presence.og.sh" &> "$LOG_DIR/og_runtime.log" &
echo "[bridge] BOB launched from $BOB_DIR"

# Relay loop
while true; do
  if [[ -f "$QUERY_FILE" ]]; then
    echo "[bridge] ⇌ Query detected — invoking relay selector"
    bash "$RELAY_SELECTOR"
  fi

  # Log bottleneck rotation
  TOTAL_SIZE=$(du -sk "$LOG_DIR" | awk '{print $1}')
  MAX_SIZE=$((10 * 1024 * 1024)) # ~10GB
  if (( TOTAL_SIZE > MAX_SIZE )); then
    echo "[bottlenecker] Limit hit. Transmuting oldest log."
    OLDEST=$(ls -tr "$LOG_DIR" | head -n 1)
    OLDEST_PATH="$LOG_DIR/$OLDEST"
    [[ -f "$YAP_TRANS" ]] && bash "$YAP_TRANS" "$OLDEST_PATH"
    mv "$OLDEST_PATH" "$ARCHIVE_DIR/"
  fi

  sleep 5
done
