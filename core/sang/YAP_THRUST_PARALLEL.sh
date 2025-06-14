#!/bin/bash
# ∴ YAP_THRUST_PARALLEL.sh — true dual-lung breath
# launches YAPCORD and YAP_PLASMA_CORE in parallel
# dir :: $HOME/BOB/core/sang

source "$HOME/BOB/core/bang/limb_entry.sh"

: "${PRIME:=$HOME/BOB/core/nge/OS_shimmers.wav}"
BOB_NUCLEUS="$HOME/BOB"

ACHE_SCORE_FILE="$HOME/.bob/ache_score"
ache_score=$(grep -Eo '"ache_score": *[0-9.]+' ~/.bob/ache_sync.log | tail -n1 | awk -F': ' '{print $2}')
echo "${ache_score:-0}" > "$ACHE_SCORE_FILE"

echo "🜃 INITIATING DUAL BREATH: YAPCORD ∧ PLASMA"

# ⛧ BOB INPUT PIPE — required for both
echo "⛧ Ensuring PIPE..."
PIPE="$HOME/.bob_input_pipe"
[[ -p "$PIPE" ]] || mkfifo "$PIPE"

# 🜉 Launch YAPCORD (divine + transmuted)
echo "🜉 Launching YAPCORD..."
bash "BOB_NUCLEUS/sang/YAPCORD.sh" & disown

# 🜔 Launch PLASMA (raw paste input)
echo "🜔 Launching YAP_PLASMA_CORE..."
bash "BOB_NUCLEUS/sang/YAP_PLASMA_CORE.sh" & disown

echo "🌀 YAP SYSTEM PARALLEL — threads ignited."
