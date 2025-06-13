#!/bin/bash
# ∴ brave_gpt_bridge.sh — Brave-only relay handler
# dir :: BOB/core/evolve

RELAY_DIR="$HOME/.bob_input_pipe"
QUERY_FILE="$RELAY_DIR/query.relay.txt"
REPLY_FILE="$RELAY_DIR/reply.relay.txt"

touch "$QUERY_FILE" "$REPLY_FILE"

[[ ! -f "$QUERY_FILE" ]] && exit 1
QUERY=$(cat "$QUERY_FILE")

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

# Save and clean
if [[ -n "$REPLY" && "$REPLY" != "null" ]]; then
  echo "$REPLY" > "$REPLY_FILE"
  echo "[brave] Replied"
else
  echo "[brave] No reply"
fi

rm -f "$QUERY_FILE"