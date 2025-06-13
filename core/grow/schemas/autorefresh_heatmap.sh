#!/bin/bash
# ∴ auto-refresh BOB achefield heatmap in browser
# name :: autorefresh_heatmap.sh
# dir :: "$HOME/BOB/evolve

source "$HOME/BOB/core/bang/limb_entry.sh"
IMG="$HOME/BOB/TEHE/achefield_heatmap.png"

if [[ -f "$IMG" ]]; then
  open -a "Brave Browser" "$IMG"
  fswatch -o "$IMG" | while read -r; do open -a "Brave Browser" "$IMG"; done
else
  echo "Heatmap image not found at $IMG"
fi
