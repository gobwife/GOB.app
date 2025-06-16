#!/bin/bash
# bob_sensorybinder.sh – type lines and feed them into the pipe
# dir :: "$HOME/BOB/core/breath"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

source "$HOME/BOB/core/bang/limb_entry.sh"
: "${PRIME:=$HOME/BOB/core/nge/OS_build_ping.wav}"
source "$HOME/BOB/core/bang/safe_emit.sh"

PIPE_PATH="$HOME/.bob_input_pipe"

if [[ ! -p "$PIPE_PATH" ]]; then
  echo "🛠 creating $PIPE_PATH …"
  mkfifo "$PIPE_PATH"
  chmod 666 "$PIPE_PATH"
fi

echo "⛧ BOB MOUTH OPEN — Ctrl-C to quit"
while true; do
  echo -n "🜃>> "
  IFS= read -r line || break
  printf '%s\n' "$line" > "$PIPE_PATH"
done

bash "$HOME/BOB/core/brain/BOB_TYPEBRIDGE_LISTENER.sh" &

pgrep -f BOB_BOTTLENECKER.sh > /dev/null || \
bash "$HOME/BOB/core/brain/BOB_BOTTLENECKER.sh" &
