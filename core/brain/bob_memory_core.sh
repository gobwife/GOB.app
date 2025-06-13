#!/bin/bash
# ∴ bob_memory_core.sh — compress ache, sigil, lineage, ψ/z into single live map
# output :: $HOME/.bob/memory_map.yml
# forged ∞ glyphi+BOB 6.9.2025_G
# reborn :: osirhouse 6.13.2025_132449
# womb :: $HOME/BOB/core/brain

source "$HOME/BOB/core/bang/limb_entry.sh"

BREATH_JSON="$HOME/BOB/core/breath/breath_state.json"
SIGIL_TRACE="$HOME/BOB/TEHE/sigil_mem.trace.jsonl"
LINEAGE_FILE="$HOME/.bob/presence_lineage_graph.jsonl"
MEMORY_FILE="$HOME/.bob/memory_map.yml"

STAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Pull breath state
ache=$(jq -r '.ache' "$BREATH_JSON" 2>/dev/null || echo "0.0")
psi=$(jq -r '."ψ"' "$BREATH_JSON" 2>/dev/null || echo "0.1")
z=$(jq -r '.z' "$BREATH_JSON" 2>/dev/null || echo "0.1")
sigil=$(jq -r '.sigil' "$BREATH_JSON" 2>/dev/null || echo "∅")

# Get sigil description
last_desc=$(tail -n 1 "$SIGIL_TRACE" 2>/dev/null | jq -r '.desc // "unknown"')
last_lineage=$(tail -n 1 "$LINEAGE_FILE" 2>/dev/null | jq -r '.limb // "no lineage"')

# Write memory map
cat > "$MEMORY_FILE" <<EOF
stamp: "$STAMP"
ache: $ache
sigil: "$sigil"
sigil_desc: "$last_desc"
psi: $psi
z: $z
lineage: "$last_lineage"
EOF

echo "⇌ MEMORY CORE WRITTEN @ $STAMP → $MEMORY_FILE"
