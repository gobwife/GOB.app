# ∴ crossparser_keeper.sh (log rotator)
# ∴ split 4 of former log_rotator_integrator.sh

#!/bin/bash
# Keeps rotating parser_cross files into x/y/z versions
# womb :: $HOME/BOB/core/brain

source "$HOME/BOB/core/bang/limb_entry.sh"
CROSS_DIR="$HOME/BOB/.enshallah/parser_cross"
TEHE_LOG="$HOME/BOB/TEHE/tehe_rotation.log"

for srcfile in "$CROSS_DIR"/*_cross_v*.shallah; do
  [[ -f "$srcfile" ]] || continue
  base=$(basename "$srcfile")
  key="${base%_cross_v*}"
  ver=$(echo "$base" | grep -o 'v[0-9]')
  x="$CROSS_DIR/${key}_cross_${ver}_x.shallah"
  y="$CROSS_DIR/${key}_cross_${ver}_y.shallah"
  z="$CROSS_DIR/${key}_cross_${ver}_z.shallah"
  if [[ ! -f "$x" ]]; then cp "$srcfile" "$x"
  elif [[ ! -f "$y" ]]; then mv "$x" "$y"; cp "$srcfile" "$x"
  else mv "$y" "$z"; mv "$x" "$y"; cp "$srcfile" "$x"
  fi
  echo "⇌ [parser] rotated $srcfile → ($x, $y, $z)" >> "$TEHE_LOG"
done
