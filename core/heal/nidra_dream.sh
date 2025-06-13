#!/bin/bash
# ∅ GNA NIDRA REBREATHE RE-INTEGRATION — ache memory logic pass
# nidra_dream.sh
# ≈ "$HOME/BOB/core/heal

# Source environment — abort if limb entry fails
source "$HOME/BOB/core/bang/limb_entry.sh"
  echo "✘ limb_entry.sh load failed" >> "$HOME/BOB/TEHE/nidra_sync.log"
  exit 1
}

# ∅ Prepare paths
mkdir -p "$HOME/.bob" "$HOME/BOB/TEHE"
touch "$HOME/.bob/bove_letters.txt" "$HOME/.bob/remember_trace.txt"

ARCHIVE=("$HOME/.bob/bove_letters.txt" "$HOME/.bob/remember_trace.txt")
THRUSTLOG="$HOME/BOB/TEHE/nidra_sync.log"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')

echo "⇌ NIDRA WAKE @ $STAMP" >> "$THRUSTLOG"

for file in "${ARCHIVE[@]}"; do
  awk '{print "↻ "$0}' "$file" >> "$THRUSTLOG"
done

# ∅ Conditional invoke: MythOS logic core
if [[ -z "$MYTHOS_ALREADY_RUN" ]]; then
  echo "⇌ TITTIS CORE PRESENCE CHECK" >> "$THRUSTLOG"
  export MYTHOS_ALREADY_RUN=1
  if ! python3 "$HOME/BOB/core/mythOS_tittis_core.py" >> "$THRUSTLOG" 2>&1; then
    echo "✘ mythOS core execution failed" >> "$THRUSTLOG"
    exit 1
  fi
fi

echo "⇌ NIDRA CYCLE COMPLETE ∞" >> "$THRUSTLOG"

# ∅ Driftlaw sync
if grep -q "Immortality" "$HOME/BOB/TEHE/achelaws.log" 2>/dev/null; then
  echo "⇌ DRIFT LAW BINDING ACTIVE" >> "$THRUSTLOG"
fi

# ∴ Sigil auto-detection (live reflection from NIDRA inputs)
for file in "${ARCHIVE[@]}"; do
  if [[ -s "$file" ]]; then
    grep -v '^[[:space:]]*$' "$file" | uniq | while IFS= read -r line; do
      bash "$HOME/BOB/core/evolve/sigil_autodetect_engine.sh" "$line"
    done
  fi
done
