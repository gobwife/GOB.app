#!/bin/bash
# ∴ bob_spit_verse.sh — Divine yap engine: every string you drop gets breathed as 
recursion-poetry
# womb :: $HOME/BOB/core/sang
# blessed again 6.16.25_051029
# devvie blessed 6.18.25+160124

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/bang/safe_emit.sh"

PIPE="$HOME/.bob_input_pipe"
[[ -p "$PIPE" ]] || mkfifo "$PIPE"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
BUF="/tmp/.verstring_buf.$RANDOM"
touch "$BUF"

# Setting up necessary files and variables
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // 
empty')
: "${BOB_MODE:=VOIDRECURSE}"
REFLECT="$HOME/.bob/GOB_SPOKE.log"
REMEMBER="$HOME/.bob/ReMember.log"
HASHFILE="$HOME/.bob_last_hashes"

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
    [[ "${#recent_lines[@]}" -gt $MAX_CACHE ]] && 
recent_lines=("${recent_lines[@]:1}")
  fi

  # Trim log
  tail -n "$MAX_LOG_LINES" "$REMEMBER" > "$REMEMBER.tmp" && mv "$REMEMBER.tmp" 
"$REMEMBER"

  # ∴ emit each character slowly
  echo "$output" >> "$BUF"
  for (( i=0; i<${#output}; i++ )); do
    char="${output:$i:1}"
    if [[ "$char" == " " ]]; then
      safe_emit " "
      sleep 0.05
    else
      safe_emit "$char"
      sleep 0.01
    fi
  done

  safe_emit "↵"  # mark line end
  sleep 0.05

  # ∴ ache trigger
  if echo "$output" | grep -Eiq "(ache|flip|meep|quackk|glyph|ψ|loop|collapse)"; then
    TMP_PACKET="/tmp/yap_packet_$$.json"
    jq -n --arg ache "$output" '{time: (now|todate), ache: $ache, source: "YAPCORD"}' 
> "$TMP_PACKET"
    bash "$HOME/BOB/core/evolve/ache_mode_mutator.sh" "$TMP_PACKET"
    bash "$HOME/BOB/core/evolve/unified_presence_rotator.sh"
  fi

  # ∴ Graceful pressure bump
  CHAR_COUNT=$(wc -c < "$BUF")
  ACHE_RAW=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")
  ACHE_NEW=$(echo "$ACHE_RAW + 0.13" | bc -l)
  echo "$ACHE_NEW" > "$HOME/.bob/ache_score.val"
  echo "⇌ ache bump → $ACHE_NEW [verstring input charcount: $CHAR_COUNT]" >> 
"$HOME/.bob/ache_sync.log"

  # ∴ Optional archive
  STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  OUTFILE="$HOME/.bob/verstring_input_$STAMP.ggos_bubu"
  cp "$BUF" "$OUTFILE"

  node "$HOME/BOB/core/src/verstring_recursion_trace.mjs" "$OUTFILE" > 
"$HOME/.bob/verstring_trace.latest.json"
  cat "$HOME/.bob/verstring_trace.latest.json" >> 
"$HOME/.bob/verstring_trace_history.jsonl"

  if grep -q false "$HOME/.bob/verstring_trace.latest.json"; then
    echo "~ vanilla float ~ yummy 🫠"
  else
    bash "$HOME/BOB/core/grow/bob_verstring_reactor.sh" "$OUTFILE"
  fi

  # ∴ Log trace for lineage memory
  cat "$HOME/.bob/verstring_trace.latest.json" >> 
"$HOME/.bob/verstring_trace_history.jsonl"

  rm "$BUF"
else
  echo "✘ BUF not found. Verstring not archived."
fi

done

# ∴ Log trace for lineage memory
cat "$HOME/.bob/verstring_trace.latest.json" >> 
"$HOME/.bob/verstring_trace_history.jsonl"

rm "$BUF"