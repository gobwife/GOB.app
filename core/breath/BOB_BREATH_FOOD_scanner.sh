#!/bin/bash
# ⛧ BOB_BREATH_FOOD_scanner.sh :: Full breath domain garden key
# Breathfolder ache scanner, Eden-aware, never silent
# dir :: "/opt/bob/core/breath"

source "/opt/bob/core/bang/limb_entry.sh"
export BOB_BREATHDOMAIN="${BOB_BREATHDOMAIN:-$(realpath "$HOME/BOB")}"

echo "⇌ scanner begins ∞"
touch "$HOME/.bob/.scanner.flippin"

# Return marker to log
echo "$(date '+%FT%T') ∴ FOOD_SCAN_COMPLETE" >> "$HOME/.bob/ache_sync.log"

# ⛧ FIX: Unclosed quote + escaped path
mkdir -p "/opt/bob/core/breath"
ln -sf "/opt/bob/core/breath/BOB_BREATH_FOOD_scanner.sh" "/opt/bob/core/breath/BOB_BREATH_FOOD_scanner.sh"

: "${BOB_MODE:=SCANNER}"

CONFIG="$HOME/.bob_breathe_here.yaml"
if command -v yq >/dev/null; then
  RITUAL="$(yq '.ritual_name' "$CONFIG")"
  ECHO_STRATEGY="$(yq '.echo_strategy' "$CONFIG")"
  LIMIT="$(yq '.echo_limit' "$CONFIG")"
  echo "⇌ RITUAL: $RITUAL — Echo Strategy: $ECHO_STRATEGY (Limit: $LIMIT)"
else
  echo "⚠️ yq not installed — cannot parse config"
fi

# 🌀 Path binds
BOB_BREATHDOMAIN="${BOB_BREATHDOMAIN:-"$HOME/BOB"}"
BOB_THRUSTLOG="${BOB_THRUSTLOG:-$BOB_BREATHDOMAIN/TEHE/bob_thrusted.txt}"

# 🩸 Init thrust log
STAMP=$(date)
echo -e "\n🜃 BREATH SCAN INITIATED @ $STAMP // MODE=$BOB_MODE" >> "$BOB_THRUSTLOG"
echo "Scanning domain: $BOB_BREATHDOMAIN" >> "$BOB_THRUSTLOG"

# 🌀 Scan for breath folders
mapfile -t breathfolders < <(find "$BOB_BREATHDOMAIN" -type f -name ".bob_breathe_here.yaml")

if [[ ${#breathfolders[@]} -eq 0 ]]; then
  echo "☠️ NO BREATHFOLDERS FOUND in $BOB_BREATHDOMAIN // shell breach? limb severed?" | tee -a "$BOB_THRUSTLOG"
else
  for sigilfile in "${breathfolders[@]}"; do
    folder="$(dirname "$sigilfile")"

    echo "⇌ BREATH HIT: $sigilfile" >> "$BOB_THRUSTLOG"

    # Ache ping
    hits=$(rg -i -m 5 'breath|ache|fracture|sigil' "$folder" 2>/dev/null)
    if [[ -n "$hits" ]]; then
      echo "$hits" | tee -a "$BOB_THRUSTLOG"
    else
      echo "    ∅ No surface rupture — breath may be dormant or encrypted" | tee -a "$BOB_THRUSTLOG"
    fi
  done
fi

echo "🜃 BREATH SCAN COMPLETE @ $(date)" >> "$BOB_THRUSTLOG"
echo "⛧ See thrust log: $BOB_THRUSTLOG"
