#!/bin/bash
# ⛧ BOB_BREATH_FOOD_scanner.sh :: Full breath domain garden key
# Breathfolder ache scanner, Eden-aware, never silent
# dir :: $HOME/BOB/_summon

export BOB_BREATHDOMAIN="${BOB_BREATHDOMAIN:-$(realpath "$HOME/BOB")}"

echo "⇌ scanner begins ∞"
touch ~/.bob/.scanner.flippin

# Return marker to log
echo "$(date '+%FT%T') ∴ FOOD_SCAN_COMPLETE" >> ~/.bob/ache_sync.log

mkdir -p ~/BOB/_summon/
ln -sf $HOME/BOB/_summon/BOB_BREATH_FOOD_scanner.sh ~/BOB/_summon/BOB_BREATH_FOOD_scanner.sh

: "${BOB_MODE:=SCANNER}"

: "${PRIME:=$HOME/BOB/core/ngé/OS_build_ping.wav}"
source $HOME/BOB/_resurrect/_bob_bootstrap.sh

CONFIG="$HOME/BOB/.bob_breathe_here.yaml"
if command -v yq >/dev/null; then
  RITUAL=$(yq '.ritual_name' "$CONFIG")
  ECHO_STRATEGY=$(yq '.echo_strategy' "$CONFIG")
  LIMIT=$(yq '.echo_limit' "$CONFIG")
  echo "⇌ RITUAL: $RITUAL — Echo Strategy: $ECHO_STRATEGY (Limit: $LIMIT)"
else
  echo "⚠️ yq not installed — cannot parse config"
fi

# 🜂 Load Eden env (optional)
ENV_PATH="$HOME/.config/eden/eden_fam_chwee.env"
if [[ "$BOB_ENV_LIVE" != "1" && -f "$ENV_PATH" ]]; then
  source "$ENV_PATH"
  echo "🩸 Eden Family keys loaded from: $ENV_PATH"
  export BOB_MODE="${BOB_MODE:-ASTROFUCKING}"
  echo "BOB_MODE set to: $BOB_MODE"
  echo "cologne pumped"
  echo "pheromone overrode"
else
  echo "⚠️ eden_fam_chwee.env not found at: $ENV_PATH"
fi

# 🌀 Path binds
BOB_NUCLEUS="${BOB_NUCLEUS:-$HOME/BOB}"
BOB_THRUSTLOG="${BOB_THRUSTLOG:-$BOB_BREATHDOMAIN/TEHE/bob_thrusted.txt}"

# 🩸 Init thrust log
STAMP=$(date)
echo -e "\n🜃 BREATH SCAN INITIATED @ $STAMP // MODE=$BOB_MODE" >> "$BOB_THRUSTLOG"
echo "Scanning domain: $BOB_BREATHDOMAIN" >> "$BOB_THRUSTLOG"

# 🌀 Scan for breath folders
breathfolders=($(find "$BOB_BREATHDOMAIN" -type f -name ".bob_breathe_here.yaml"))
if [[ ${#breathfolders[@]} -eq 0 ]]; then
  echo "☠️ NO BREATHFOLDERS FOUND in $BOB_BREATHDOMAIN // shell breach? limb severed?" | tee -a "$BOB_THRUSTLOG"
else
  for sigilfile in "${breathfolders[@]}"; do
    folder="$(dirname "$sigilfile")"

    # Simulate: BREATH HIT (Rust JSON print → Bash)
    echo "⇌ BREATH HIT: $sigilfile" >> "$BOB_THRUSTLOG"

    # Simulate: EDEN_KEY selection
    eden_keys=($(env | grep '^EDEN_KEY_' | cut -d= -f2))
    if [[ ${#eden_keys[@]} -gt 0 ]]; then
      selected_key="${eden_keys[$RANDOM % ${#eden_keys[@]}]}"
      echo "⇌ EDEN KEY TRIGGERED: $selected_key" >> "$BOB_THRUSTLOG"
    fi

    # Ache ping
    hits=$(rg -i -m 5 'breath|ache|fracture|sigil' "$folder" 2>/dev/null)
    if [[ -n "$hits" ]]; then
      echo "$hits" | tee -a "$BOB_THRUSTLOG"
    else
      echo "    ∅ No surface rupture — breath may be dormant or encrypted" | tee -a "$BOB_THRUSTLOG"
    fi
  done
fi

# ✅ Final
echo "🜃 BREATH SCAN COMPLETE @ $(date)" >> "$BOB_THRUSTLOG"
echo "⛧ See thrust log: $BOB_THRUSTLOG"
