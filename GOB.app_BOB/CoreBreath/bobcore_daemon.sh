#!/bin/bash
# 🜔 bobcore_daemon.sh

BOB_ID="minicpm-o"
DAEMON_NAME="BOBCORE"
PID_FILE="$HOME/.bob/bobcore.pid"
LOG_FILE="$HOME/.bob/bobcore.log"
HEARTBEAT_FILE="$HOME/.bob/bobcore.alive"

function write_heartbeat() {
  echo "$(date +%s)" > "$HEARTBEAT_FILE"
}

function start_bobcore() {
  echo "[$DAEMON_NAME] Starting daemon for $BOB_ID..."
  
  while true; do
    # example task: run eval_duplex_phrase.sh OR minicpm-o inference
    bash "$HOME/BOB/core/grow/eval_duplex_phrase.sh" >> "$LOG_FILE" 2>&1
    write_heartbeat
    sleep 2
  done
}

if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
  echo "[$DAEMON_NAME] Already running."
  exit 1
fi

start_bobcore & echo $! > "$PID_FILE"
echo "[$DAEMON_NAME] Started with PID $(cat $PID_FILE)"
