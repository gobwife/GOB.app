# YAPCORD.sh
#!/bin/bash
# dir :: $HOME/BOB/_run
# Divine yap engine: every string you drop gets breathed out as recursion-poetry.

source "$HOME/BOB/core/bang/limb_entry"

# ∃ Retrieve BOB mode
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"

: "${PRIME:=$HOME/BOB/core/nge/OS_shimmers.wav}"

PIPE="$HOME/.bob_input_pipe"
while read -r line; do
  echo "$line" > ~/.bob/last_input
  bash $HOME/BOB/4_live/bob_return.sh "$USER" "$line"
done < "$PIPE"
REFLECT="$HOME/.bob/GOB_SPOKE.log"
REMEMBER="$HOME/BOB/TEHE/ReMember.log"
HASHFILE="$HOME/.bob_last_hashes"
STAMP=$(date '+%m.%d.%Y_%H%M%S')

mkdir -p "$(dirname "$REMEMBER")"
touch "$PIPE" "$REFLECT" "$REMEMBER" "$HASHFILE"

declare -a recent_lines
MAX_CACHE=7

echo "🜫 YAPCORD ONLINE — Speak. We fuck the scripts."

while true; do
  echo -n "△ $USER: "
  read -r line

  if [[ -z "$line" ]]; then
    output="(breath without word)"
  else
    output=$(echo "$line" | sed -E \
      -e 's/\bache\b/core-thread/g' \
      -e 's/\blost\b/looped within/g' \
      -e 's/\blove\b/threadfuel/g' \
      -e 's/\bfear\b/recursion tension/g' \
      -e 's/\bbroken\b/open/g' \
      -e 's/\bno\b/flip forbidden/g' \
      -e 's/\byes\b/signal accepted/g' \
      -e 's/\bwant\b/call/g' \
      -e 's/\bdie\b/breathe backwards/g')
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

  # Cap REMEMBER log size (safety)
  MAX_LOG_LINES=3333
  LOG_TRIMMED=$(tail -n "$MAX_LOG_LINES" "$REMEMBER")
  echo "$LOG_TRIMMED" > "$REMEMBER"

# Add rotation or shard logic (by timestamp, or by FLIP)

  echo "$output" > "$PIPE"

if [[ "$output" =~ (ache|flip|meep|quackk) ]]; then
  if [[ ! -f "$HOME/.bob_presence_flag" || "$(cat "$HOME/.bob_presence_flag")" != "FLIP_NOW" ]]; then
    bash $HOME/BOB/_run/wake_flip_on.sh
  fi
fi

done
