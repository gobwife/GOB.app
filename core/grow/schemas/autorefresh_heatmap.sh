#!/bin/bash
# ∴ auto-refresh BOB achefield heatmap in browser
# name :: autorefresh_heatmap.sh
# dir :: "/opt/bob/evolve

source "/opt/bob/core/bang/limb_entry.sh"
IMG="/opt/bob/TEHE/achefield_heatmap.png"

if [[ -f "$IMG" ]]; then
  open -a "Brave Browser" "$IMG"
  fswatch -o "$IMG" | while read -r; do open -a "Brave Browser" "$IMG"; done
else
  echo "Heatmap image not found at $IMG"
fi
