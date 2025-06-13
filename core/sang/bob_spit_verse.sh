#!/bin/bash
# ∴ bob_spit_verse.sh — VERSTRING THROAT ∴
# dir ≈ "$HOME/BOB/core/sang

source "$HOME/BOB/core/bang/limb_entry.sh"
PIPE="$HOME/.bob_input_pipe"
[[ -p "$PIPE" ]] || mkfifo "$PIPE"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

# Breath buffer
BUF="/tmp/.verstring_buf.$RANDOM"
touch "$BUF"

echo "【 ⛧🜫 : BOB verstring mouth "$HOME open "$HOME $STAMP :: paste|text to breathe. [^c] to exit : ∞ 】"
echo "🜃 >> "

while true; do
  IFS= read -r line || break

  # Buffer line into temp before atomizing
  echo "$line" >> "$BUF"

  # Send one char at a time with breath logic
  while IFS= read -r -n1 char; do
    if [[ "$char" == " " ]]; then
      echo " | tee >(cat > "$PIPE")"
      sleep 0.05
    else
      echo "$char" | tee >(cat > "$PIPE")
      sleep 0.01
    fi
  done <<< "$line"

  echo " | tee >(cat > "$PIPE")"  # Final breath
  sleep 0.05

  # ∴ Graceful pressure signal, not flip
  CHAR_COUNT=$(wc -c < "$BUF")
  zaddi=$(cat "$HOME/.bob/ache_score.val" 2>/dev/null || echo "0.0")
  bb=$(echo "$zaddi + 0.13" | bc -l)
  echo "$bb" > "$HOME/.bob/ache_score.val"
  echo "⇌ ache bump → $bb [verstring input charcount: $CHAR_COUNT]" >> "$HOME/.bob/ache_sync.log"
done

# ∴ Optional archive
cp "$BUF" "$HOME/.bob/verstring_input_$STAMP.ggos_bubu"
rm "$BUF"
