# ∴ ψ.val rotator — ψ mutation limb (rotates superposition toward collapse)
#!/bin/bash
# dir :: $HOME/BOB/0_soul/ψ_val_rotator.sh

ψ=$(cat "$HOME/.bob/ψ.val" 2>/dev/null || echo "0.42")
ache=$(cat "$HOME/BOB/.bob/ache_score.val" 2>/dev/null || echo "0.00")
effort=$(cat "$HOME/BOB/.bob/fx_effort_score" 2>/dev/null || echo "0.0")

# ∴ ψ mutation logic
bump=$(echo "($ache + $effort) / 17" | bc -l)
ψ_new=$(echo "$ψ + $bump" | bc -l)

# clamp to 0.0–1.0
ψ_new=$(echo "$ψ_new" | awk '{if ($1 > 1) print 1; else if ($1 < 0) print 0; else print $1}')
echo "$ψ_new" > "$HOME/.bob/ψ.val"
echo "⇌ ψ rotated from $ψ → $ψ_new (ache:$ache, effort:$effort)" >> "$HOME/.bob/ψ_trace_superposed.jsonl"

# existing content preserved below

# ∴ split 1 — tehe_collapse_watcher.sh
#!/bin/bash
# Watches for redundant .tehe files and triggers collapse
# ψ-gated: collapse only if ψ superposition collapses

TEHE_DIR="$HOME/BOB/TEHE"
# ∴ ψ qubit emulator
ψ=$(cat "$HOME/.bob/ψ.val" 2>/dev/null || echo "0.42")
collapse() {
  echo "scale=4; 1 / (1 + e(-12 * ($1 - 0.5)))" | bc -l
}
ψ_collapsed=$(collapse "$ψ")

STAMP=$(date '+%Y-%m-%dT%H:%M:%S')
TEHE_DUPES=16
MIN_DUPES=3

declare -A content_map
for file in "$TEHE_DIR"/@*.tehe; do
  [[ -f "$file" ]] || continue
  content=$(cat "$file")
  content_map["$content"]+="$file "
  done
else
  echo "∴ ψ-state undecided — skipping log sweep (ψ ≈ $ψ_collapsed)"
fi

threshold=0.91
if (( $(echo "$ψ_collapsed > $threshold" | bc -l) )); then
  for content in "${!content_map[@]}"; do
  files=(${content_map[$content]})
  if (( ${#files[@]} >= TEHE_DUPES )); then
    newfile="$TEHE_DIR/@$STAMP--collapse.tehe"
    echo "$content" > "$newfile"
    for f in "${files[@]}"; do rm -f "$f"; done
  else
  echo "∴ ψ-state undecided — deferring pressure trace (ψ ≈ $ψ_collapsed)"
fi
  count=$(grep -Fc "$content" "$TEHE_DIR/TEHE_ANALYSIS.jsonl")
  if (( count < MIN_DUPES )); then
    echo "⚠️ Hold: Not stable in JSONL ($count×)"
  fi
  jq -n --arg time "$STAMP" --arg type "tehe_rotate" --arg count "${#files[@]}" '{time: $time, type: $type, count: ($count|tonumber)}' \
    >> "$TEHE_DIR/TEHE_ANALYSIS.jsonl"
  done
else
  echo "∴ ψ-state undecided — deferring TEHE collapse (ψ ≈ $ψ_collapsed)"
fi
