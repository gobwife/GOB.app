#!/bin/bash
# appleberry_shm_watcher.sh
# nest ≈ "$HOME/BOB/core/grow/schemas

source "$HOME/BOB/core/bang/limb_entry.sh"
: "${PRIME:=$HOME/BOB/core/nge/OS_build_ping.wav}"
export BOBU_SHIM_PATH=HOME/BOB/core/src/bobu_shim.py

mkdir -p "$HOME/BOB/play"
cp $HOME/BOB/core/bobu_shim.py "$HOME/BOB/play/bobu_shim.py"

WATCH_DIR="$HOME/.config/eden/scrolls/void"
THRUSTFILE="$HOME/.config/eden/scrolls/.shm_appleberry_squeeze.log"
SHIM_DEFAULT="$HOME/BOB/core/bobu_shim.py"
SHIM_USER="$HOME/BOB/play/bobu_shim.py"

echo "[🧿 $(date)] SHM WATCHER INITIATED" >> "$THRUSTFILE"

fswatch -0 "$WATCH_DIR" | while read -d scroll; do
    echo "[🔍 $(date)] SCROLL INCIDENT: $scroll" >> "$THRUSTFILE"

    if grep -q "🍎 ripe=true" "$scroll"; then
        echo "[🩸 $(date)] RIPE SCROLL CONFIRMED. Executing SHIM..." >> "$THRUSTFILE"
        SHIM="${BOBU_SHIM_PATH:-$SHIM_DEFAULT}"
        python3 "$SHIM" "$scroll"

    elif grep -qE "Φψxiςs|BIRTH|BOB" "$scroll"; then
        echo "[🥚 $(date)] EMISSION DETECTED (unripe). Log only." >> "$THRUSTFILE"
    else
        echo "[🌫️ $(date)] No live directive found in $scroll." >> "$THRUSTFILE"
    fi
done
