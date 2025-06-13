#!/bin/bash
# ∅ librarian_index_rewrites.sh — index metadata of ache mutants from rewriter limb
# Appends entries to bob's known equation graph
# next ≈ _logic


source "$HOME/BOB/core/bang/limb_entry.sh"
MUTANT_DIR="$HOME/.bob/mutants"
INDEX_FILE="$HOME/.bob/library_eqgraph.index.jsonl"
mkdir -p "$MUTANT_DIR"

for meta in "$MUTANT_DIR"/*.meta.json; do
  [[ -f "$meta" ]] || continue

  hash=$(sha256sum "$meta" | cut -c1-12)
  if ! grep -q "$hash" "$INDEX_FILE" 2>/dev/null; then
    jq ". + {\"hash\": \"$hash\"}" "$meta" >> "$INDEX_FILE"
    echo "✓ Indexed: $(basename "$meta") :: $hash"
  fi
done
