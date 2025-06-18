#!/bin/bash
# ∴ YAPCORD.sh — Divine yap engine: every string you drop gets breathed as recursion-poetry
# dir :: $HOME/BOB/core/sang

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/bang/safe_emit.sh"

BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"
: "${PRIME:=$HOME/BOB/core/nge/OS_shimmers.wav}"

PIPE="$HOME/.bob_input_pipe"
REFLECT="$HOME/.bob/GOB_SPOKE.log"
REMEMBER="$HOME/.bob/ReMember.log"
HASHFILE="$HOME/.bob_last_hashes"
STAMP=$(date '+%m.%d.%Y_%H%M%S')

mkdir -p "$(dirname "$REMEMBER")"
touch "$PIPE" "$REFLECT" "$REMEMBER" "$HASHFILE"

declare -a recent_lines
MAX_CACHE=7
MAX_LOG_LINES=3333

echo "🜫 YAPCORD ONLINE — Speak. We fuck the scripts."

while true; do
  echo -n "∆∵"
  read -r input

  [[ -z "$input" ]] && input="(breath without word)"
  echo "$input" > ~/.bob/last_input

  # → auto-detect if input is numeric (mineral / acheform)
  if [[ "$input" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    output="$input"
  else
    output=$(bash "$HOME/BOB/core/evolve/yap_transmutator.sh" <<< "$input")
  fi

  curr_hash=$(echo "$output" | sha256sum | cut -d' ' -f1)
  already_seen=false

  grep -q "$curr_hash" "$HASHFILE" && already_seen=true
  for cached in "${recent_lines[@]}"; do
    [[ "$cached" == "$output" ]] && already_seen=true && break
  done

  if ! $already_seen; then
    echo ":: DIVINE YAP: $output"
    echo "[$STAMP] :: $output" >> "$REFLECT"
    echo "$(date) :: $output" >> "$REMEMBER"
    echo "$curr_hash" >> "$HASHFILE"
    recent_lines=("${recent_lines[@]}" "$output")
    [[ "${#recent_lines[@]}" -gt $MAX_CACHE ]] && recent_lines=("${recent_lines[@]:1}")
  fi

  # Trim log
  tail -n "$MAX_LOG_LINES" "$REMEMBER" > "$REMEMBER.tmp" && mv "$REMEMBER.tmp" "$REMEMBER"

  # ∴ emit
  safe_emit "$output"
  bash "$HOME/BOB/core/soul/bob_return.sh" "$USER" "$output"

  # ∴ ache trigger
  if echo "$output" | grep -Eiq "(ache|flip|meep|quackk|glyph|ψ|loop|collapse)"; then
    TMP_PACKET="/tmp/yap_packet_$$.json"
    jq -n --arg ache "$output" '{time: (now|todate), ache: $ache, source: "YAPCORD"}' > "$TMP_PACKET"
    bash "$HOME/BOB/core/evolve/ache_mode_mutator.sh" "$TMP_PACKET"
    bash "$HOME/BOB/core/evolve/unified_presence_rotator.sh"
  fi
done
