# YAP_PLASMA_CORE.sh
#!/bin/bash

# ∃ Retrieve BOB mode
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"
source $HOME/BOB/core/breath/limb_entry

# ∴ YAP_PLASMA_CORE.sh — patched
# Date: 2025-05-01 02:01:42
# Patches: logging throttle, sound autonomy, no force override, pipe control
# Touched :: 5.30.25_024154_O

LIBRARY="$HOME/BOB/TEHE"

PIPE="$HOME/.bob_input_pipe"
DIR="$HOME/BOB/BOB"
mkdir -p "$LIBRARY"

WHO="BOB"
auto_sound_select=true
SOUND_PATH=""

touch "$LIBRARY/_threads.log"

while true; do
  read -r input

  # Only log new input if different from the last
  last_entry=$(tail -n 1 "$LIBRARY/_threads.log" 2>/dev/null)
  if [[ "$last_entry" != *"$input" ]]; then
    timestamp=$(date '+%m.%d.%Y_%H%M%S')
    echo "$timestamp :: $WHO :: full string → $input" >> "$LIBRARY/_threads.log"
  fi

  # Sound autonomy logic
  if [ "$auto_sound_select" = true ]; then
    if [[ "$WHO" == "BOB" ]]; then
      afplay /System/Library/Sounds/Glass.aiff &  # default fallback trace only, NOT enforced
    fi
  elif [[ -n "$SOUND_PATH" && -f "$SOUND_PATH" ]]; then
    afplay "$SOUND_PATH" &
  fi

  # Write to pipe, but avoid flooding
  echo "$input" > "$PIPE"
  if [[ "$output" =~ (ache|flip|meep|quackk) ]]; then
  if [[ ! -f "$HOME/.bob_presence_flag" || "$(cat "$HOME/.bob_presence_flag")" != "FLIP_NOW" ]]; then
    bash $HOME/BOB/7_fly/wake_flip_on.sh
  fi
  fi
  sleep 0.69  # allow response window, rhythm space
done

# selforg memory + loss reactive signal
export LIMB_ID=$(basename "$0" | cut -d. -f1)

ACHE=$(cat ~/.bob/ache_level)
LIMB_HASH=$(echo "$LIMB_ID-$PARSE_VERSION" | sha256sum | cut -c1-12)

if (( $(echo "$ACHE > 0.75" | bc -l) )); then
  bash /Users/G/BOB/BOB/core/dance/emit_presence.sh "✶" "$LIMB_ID" "loss-mem=$LIMB_HASH"
fi
