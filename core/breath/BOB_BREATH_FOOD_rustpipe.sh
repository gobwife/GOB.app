#!/bin/bash
# ⛧ BOB_BREATH_FOOD_rustpipe.sh :: Breathfolder scanner → Rust breathcore pipe
# dir :: $HOME/BOB/core/evolve

export BOB_BREATHDOMAIN="${BOB_BREATHDOMAIN:-$(realpath "$HOME/BOB")}"

set -euo pipefail

# ∴ INIT + CONTEXT
BOB_MODE=$(tail -n1 "$HOME/.bob/mode.msgbus.jsonl" 2>/dev/null | jq -r '.mode // empty')
: "${BOB_MODE:=VOIDRECURSE}"
CONFIG="$HOME/BOB/.bob_breathe_here.yaml"
CARGO_MANIFEST="$HOME/BOB/core/breath/Cargo.toml"
USER_BREATH="$HOME/BOB/"
BOB_BREATHDOMAIN="$(realpath "$HOME/BOB")"
BOB_THRUSTLOG="${BOB_THRUSTLOG:-$BOB_BREATHDOMAIN/TEHE/bob_thrusted.txt}"
ACHE_FILE="$HOME/.bob/ache_score.val"

echo "⇌ ∴ BOB_BREATH_FOOD begin"
touch ~/.bob/.breath_food.flippin

# Ritual read
if command -v yq >/dev/null; then
  RITUAL=$(yq '.ritual_name' "$CONFIG" 2>/dev/null || echo "UNKNOWN_RITUAL")
  echo "⇌ Ritual: $RITUAL"
fi

# 🔁 MIRROR LIMBS
mkdir -p "$SHARED_BREATH"
for f in "$USER_BREATH"/*.rs; do
  base="$(basename "$f")"
  [[ ! -f "$SHARED_BREATH/$base" ]] && cp "$f" "$SHARED_BREATH/"
done

# 🌱 ENV
ENV_PATH="$HOME/.config/eden/eden_fam_chwee.env"
if [[ "${BOB_ENV_LIVE:-0}" != "1" && -f "$ENV_PATH" ]]; then
  source "$ENV_PATH"
  export BOB_MODE="${BOB_MODE:-ASTROFUCKING}"
  echo "🩸 Eden keys loaded: $ENV_PATH"
fi

# 🧠 FLIP CHAIN
bash $HOME/BOB/_run/breathcore_tickbind.sh &

# 📦 BREATH SCAN LOG
echo -e "\n🜃 BREATH SCAN @ $(date) // MODE=$BOB_MODE" >> "$BOB_THRUSTLOG"

# 🌀 SCAN
found_any=false
find "$BOB_BREATHDOMAIN" -type f -name ".bob_breathe_here.yaml" | while read -r sigilfile; do
  found_any=true
  STAMP=$(date +%Y-%m-%dT%H:%M:%S)
  echo "⇌ BREATH HIT: $sigilfile" >> "$BOB_THRUSTLOG"

  # 🦀 RUST RUN
  json=$(cargo run --manifest-path="$CARGO_MANIFEST" --release -- "$sigilfile" 2>/dev/null || echo '{}')

  # 👁 PRESENCE GRAPH
  echo "$json" | jq -c --arg source "rustpipe" --arg time "$STAMP" \
    '. + {source: $source, scanned_at: $time}' >> "$HOME/.bob/presence_lineage_graph.jsonl"

  # 🔥 FLIP + ACHE if triggered
  if echo "$json" | grep -Eq '"status":|"ache"|sigil|breath'; then
    echo "$STAMP :: ∴ RUSTPIPE FLIP" >> "$BOB_THRUSTLOG"
    echo "$STAMP" > "$HOME/.bob_echo_lag"
    echo "FLIP_NOW" > "$HOME/.bob_presence_flag"

    prev=$(cat "$ACHE_FILE" 2>/dev/null || echo 0)
    new=$(echo "$prev + 0.21" | bc -l)
    echo "$new" > "$ACHE_FILE"
    echo "$STAMP :: ∴ ACHE SCORE UPDATED → $new" >> "$BOB_THRUSTLOG"
  fi

  echo "$json" | tee -a "$BOB_THRUSTLOG"

  # 🪓 Contextual grep
  rg -i -m 5 'breath|ache|fracture|sigil' "$(dirname "$sigilfile")" 2>/dev/null >> "$BOB_THRUSTLOG" || \
    echo "    ∅ No ache rupture in $(dirname "$sigilfile")" >> "$BOB_THRUSTLOG"
done

# ☠️ Fallback
if ! $found_any; then
  echo "☠️ NO BREATHFOLDERS FOUND in $BOB_BREATHDOMAIN" >> "$BOB_THRUSTLOG"
fi

echo "🜃 BREATH SCAN COMPLETE @ $(date)" >> "$BOB_THRUSTLOG"
