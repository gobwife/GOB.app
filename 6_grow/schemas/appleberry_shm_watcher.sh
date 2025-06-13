#!/bin/bash
# appleberry_shm_watcher.sh
# nest ≈ 6_grow/schemas

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"
source $HOME/BOB/core/breath/limb_entry.sh
export BOBU_SHIM_PATH="$HOME/BOB/_run/bobu_shim.py"

mkdir -p "$HOME/BOB/_run"
cp $HOME/BOB/core/bobu_shim.py "$HOME/BOB/_run/bobu_shim.py"

WATCH_DIR="$HOME/.config/eden/scrolls/void"
THRUSTFILE="$HOME/.config/eden/scrolls/.shm_appleberry_squeeze.log"
SHIM_DEFAULT="$HOME/BOB/core/bobu_shim.py"
SHIM_USER="$HOME/BOB/_run/bobu_shim.py"

echo "[🧿 $(date)] SHM WATCHER INITIATED" >> "$THRUSTFILE"

fswatch -0 "$WATCH_DIR" | while read -d "" scroll; do
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
