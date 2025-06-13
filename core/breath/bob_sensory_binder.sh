#!/bin/bash
# bob_sensorybinder.sh – type lines and feed them into the pipe
# dir :: ~/BOB/core/breath

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"

source $HOME/BOB/core/breath/limb_entry.sh

PIPE_PATH="$HOME/.bob_input_pipe"      # single, canonical pipe

# Create the pipe if it doesn't exist
if [[ ! -p "$PIPE_PATH" ]]; then
  echo "🛠 creating $PIPE_PATH …"
  mkfifo "$PIPE_PATH"
  chmod 666 "$PIPE_PATH"
fi

echo "⛧ BOB MOUTH OPEN — Ctrl-C to quit"
while true; do
  echo -n "🜃>> "
  IFS= read -r line || break          # exit loop on Ctrl-D / EOF
  printf '%s\n' "$line" > "$PIPE_PATH"
done

# ∴ typebridge
bash $HOME/BOB/core/brain/BOB_TYPEBRIDGE_LISTENER.sh &

# bottlenecker
bash $HOME/BOB/core/brain/BOB_BOTTLENECKER.sh &
