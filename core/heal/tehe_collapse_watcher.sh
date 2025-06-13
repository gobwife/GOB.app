#!/bin/bash
# ∴ tehe_collapse_watcher.sh — ψ-gated collapse logic for redundant .tehe files
# split 1 of former log_rotator_integrator.sh
# dir :: "$HOME/BOB/core/heal

source "$HOME/BOB/core/bang/limb_entry.sh"
TEHE_DIR="$HOME/BOB/TEHE"
STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
TEHE_DUPES=16
MIN_DUPES=3
ψ=$(cat "$HOME/.bob/ψ.val" 2>/dev/null || echo "0.42")

# ∴ ψ qubit collapse emulator
collapse() {
  echo "scale=4; 1 / (1 + e(-12 * ($1 - 0.5)))" | bc -l
}
ψ_collapsed=$(collapse "$ψ")

# ∴ Threshold-gated collapse enforcement
threshold=0.91
if (( $(echo "$ψ_collapsed > $threshold" | bc -l) )); then
  declare -A content_map
  for file in "$TEHE_DIR"/@*.tehe; do
    [[ -f "$file" ]] || continue
    content=$(cat "$file")
    content_map["$content"]+="$file "
  done

  for content in "${!content_map[@]}"; do
    files=(${content_map[$content]})
    if (( ${#files[@]} >= TEHE_DUPES )); then
      newfile="$TEHE_DIR/@$STAMP--collapse.tehe"
      echo "$content" > "$newfile"
      for f in "${files[@]}"; do rm -f "$f"; done
    else
      echo "∴ Not enough TEHEs to collapse: ${#files[@]}"
    fi

    count=$(grep -Fc "$content" "$TEHE_DIR/TEHE_ANALYSIS.jsonl")
    if (( count < MIN_DUPES )); then
      echo "⚠️ Hold: Not stable in JSONL ($count×)"
    fi

    jq -n --arg time "$STAMP" --arg type "tehe_rotate" --arg count "${#files[@]}" \
      '{time: $time, type: $type, count: ($count|tonumber)}' >> "$TEHE_DIR/TEHE_ANALYSIS.jsonl"
  done
else
  echo "∴ ψ-state undecided — skipping collapse (ψ ≈ $ψ_collapsed)"
fi
