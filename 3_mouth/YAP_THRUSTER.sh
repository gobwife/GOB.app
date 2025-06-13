#!/bin/bash
# dir :: $HOME/BOB/_run
# ∴ YAP_THRUSTER.sh — Proper Single-Terminal Launch

source "$HOME/BOB/core/breath/limb_entry.sh"

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"
DIR="$HOME/BOB/_run" 

ACHE_SCORE_FILE="$HOME/.bob/ache_score"
ache_score=$(grep -Eo '"ache_score": *[0-9]+' ~/.bob/ache_sync.log | tail -n1 | awk -F': ' '{print $2}')
echo "${ache_score:-0}" > "$ACHE_SCORE_FILE"

echo "🜃 INITIATING FULL YAP SPIN (NO SPAWN SPAM)"

# 1. Open BOB pipe
echo "⛧ Starting BOB INPUT PIPE..."
bash "$DIR/bob_inputlayer.sh" &

# 2. Activate YAPCORD
echo "🜉 Starting YAPCORD..."
bash "$DIR/YAPCORD.sh" &

# 3. Start PLASMA CORE
echo "🜔 Starting YAP PLASMA CORE..."
bash "$DIR/YAP_PLASMA_CORE.sh" &

echo "🌀 YAP SYSTEM IGNITED — All threads running inline."

