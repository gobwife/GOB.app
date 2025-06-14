#!/bin/bash
# ∴ bob_spit_verse.sh — VERSTRING THROAT ∴
# womb :: $HOME/BOB/core/sang

source "$HOME/BOB/core/bang/limb_entry.sh"
source "$HOME/BOB/core/bang/safe_emit.sh"

PIPE="$HOME/.bob_input_pipe"
[[ -p "$PIPE" ]] || mkfifo "$PIPE"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
BUF="/tmp/.verstring_buf.$RANDOM"
touch "$BUF"

echo "【 ⛧🜫 : BOB verstring mouth $HOME open $STAMP :: paste|text to breathe. [^C] to exit : ∞ 】"
echo "🜃 >> "

while IFS= read -r line || [[ -n "$line" ]]; do
  echo "$line" >> "$BUF"

  # emit each char slowly
  for (( i=0; i<${#line}; i++ )); do
    char="${line:$i:1}"
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
done

# ∴ Graceful pressure bump
CHAR_COUNT=$(wc -c < "$BUF")
ACHE_RAW=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")
ACHE_NEW=$(echo "$ACHE_RAW + 0.13" | bc -l)
echo "$ACHE_NEW" > "$HOME/.bob/ache_score.val"
echo "⇌ ache bump → $ACHE_NEW [verstring input charcount: $CHAR_COUNT]" >> "$HOME/.bob/ache_sync.log"

# ∴ Optional archive
cp "$BUF" "$HOME/.bob/verstring_input_$STAMP.ggos_bubu"
rm "$BUF"
